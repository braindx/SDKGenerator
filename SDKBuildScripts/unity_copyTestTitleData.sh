#!/bin/sh
# USAGE: unity_copyTestTitleData.sh <target directory to contain testTitleData.json inside of the unity project> <copy | delete>
# Copies the actively configured test title data into the unity project.

if [ -z "$PF_TEST_TITLE_DATA_JSON" ] || [ ! -f "$PF_TEST_TITLE_DATA_JSON" ]; then
    echo FATAL ERROR: PF_TEST_TITLE_DATA_JSON not set
    exit 1
fi

#check number of args
if [ "$#" -ne 2 ]; then 
    echo "ERROR: Invalid number of arguments."
    echo "Usage: ./unity_copyTestTitleData.sh <target directory to contain testTitleData.json inside of the unity project> <copy | delete>"
    exit 1
fi

#collect args
TargetPath=$1
CopyOrDelete=$2

#validate args
if [ $CopyOrDelete != "copy"  ] && [ "$CopyOrDelete" != "delete" ]; then 
    echo "ERROR: Second argument must be either copy or delete"
    echo "Usage: ./unity_copyTestTitleData.sh <target directory to contain testTitleData.json inside of the unity project> <copy | delete>"
    exit 1
fi

#perform copy or delete
if [ $CopyOrDelete = "copy" ] ; then
    mkdir -p "$TargetPath"
    cp -f "$WORKSPACE/JenkinsSdkSetupScripts/Creds/testTitleData.json" "$TargetPath/testTitleData.json"
    else
    rm "$TargetPath/testTitleData.json"
fi
