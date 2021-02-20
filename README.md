# spotify-dl
Small shell script used to download your own spotify playlists. Uses the matching tracks on youtube and the youtube-dl tool.

# prereqs
- [youtube-dl](https://github.com/ytdl-org/youtube-dl) installed.

To install it right away for all UNIX users (Linux, macOS, etc.), type:
```shell script
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
sudo chmod a+rx /usr/local/bin/youtube-dl
```


### Quick start
- Create an access token(the token from the example will NOT work, you need your own token) and find out your spotify playlist id.
- Download this repo and go into the spotify-dl folder
- Open the spotify-dl file with an editor. 
- Change the value of the API_TOKEN with your own access token.   
- Change the value of the PLAYLIST_ID with our own spotify playlist id.
- Run the shell script
```shell
./spotify-dl
```


### Creating your own access token
1. Visit https://developer.spotify.com/dashboard/ and log in with your spotify account.
2. Click "create app" and create one.
3. Select "show client id" to get the client id value you will need for your
authentication.
4. Click edit settings for your app and add a redirect link that will be
accepted to redirect to. You can pick any page, an example is http://localhost:9999/callback
Dont forget to press save.
5. Forge your request. 
    1. The basic link looks like this:
      https://accounts.spotify.com/en/authorize?client_id=insertYourClientIdHere&response_type=token&redirect_uri=insertYourRedirectUriHere
      now adapt it with your own values. For our example this will be ClientId: fa449q4129a543b6a6bbe8ccjk106b16 RedirectUri:http://localhost:9999/callback
      so our request link will be: 
      https://accounts.spotify.com/en/authorize?client_id=fa449q4129a543b6a6bbe8ccjk106b16&response_type=token&redirect_uri=http://localhost:9999/callback
6. Open your browser of choice, add the link, read through the spotify popup and agree.
7. You will be redirected to a homepage, for our example this will look like:
    http://localhost:9999/callback#access_token=BQDZTkCAAiM0P_kL819Ah4RU1I6qm4hcdKKmq41twav2ldfKHYPnZ1wXK8YyzkfU_Z86uONgczEkebZ0gMxDYTef_Dlf4wlWBWGj5iq4RC-ObHmX5xHwJ57LpI3s4wJZsnsW4Fc7SA&token_type=Bearer&expires_in=3600
   Our token is everything after the access_token but only until the next "&". In our example it is BQDZTkCAAiM0P_kL819Ah4RU1I6qm4hcdKKmq41twav2ldfKHYPnZ1wXK8YyzkfU_Z86uONgczEkebZ0gMxDYTef_Dlf4wlWBWGj5iq4RC-ObHmX5xHwJ57LpI3s4wJZsnsW4Fc7SA. This value will need to be copied into the script to replace the string after API_TOKEN=


### Finding out the playlist id of your spotify playlist
- Log in to the spotify web player in your browser.
- Click on the playlist you want to download.
- Copy the link, everything after playlist is your playlistid.
example:
https://open.spotify.com/playlist/4oMRIwefQWsVxLRLqECDep
playlistid=4oMRIwefQWsVxLRLqECDep
This value will need to be copied into the script to replace the string after PLAYLIST_ID=
