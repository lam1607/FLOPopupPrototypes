#!/bin/sh

#  ReleaseScript.sh
#  FLOPopupPrototypes
#
#  Created by Lam Nguyen on 8/29/19.
#  Copyright © 2019 Floware Inc. All rights reserved.

# http://codewiki.wikidot.com/shell-script:if-else

echo "---------> BEGIN - execute ReleaseScript.sh <---------"

set -o errexit

# Constants
BUILD_DIRECTORY="$HOME/Development/Projects/macOS/FLOPopupPrototypes/Documents/Builds"

[ -d "$BUILD_DIRECTORY" ] || mkdir "$BUILD_DIRECTORY"

# Change to our build directory
cd "$BUILD_DIRECTORY"

source building-info.txt

echo "Project name: $PROJECT_NAME, Product bundle identifier: $PRODUCT_BUNDLE_IDENTIFIER, Version: $VERSION, Deployment target: $MACOSX_DEPLOYMENT_TARGET"

ARCHIVE_NAME="$PROJECT_NAME$VERSION"
ARCHIVE_FILENAME="$ARCHIVE_NAME.zip"

echo "Product bundle identifier: $PRODUCT_BUNDLE_IDENTIFIER"

LOCAL_CACHE_DIRECTORY="$HOME/Library/Caches/$PRODUCT_BUNDLE_IDENTIFIER"
LOCAL_SERVER_DIRECTORY="$LOCAL_CACHE_DIRECTORY/SocketServer"

[ -d "$LOCAL_CACHE_DIRECTORY" ] || mkdir "$LOCAL_CACHE_DIRECTORY"
[ -d "$LOCAL_SERVER_DIRECTORY" ] || mkdir "$LOCAL_SERVER_DIRECTORY"
[ -d "$LOCAL_SERVER_DIRECTORY/downloads" ] || mkdir "$LOCAL_SERVER_DIRECTORY/downloads"
[ -d "$LOCAL_SERVER_DIRECTORY/release-notes" ] || mkdir "$LOCAL_SERVER_DIRECTORY/release-notes"

BASE_URL="http://localhost:1607"
DOWNLOAD_BASE_URL="$BASE_URL/downloads"
DOWNLOAD_URL="$DOWNLOAD_BASE_URL/$ARCHIVE_FILENAME"
RELEASENOTES_URL="$BASE_URL/release-notes/release-notes.html"
APPCAST_FILENAME="appcast.xml"
RELEASE_ITEM_FILE="release-item-file.xml"
SIGNING_UPDATE="$BUILD_DIRECTORY/sparkle_sign"

echo "Application version: $VERSION, archived file name: $ARCHIVE_FILENAME"

# Change to build directory of Xcode
#cd "$BUILT_PRODUCTS_DIR"

# Zip the built file
#ditto -ck --keepParent "$PROJECT_NAME.app" "$ARCHIVE_FILENAME"
#zip -qr "$ARCHIVE_FILENAME" "$PROJECT_NAME.app"

#scp "$ARCHIVE_FILENAME" $BUILD_DIRECTORY

# Clean up all zipped files
#rm -f *.zip


SIZE=$(stat -f %z "$ARCHIVE_FILENAME")
PUBDATE=$(LC_TIME=en_US date +"%a, %d %b %G %T %z")
# Signing the zipped file by the sparkle signing tool.
SIGNING_SIGNATURE=$(
    $SIGNING_UPDATE $ARCHIVE_FILENAME
)

if [ -z $SIGNING_SIGNATURE ]
then
    echo "Unable to signing for file '$ARCHIVE_FILENAME'"
fi

# Get the signature string from the result of signing step with formatted as follow:
# sparkle:edSignature="mWuTgPhuuRGhK/7hhV1OsCx0hxs+2dHSad09d5lfI52NvjZBzGXYZhnw6ibdZBhtuRew998mnmPztxnaqSqPAg==" length="63462781"
#SIGNATURE=$(echo $SIGNING_SIGNATURE | cut -d ' ' -f 1)

# Update new release note item information
RELEASE_ITEM=$(cat <<-END
        <item>
            <title>Version $VERSION</title>
            <sparkle:releaseNotesLink>
                $RELEASENOTES_URL
            </sparkle:releaseNotesLink>
            <pubDate>$PUBDATE</pubDate>
            <enclosure url="$DOWNLOAD_URL" sparkle:version="$VERSION" type="application/octet-stream" $SIGNING_SIGNATURE />
            <sparkle:minimumSystemVersion>$MACOSX_DEPLOYMENT_TARGET</sparkle:minimumSystemVersion>
        </item>
END
)

echo "New release note item content: \n$RELEASE_ITEM"

echo "$RELEASE_ITEM" >> $RELEASE_ITEM_FILE

# Download the appcast.xml file from server
#curl $BASE_URL/$APPCAST_FILENAME -o $APPCAST_FILENAME
scp "$LOCAL_SERVER_DIRECTORY/$APPCAST_FILENAME" "$BUILD_DIRECTORY/$APPCAST_FILENAME"

# Insert new release note item to given (downloaded) appcast.xml file
sed -i'.bak' "6r $RELEASE_ITEM_FILE" $APPCAST_FILENAME

echo "Local server directory: $LOCAL_SERVER_DIRECTORY"

scp "$BUILD_DIRECTORY/$ARCHIVE_FILENAME" "$LOCAL_SERVER_DIRECTORY/downloads/$ARCHIVE_FILENAME"
scp "$BUILD_DIRECTORY/$APPCAST_FILENAME" "$LOCAL_SERVER_DIRECTORY/$APPCAST_FILENAME"

# Clean up all zipped and appcast files
rm -f *.app
rm -f *.zip
rm -f *.xml
rm -f *.bak
rm -f *.txt

echo "---------> END - execute ReleaseScript.sh <---------"
