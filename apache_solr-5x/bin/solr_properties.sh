#!/bin/bash
# ======================================================================
# Solr Config Shared Parameters.
# Simply a file with all of the necessary variable definittions 
# required for Solr.
# Note these are global shared properties, they apply to all Solr
# routines. So do not put specific properties (e.g. focused index 
# configuration files, log names ...) or they will be included everywhere.
# Author: 	Camilo Tejeiro
# License: 	Apache_v2. (refer to licenses directory)
# ======================================================================

# SOLR Workspace Path.
export SOLR_WORK_SPACE=/media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_solr-5x

# SOLR Install Dir
export SOLR_INSTALL_DIR=/opt/solr-5.2.1
