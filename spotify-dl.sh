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
API_TOKEN=BQDZTkCAAiM0P_kL819Ah4RU1I6qm4hcdKKmq41twav2ldfKHYPnZ1wXK8YyzkfU_Z86uONgczEkebZ0gMxDYTef_Dlf4wlWBWGj5iq4RC-ObHmX5xHwJ57LpI3s4wJZsnsW4Fc7SA
# id of the playlist you want to download
PLAYLIST_ID=4oMRIwefQWsVxLRLqECDep


# gets artist and track names and stores them in a file
curl -X "GET" "https://api.spotify.com/v1/playlists/$PLAYLIST_ID/tracks?fields=items(track(name,artists(name)))" \
    -H "Accept: application/json" -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_TOKEN" | grep name > spotify-playlist


# checks if api token is invalid or playlist does not exist by counting the
# lines of the file we get by calling the api.
if [ -z $(cat spotify-playlist | wc -l) ]
then
    echo "Either the api token is wrong or the playlist does not exist."
    exit 1
fi


# loops through each track and calls youtube-dl.
# Iterations will be lines /2 because we have name one line and album
# one line. Increase counter by 2 per iteration rather than dividing by 2.
TRACK_COUNT=$(cat spotify-playlist | wc -l)
COUNTER=1
while [ $COUNTER -lt $TRACK_COUNT ]
do
    # Uses '"name" : ' as delim to get the artist name.
    ARTIST_NAME=$(cat spotify-playlist | awk "NR==$COUNTER" | \
        awk -F '"name" : ' '{print $2}')

    # MAYBE(pierre): Could just concat the artists if IS_ARTIST.
    # Artist entries have 8 spaces per row. Track entries have less.
    # If we have multiple artists for a track we increase the counter until the
    # next entry is NOT an artist. Then we continue.
    IS_ARTIST=$(cat spotify-playlist | awk "NR==`expr $COUNTER + 1`" \
        | egrep "[ ]{8}")
    while [ $? -eq 0 ]
    do
        COUNTER=`expr $COUNTER + 1`
        IS_ARTIST=$(cat spotify-playlist | awk "NR==`expr $COUNTER + 1`" \
            | egrep "[ ]{8}")
    done

    TRACK_NAME=$(cat spotify-playlist | awk "NR==`expr $COUNTER + 1`" | \
        awk -F '"name" : ' '{print $2}')

    # calls youtube-dl to download the first file that matches our search
    # query. Results will be stored in the ./downloads directory.
    youtube-dl -o "./downloads/%(title)s.%(ext)s" --extract-audio \
        ytsearch:"$ARTIST_NAME $TRACK_NAME music"

    COUNTER=`expr $COUNTER + 2`
done

# cleans up the temporary file
rm spotify-playlist

# notify user that we are done
echo "Done downloading your playlist. Check results in the ./downloads folder."
