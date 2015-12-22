#!/bin/bash
# ======================================================================
# Solr Test Bench Script
# Binary script to test the current configuration of Solr, to support 
# all minimum functionality in one shot. This makes it easier to quickly
# test that our current installation of Solr is sound.
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/solr_properties.sh

echo "* Stopping Solr *"
# First, make sure we stop any Solr running instances.
bin/solr_ne.sh stop

echo "* Starting Solr *"
# Now let's start Solr loading any new configurations.
bin/solr_ne.sh start

echo "* Creating our core *"
# Now let's create our test core, using our test bench simple configurations.
bin/solr_ne.sh create -c solr_test_core -d \
	$SOLR_WORK_SPACE/configsets/simple_text_en_configs

echo "* Posting documents for Solr *"
# Now let's post some documents so that Solr can index them.
bin/post_ne.sh -c solr_test_core $SOLR_WORK_SPACE/licenses

echo "* Searching our index *"
# Now let's search our index using Curl, we will be searching for the term "library"
curl "http://localhost:8983/solr/solr_test_core/select?wt=json&indent=true&q=library"

echo "* Deleting our core *"
# Everything worked as expected, clean up, delete your core.
bin/solr_ne.sh delete -c solr_test_core
