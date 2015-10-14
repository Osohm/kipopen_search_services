#!/bin/bash
# ======================================================================
# Simple Post Tool New Environment Script.
# Binary to use the post tool from a new path i.e. so that we keep 
# track of binary script changes as well as work easily from our 
# workspace.
# Author: 	Camilo Tejeiro
# License: 	Apache_v2. (refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/solr_properties.sh

# Now go to the installation directory, required for relative path
cd $SOLR_INSTALL_DIR

echo "Executing script natively in SOLR Home, remember to use absolute paths."

# Now include our native script, so that arguments are supported.
source bin/post
