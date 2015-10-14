#!/bin/bash
# ======================================================================
# Nutch Config Shared Parameters.
# Simply a file with all of the necessary variable definittions 
# required for Nutch.
# Note these are global shared properties, they apply to all Nutch 
# Crawl routines. So do not put specific properties 
# (e.g. focused crawl configuration files, log names ...) or they will 
# be included everywhere.
# Author: Apache Foundation, Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# Nutch Workspace Path.
export NUTCH_WORK_SPACE=/media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x

# Nutch Install Home Path.
export NUTCH_INSTALL_DIR=/opt/apache-nutch-1.10/runtime/local

# set the log directory nutch uses for its logs.
export NUTCH_LOG_DIR=/media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/logs/

# ======================= #
# Crawl script Properties #
# ======================= #
# set the number of slaves nodes
numSlaves=1

# and the total number of available tasks
# sets Hadoop parameter "mapred.reduce.tasks"
numTasks=`expr $numSlaves \* 2`

# number of urls to fetch in one iteration
# 250K per task?
sizeFetchlist=`expr $numSlaves \* 50000`

# time limit for feching
timeLimitFetch=180

# num threads for fetching
numThreads=50
