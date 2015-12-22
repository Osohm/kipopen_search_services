#!/bin/bash
# ======================================================================
# Nutch Workspace Cleanup
# Bash script to clean up all generated data in one shot, this helps 
# test multiple configurations quickly.
# Author: Camilo Tejeiro
# License: Apache_v2. (refer to licenses directory)
# ======================================================================

# all paths MUST be absolute.

# clean up our logs.
absolute_path="/media/camilo/backup_storage/workspaces/osohm/crawl_search_engine/apache_nutch-1x"
trash-put $absolute_path/logs/*

# clean up our data.
trash-put $absolute_path/crawl/crawldb/*
trash-put $absolute_path/crawl/dump/*
trash-put $absolute_path/crawl/linkdb/*
trash-put $absolute_path/crawl/segments/*

