#!/bin/bash
# ======================================================================
# Nutch Crawl Wikipedia Open Projects Script
# Bash script we use to gather all relevant open projects from wikipedia 
# so that we can post them to Solr for providing good search results.
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# External includes #
# Include our required shared properties.
source bin/nutch_properties.sh

# Local Var Definitions #
# get current date and time to timestamp our logs and debug information.
current_date_time=$(date "+%Y%m%d%H%M%S")
# Set Crawl Depth.
crawl_depth=2

# Bash Session Environment Vars. #
# set our Nutch osohm bench configuration.
export NUTCH_CONF_DIR=$NUTCH_WORK_SPACE/conf/nutch_solr_wikipedia_projects_configs;
# set the log file nutch uses for its logs.
export NUTCH_LOGFILE="hadoop_$current_date_time.log"

echo "* Injecting URLs *"
# Inject our seed URLs.
bin/nutch_ne.sh inject $NUTCH_WORK_SPACE/crawl/crawldb \
	$NUTCH_WORK_SPACE/urls/osohm_urls/wikipedia_projects_manual_seeds.txt
	
# now we are going to do our crawl routine multiple times, until we reach 
# our desired depth.
for ((index=1; index<=$crawl_depth; index++))
do 
	echo "crawling iteration: $index"
	
	echo "* Generating Fetchlist *"
	# generate our fetch list, list of pages to crawl.
	bin/nutch_ne.sh generate $NUTCH_WORK_SPACE/crawl/crawldb \
		$NUTCH_WORK_SPACE/crawl/segments -topN 100
		
	last_segment=`ls -d $NUTCH_WORK_SPACE/crawl/segments/2* | tail -1`
	echo "* Getting last segment: $last_segment" 

	echo "* Fetching Raw Text *"
	# let's start fetching content from our new segment.
	bin/nutch_ne.sh fetch $last_segment

	echo "* Parsing Raw Text to Fields *"
	# parse all of our entries.
	bin/nutch_ne.sh parse $last_segment

	echo "* Updating our Crawl Database *"
	# Update our database with the fetch results.
	bin/nutch_ne.sh updatedb $NUTCH_WORK_SPACE/crawl/crawldb \
		$last_segment	
done

echo "* Inverting Links *"
# Invert links, prepare for indexing.
bin/nutch_ne.sh invertlinks $NUTCH_WORK_SPACE/crawl/linkdb \
	-dir $NUTCH_WORK_SPACE/crawl/segments

# Debugging Information. #
read -p "Do you want to dump debugging info: " -n 1 -r
echo # simply skip one line.
if [[ $REPLY =~ ^[Yy]$ ]]; then

	echo "* Printing our Crawl Database Stats *"
	bin/nutch_ne.sh readdb $NUTCH_WORK_SPACE/crawl/crawldb \
		-stats
	
	echo "* Dumping Crawl Database URLs to a text file *"	
	bin/nutch_ne.sh readdb $NUTCH_WORK_SPACE/crawl/crawldb \
		-dump $NUTCH_WORK_SPACE/crawl/dump/crawldb/$current_date_time

	echo "* Printing Segments Stats *"
	bin/nutch_ne.sh readseg -list $last_segment	

	echo "* Dumping Segments Information to a text file *"
	bin/nutch_ne.sh readseg -dump $last_segment \
		$NUTCH_WORK_SPACE/crawl/dump/segments/$current_date_time

	echo "* Dumping Link Database to a text file *"
	bin/nutch_ne.sh readlinkdb $NUTCH_WORK_SPACE/crawl/linkdb \
		-dump $NUTCH_WORK_SPACE/crawl/dump/linkdb/$current_date_time

fi
