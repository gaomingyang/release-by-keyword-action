#!/bin/bash
set -e

if [ -n "$GITHUB_EVENT_PATH" ];
then
    EVENT_PATH=$GITHUB_EVENT_PATH
elif [ -f ./test_push_event.json ];
then
    EVENT_PATH='./test_push_event.json'
    LOCAL_TEST=true
else
    echo "No JSON data to process! :("
    exit 1
fi

env
jq . < $EVENT_PATH

KEYWORD="$*"
if [ -z $KEYWORD ];then
    echo "keyword is needed!"
    exit
fi

echo "keyword is:" $KEYWORD

# if keyword is found
if jq '.commits[].message, .head_commit.message' < $EVENT_PATH | grep -i -q $KEYWORD;
then
    # do something
    # echo "Found keyword."

    VERSION=$(date +%F.%s)

    DATA="$(printf '{"tag_name":"v%s",' $VERSION)"
    DATA="${DATA} $(printf '"target_commitish":"master",')"
    DATA="${DATA} $(printf '"name":"v%s",' $VERSION)"
    DATA="${DATA} $(printf '"body":"Automated release based on keyword: %s",' "$*")"
    DATA="${DATA} $(printf '"draft":false, "prerelease":false}')"

    if [[ "${LOCAL_TEST}" == *"true"* ]];
    then
        echo "## [TESTING] Keyword was found but no release was created."
    else
        curl -H "Authorization: ${GITHUB_TOKEN}" -H "Content-Type: application/json" -X POST https://api.github.com/repos/${GITHUB_REPOSITORY}/releases -d ${DATA}
    fi

# otherwise
else
    # exit gracefully
    echo "Nothing to process."
fi