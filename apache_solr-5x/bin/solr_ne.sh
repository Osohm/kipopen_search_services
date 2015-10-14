#!/bin/bash
# ======================================================================
# Solr New Environment Script
# Binary to execute Solr from a new path i.e. so that we keep 
# track of binary script changes as well as work easily from our 
# workspace.
# Author: 	Camilo Tejeiro
# License: 	Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/solr_properties.sh

# set the file we would like to use for configuring Solr.
# we must use absolute paths, since we will be changing directories
# to the SOLR install dir.
SOLR_INCLUDE=$SOLR_WORK_SPACE/bin/solr.in.sh

# Now go to the installation directory, required for relative paths 
# to work when launching Solr.
cd $SOLR_INSTALL_DIR

echo "Executing script natively in SOLR Home, remember to use absolute paths."

# Now include our native script, so that arguments are supported.
source bin/solr
