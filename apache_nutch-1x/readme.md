Nutch Workspace Directory
=================================

This directory is our Nutch workspace which holds 
configuration files, binary scripts, crawl databases, logs 
and lists of urls.

By isolating our workspace from the install directory and the OS, 
we can add version control (safety), we can make our 
code portable (wipe and upgrade Nutch easily) and we can 
backup our crawled data periodically.

Basic Directory Structure
-------------------------

The Nutch workspace typically contains the following:

## bin
Binary scripts used set environment variables and to access the 
different nutch commands, in isolation from our install directory.

## conf 
configuration files to define the functionality of our crawler.

## crawl 
This directory holds the actual fetched data from our crawled websites.

## urls
Directory used to hold lists of urls (seeds) to inject to into Nutch.

## logs
logs for debugging purposes.

## Licenses
directory including all licenses applicable to this project in text format.
