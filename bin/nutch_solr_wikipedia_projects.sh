#!/bin/bash
# ======================================================================
# Nutch-Solr Wikipedia Projects Script
# Script that crawls multiple seeds from wikipedia to gather relevant 
# open projects information and feed this data to Solr for index and 
# searching.
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
# Now let's create our test core, using our test bench nutch-solr wikipedia configuration.
bin/solr_ne.sh create -c nutch_solr_wikipedia_projects_core -d \
	$SOLR_WORK_SPACE/configsets/nutch_solr_wikipedia_projects_configs

# go into our nutch workspace
cd $NUTCH_WORK_SPACE

# Now include our nutch crawl script to gather data from wikipedia
source bin/nutch_crawl_wikipedia_projects.sh

echo "* Nutch: Posting Nutch data to Solr *"
# Posting our crawled data to Solr to start indexing.	
bin/nutch_ne.sh solrindex http://localhost:8983/solr/nutch_solr_wikipedia_projects_core \
	$NUTCH_WORK_SPACE/crawl/crawldb/ \
	$last_segment
	
echo "* Nutch: Deleting duplicates in our Solr index*"
# Deleting duplicate urls.
bin/nutch_ne.sh dedup http://localhost:8983/solr/nutch_solr_wikipedia_projects_core

echo "* Nutch: Cleaning our Solr index*"
# Removing 404's not found from our database.
bin/nutch_ne.sh solrclean $NUTCH_WORK_SPACE/crawl/crawldb/ \
	http://localhost:8983/solr/nutch_solr_wikipedia_projects_core
	
# go into our solr workspace
cd $SOLR_WORK_SPACE

echo "* Solr: Searching our index *"
# Now let's search our index using Curl, we will be searching for the term "library"
curl "http://localhost:8983/solr/nutch_solr_wikipedia_projects_core/select?wt=json&indent=true&q=*"

echo "* Solr: Searching our index *"
# Now let's search our index using Curl, we will be searching for the term "library"
curl "http://localhost:8983/solr/nutch_solr_wikipedia_projects_core/select?wt=json&indent=true&q=Avogadro"

#echo "* Solr: Deleting our core *"
## Everything worked as expected, clean up, delete your core.
#bin/solr_ne.sh delete -c nutch_solr_wikipedia_projects_core
