#!/bin/bash
# ======================================================================
# Nutch New Environment Script
# Binary to execute nutch with a new path i.e. so that it can load 
# configuration and store data in our safe workspace.
# Author: Apache_Foundation, Camilo Tejeiro
# Licenses: Apache_v2. (Refer to licenses directory)
# ======================================================================

# include our required shared properties.
source bin/nutch_properties.sh

# If var empty or not set, 
# set the configuration directory nutch loads when running to default.
if [ -z "$NUTCH_CONF_DIR" ];
	then 
		NUTCH_CONF_DIR=$NUTCH_WORK_SPACE/conf/simple_text_configs;
fi		

# Now go to the  installation directory, required for relative path
cd $NUTCH_INSTALL_DIR

echo "Executing script natively in Nutch Home, remember to use absolute paths."

# Now execute our native script, so that arguments are supported.
source bin/nutch
