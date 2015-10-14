#!/bin/bash
# ======================================================================
# Nutch Solr Integration Testbench
# Binary script to test the integration of Nutch and Solr
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source apache_solr-5x/bin/solr_properties.sh
source apache_nutch-1x/bin/nutch_properties.sh

# Local Var Definitions #
# get current date and time to timestamp our logs and debug information.
current_date_time=$(date "+%Y%m%d%H%M%S")

# go into our solr workspace
cd $SOLR_WORK_SPACE

echo "* Solr: Stopping Solr *"
## First, make sure we stop any Solr running instances. 
bin/solr_ne.sh stop

echo "* Solr: Starting Solr *"
# Now let's start Solr loading any new configurations.
bin/solr_ne.sh start

echo "* Solr: Creating our nutch-solr linked core *"
# Now let's create our test core, using our test bench nutch-solr simple configuration.
bin/solr_ne.sh create -c nutch_solr_test_core -d \
	$SOLR_WORK_SPACE/configsets/nutch_solr_simple_configs

# go into our nutch workspace
cd $NUTCH_WORK_SPACE

# export our Nutch test bench configuration, because it needs to be seen 
# on the called nutch_ne script
export NUTCH_CONF_DIR=$NUTCH_WORK_SPACE/conf/nutch_solr_simple_configs
# set the log file nutch uses for its logs.
export NUTCH_LOGFILE="hadoop_$current_date_time.log"

echo "* Nutch: Injecting our URLs *"
# Inject our test URLs, we will use our blog for simplicity.
bin/nutch_ne.sh inject $NUTCH_WORK_SPACE/crawl/crawldb \
	$NUTCH_WORK_SPACE/urls/simple_urls/simple_seed.txt

echo "* Nutch: Generating Fetch list *"
# generate our fetch list, list of pages to crawl.
bin/nutch_ne.sh generate $NUTCH_WORK_SPACE/crawl/crawldb \
	$NUTCH_WORK_SPACE/crawl/segments -topN 10

# store our last segment in a local var (only visible in this script).
last_segment=`ls -d $NUTCH_WORK_SPACE/crawl/segments/2* | tail -1`
echo "* Nutch: Getting last segment: " $last_segment

echo "* Nutch: Fetching content *"
# let's start fetching content from our new segment.
bin/nutch_ne.sh fetch $last_segment

echo "* Nutch: Parsing all of our entries *"
# parse all of our entries.
bin/nutch_ne.sh parse $last_segment

echo "* Nutch: Updating our database *"
# Update our database with the fetch results.
bin/nutch_ne.sh updatedb $NUTCH_WORK_SPACE/crawl/crawldb \
	$last_segment
	
echo "* Nutch: Inverting Links *"
# Invert links, prepare for indexing.
bin/nutch_ne.sh invertlinks $NUTCH_WORK_SPACE/crawl/linkdb \
	-dir $NUTCH_WORK_SPACE/crawl/segments

# Debugging Information. #
read -p "Do you want to dump nutch debugging info: " -n 1 -r
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

echo "* Nutch: Posting Nutch data to Solr *"
# Posting our crawled data to Solr to start indexing.	
bin/nutch_ne.sh solrindex http://localhost:8983/solr/nutch_solr_test_core \
	$NUTCH_WORK_SPACE/crawl/crawldb/ \
	$last_segment
	
echo "* Nutch: Deleting duplicates in our Solr index*"
# Deleting duplicate urls.
bin/nutch_ne.sh dedup http://localhost:8983/solr/nutch_solr_test_core

echo "* Nutch: Cleaning our Solr index*"
# Removing 404's not found from our database.
bin/nutch_ne.sh solrclean $NUTCH_WORK_SPACE/crawl/crawldb/ \
	http://localhost:8983/solr/nutch_solr_test_core

# go into our solr workspace
cd $SOLR_WORK_SPACE

echo "* Solr: Searching our index *"
# Now let's search our index using Curl, we will be searching for the term "library"
curl "http://localhost:8983/solr/nutch_solr_test_core/select?wt=json&indent=true&q=*"

echo "* Solr: Searching our index *"
# Now let's search our index using Curl, we will be searching for the term "library"
curl "http://localhost:8983/solr/nutch_solr_test_core/select?wt=json&indent=true&q=project"

echo "* Solr: Deleting our core *"
# Everything worked as expected, clean up, delete your core.
bin/solr_ne.sh delete -c nutch_solr_test_core
