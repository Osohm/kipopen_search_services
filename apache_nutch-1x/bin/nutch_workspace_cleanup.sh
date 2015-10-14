#!/bin/bash
# ======================================================================
# Nutch Workspace Cleanup
# Bash script to clean up all generated data in one shot, this helps 
# test multiple configurations quickly.
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# all paths MUST be absolute and don't use env variables to avoid trashing 
# wrong files due to non existent paths.
# Use Trash-put to keep things safe.

# clean up our logs.
trash-put /media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/logs/*

# clean up our data.
trash-put /media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/crawl/crawldb/*
trash-put /media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/crawl/dump/*
trash-put /media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/crawl/linkdb/*
trash-put /media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x/crawl/segments/*

