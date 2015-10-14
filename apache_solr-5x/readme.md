Solr Workspace Directory
================================

This directory is our Solr workspace which holds 
configuration files and Solr indexes (called cores).

By isolating our workspace from the install directory and the OS, 
we can add version control (safety), we can make our 
code portable (wipe and upgrade Solr easily) and we can 
backup our indexed data periodically.

Basic Directory Structure
-------------------------

The Solr Workspace directory typically contains the following:

## bin
Binary scripts used to set environment variables and access the different 
solr commands directly from our workspace, keeping the nutch install 
directory intact.

## solr.xml
This is the primary configuration file Solr looks for when starting;
it specifies high-level configuration options that apply to all
of your Solr cores.

## SolrCore Configsets
Sets of template configurations we can use when creating new Solr 
cores.

## SolrCore Directories 
e.g. my_solr_core

Simple subdirectories that hold the configuration and the data for every 
created solr core. 

## SolrCore Properties 
e.g. my_solr_core/core.properties

During startup, Solr will scan sub-directories of Solr directory looking for
a specific file named core.properties. Solr will initialize a core using 
the properties defined in core.properties file.

## SolrCore Configuration
e.g. my_solr_core/conf
This directory includes all of the configuration details for our created 
core including schema.xml: which tells Solr how to index posted documents. 
and solrconfig.xml: which the defines the overall behavior of Solr. (e.g. 
Lucene Engine version, plugins import, query properties ...etc).

## SolrCore Data
e.g. my_solr_core/data
This directory holds all of the indexed data processed by Solr and applicable 
logs.

## ZooKeeper Files
When using SolrCloud using the embedded ZooKeeper option for Solr, it is 
common to have a "zoo.cfg" file and "zoo_data" directories in the Solr Home 
Directory.

## Licenses
directory including all licenses applicable to this project in text format.
