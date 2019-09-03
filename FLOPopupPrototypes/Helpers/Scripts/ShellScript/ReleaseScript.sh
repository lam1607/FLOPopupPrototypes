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
LOCAL_SERVER_DIRECTORY="/Applications/AMPPS/www"
BUILD_DIRECTORY="$HOME/Development/Projects/macOS/$PROJECT_NAME/Documents/Builds"
VERSION=$(defaults read "$BUILT_PRODUCTS_DIR/$PROJECT_NAME.app/Contents/Info" CFBundleShortVersionString)
ARCHIVE_NAME="$PROJECT_NAME$VERSION"
ARCHIVE_FILENAME="$ARCHIVE_NAME.zip"

BASE_URL="http://localhost:1607/prototype-update"
DOWNLOAD_BASE_URL="$BASE_URL/downloads"
DOWNLOAD_URL="$DOWNLOAD_BASE_URL/$ARCHIVE_FILENAME"
RELEASENOTES_URL="$BASE_URL/release-notes/release-notes.html"
APPCAST_FILENAME="appcast.xml"
RELEASE_ITEM_FILE="release-item-file.xml"
SIGNING_UPDATE="$BUILD_DIRECTORY/sparkle_sign"

echo "Application version: $VERSION, archived file name: $ARCHIVE_FILENAME"

# Change to build directory of Xcode
cd "$BUILT_PRODUCTS_DIR"

# Zip the built file
ditto -ck --keepParent "$PROJECT_NAME.app" "$ARCHIVE_FILENAME"
#zip -qr "$ARCHIVE_FILENAME" "$PROJECT_NAME.app"

scp "$ARCHIVE_FILENAME" $BUILD_DIRECTORY

# Clean up all zipped files
rm -f *.zip

# Change to our build directory
cd "$BUILD_DIRECTORY"

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
curl $BASE_URL/$APPCAST_FILENAME -o $APPCAST_FILENAME

# Insert new release note item to given (downloaded) appcast.xml file
sed -i'.bak' "6r $RELEASE_ITEM_FILE" $APPCAST_FILENAME

scp "$BUILD_DIRECTORY/$ARCHIVE_FILENAME" "$LOCAL_SERVER_DIRECTORY/prototype-update/downloads"
scp "$BUILD_DIRECTORY/$APPCAST_FILENAME" "$LOCAL_SERVER_DIRECTORY/prototype-update/$APPCAST_FILENAME"

# Clean up all zipped and appcast files
rm -f *.zip
rm -f *.xml
rm -f *.bak

echo "---------> END - execute ReleaseScript.sh <---------"
