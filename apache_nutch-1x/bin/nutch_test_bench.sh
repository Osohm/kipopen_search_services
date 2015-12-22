#!/bin/bash
# ======================================================================
# Nutch Test Bench Script
# Binary script to test the current configuration of Nutch, to support 
# all minimum functionality in one shot. This makes it easier to quickly
# test that our current installation of Nutch is sound.
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/nutch_properties.sh

# Local Var Definitions #
# get current date and time to timestamp our logs and debug information.
current_date_time=$(date "+%Y%m%d%H%M%S")

# set our Nutch test bench configuration.
export NUTCH_CONF_DIR=$NUTCH_WORK_SPACE/conf/simple_text_configs;

echo "* Injecting our URLs *"
# Inject our test URLs, we will use our blog for simplicity.
bin/nutch_ne.sh inject $NUTCH_WORK_SPACE/crawl/crawldb \
    $NUTCH_WORK_SPACE/urls/simple_urls/simple_seed.txt
    
echo "* Generating Fetch list *"
# generate our fetch list, list of pages to crawl.
bin/nutch_ne.sh generate $NUTCH_WORK_SPACE/crawl/crawldb \
    $NUTCH_WORK_SPACE/crawl/segments -topN 10
    
last_segment=`ls -d $NUTCH_WORK_SPACE/crawl/segments/2* | tail -1`
echo "* Getting last segment: $last_segment" 

echo "* Fetching content *"
# let's start fetching content from our new segment.
bin/nutch_ne.sh fetch $last_segment

echo "* parsing all of our entries *"
# parse all of our entries.
bin/nutch_ne.sh parse $last_segment

echo "* Updating our database *"
# Update our database with the fetch results.
bin/nutch_ne.sh updatedb $NUTCH_WORK_SPACE/crawl/crawldb \
    $last_segment
    
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
