#!/bin/sh
#
# Author: Pierre Dahmani
# Created: 19.02.2021
#
# Description: Small shell script used to download your own
# (or any publicly available) spotify playlists.
# Uses the matching tracks on youtube and the youtube-dl tool.


# CHANGE THESE TWO VALUES
# id of your created api token
API_TOKEN=BQBsP6Ok3CZcRKBPIgcdUnK6pETmCA-6Y718v1otNh3ERCyDGKYNZNZrUVDdNrHCQ8d5kapRCvSxG7q8byFxijY53gDeUSi4tfsCIbzJpKm9mP_w8sJvWjEmzRThMTaK23SRORBaNw
# id of the playlist you want to download
PLAYLIST_ID=2Qt6vSalV7iAwsIlmtM14L
# If you set this to TRUE you will end up with .mp3 files. If you set this to
# any other value you will end up with .opus files.
STORE_AS_MP3=TRUE


# sets argument for youtube-dl by given value of $STORE_AS_MP3
if [ $STORE_AS_MP3 = 'TRUE' ]
then
   STORE_AS_MP3="--audio-format mp3"
else
   STORE_AS_MP3=""
fi


# gets artist and track names and stores them in a file
curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLIST_ID/tracks?fields=items(track(name,artists(name)))" \
    -H "Accept: application/json" -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" | grep name > get-playlist-tracks


# checks if api token is invalid or playlist does not exist by counting the
# lines of the file we get by calling the api.
if [ -z $(cat get-playlist-tracks | wc -l) ]
then
    echo "Either the api token is wrong or the playlist does not exist."
    exit 1
fi

# queries the playlist name and stores it inside PLAYLIST_NAME
curl -X "GET" \
    "https://api.spotify.com/v1/playlists/$PLAYLIST_ID/?fields=name" \
    -H "Accept: application/json" -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN"  > get-playlist-name
PLAYLIST_NAME=$(cat get-playlist-name | grep name | head -n 1 \
    | awk -F \" '{print $4}')

# loops through each track and calls youtube-dl.
# Iterations will be lines /2 because we have name one line and album
# one line. Increase counter by 2 per iteration rather than dividing by 2.
TRACK_COUNT=$(cat get-playlist-tracks | wc -l)
COUNTER=1
TRACK_NUMBER=1
while [ $COUNTER -lt $TRACK_COUNT ]
do
    # Uses '"name" : ' as delim to get the artist name.
    ARTIST_NAME=$(cat get-playlist-tracks | awk "NR==$COUNTER" | \
        awk -F '"name" : ' '{print $2}')

    # MAYBE(pierre): Could just concat the artists if IS_ARTIST.
    # Artist entries have 8 spaces per row. Track entries have less.
    # If we have multiple artists for a track we increase the counter until the
    # next entry is NOT an artist. Then we continue.
    IS_ARTIST=$(cat get-playlist-tracks | awk "NR==`expr $COUNTER + 1`" \
        | egrep "[ ]{8}")
    while [ $? -eq 0 ]
    do
        COUNTER=`expr $COUNTER + 1`
        IS_ARTIST=$(cat get-playlist-tracks | awk "NR==`expr $COUNTER + 1`" \
            | egrep "[ ]{8}")
    done

    TRACK_NAME=$(cat get-playlist-tracks | awk "NR==`expr $COUNTER + 1`" | \
        awk -F '"name" : ' '{print $2}')

    # makes sure we will keep order as it is in our playlist.
    # first track will be 001. tenth will be 010 etc..
    TRACK_NUMBER_THREE_POSITIONS=$(printf "%03d" $TRACK_NUMBER)

    # calls youtube-dl to download the first file that matches our search
    # query. Results will be stored in the ./downloads/nameOfYourPlaylist
    # directory.
    youtube-dl --extract-audio $STORE_AS_MP3 \
        -o "./downloads/$PLAYLIST_NAME/$TRACK_NUMBER_THREE_POSITIONS-%(title)s.%(ext)s" \
        ytsearch:"$ARTIST_NAME $TRACK_NAME music official"

    TRACK_NUMBER=`expr $TRACK_NUMBER + 1`
    COUNTER=`expr $COUNTER + 2`
done

# cleans up the temporary file
rm get-playlist-tracks get-playlist-name

# notifies user that we are done
echo "Done downloading your playlist. Check results in the
./downloads/$PLAYLIST_NAME folder."
