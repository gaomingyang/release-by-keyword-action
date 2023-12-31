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

    # TAG_NAME="v$(date +'%Y%m%d')_$(date +'%s')"
    TAG_NAME="v$(date +%F-%s)"

    DATA="$(printf '{"tag_name":"%s",' $TAG_NAME)"
    DATA="${DATA} $(printf '"target_commitish":"main",')" #分支名main
    DATA="${DATA} $(printf '"name":"%s",' $TAG_NAME)"
    DATA="${DATA} $(printf '"body":"Automated release based on keyword: %s",' "$*")"
    DATA="${DATA} $(printf '"draft":false, "prerelease":false}')"

    URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"

    if [[ "${LOCAL_TEST}" == *"true"* ]];
    then
        echo "## [TESTING] Keyword was found but no release was created."
    else
        echo "token:" ${GITHUB_TOKEN}
        echo "url:" ${URL}
        echo "data:" ${DATA}

        curl -X POST -H "Authorization: Bearer ${GITHUB_TOKEN}" -H "Content-Type: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "${URL}" -d "${DATA}"
    fi

# otherwise
else
    # exit gracefully
    echo "Nothing to process."
fi