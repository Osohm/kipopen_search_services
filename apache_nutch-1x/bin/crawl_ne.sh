#!/bin/bash
# ======================================================================
# Crawl New Environment Script
# Binary to execute crawl from a new path i.e. so that we keep 
# track of binary script changes as well as work easily from our 
# workspaces.
# Author: Apache Foundation, Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/nutch_properties.sh

# Now go to the installation directory, required for relative path.
cd $NUTCH_INSTALL_DIR

echo "Executing script natively in Nutch Home, remember to use absolute paths."

# Now include our native script, so that arguments are supported.
source bin/crawl
