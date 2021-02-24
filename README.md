# spotify-dl
Small shell script used to download your own (or any publicly available)
spotify playlists.
<br>
Uses the matching tracks on youtube and the youtube-dl tool.

## prerequisites
- [youtube-dl](https://github.com/ytdl-org/youtube-dl) installed.
- python version 2.6, 2.7, or 3.2+ for youtube-dl to work.
- grep, awk, cat which are installed by default on most systems.
- for windows you will need to run this in WSL. e.g. [ubuntu in wsl](https://ubuntu.com/wsl)

## info
- given the prereqs, will work on linux, macOs, windows.

## quick start
1. Download this repo and go into the spotify-dl folder.
2. [Find out your playlist id.](#finding-out-the-playlist-id)
3. [Create your access token.](#creating-your-access-token)
4. Open the spotify-dl.sh file with an editor.
5. Replace everything after "API_TOKEN=" with your token.
6. Replace everything after "PLAYLIST_ID=" with your playlist id.
7. Run the shell script
```shell script
./spotify-dl
```
8. The tracks are now stored under ./downloads.

## creating your access token
1. Visit the [spotify developer dashboard](https://developer.spotify.com/dashboard/) and log into your account.
2. Click "create app" and create one.
3. Select "show client id" to get the client id value you will need for your
authentication.
4. Click "edit settings" for your app and add a redirect link. You should pick any local page. Working example: http://localhost:9999/callback Dont forget to press "save" at the bottom.
5. Forge your request link. You can adapt the following basic link:

```shell script
https://accounts.spotify.com/en/authorize?client_id=insertYourClientIdHere&response_type=token&redirect_uri=insertYourRedirectUriHere
```

6. Open the link with your browser, read through the popup and agree if you do.
7. You will be redirected to your given redirectUri.
8. Everything after "access_token=" until the next "&" will be your token.

### example
- ClientId: fa449q4129a543b6a6bbe8ccjk106b16
- RedirectUri:http://localhost:9999/callback

With these our resulting link is:

```shell
https://accounts.spotify.com/en/authorize?client_id=fa449q4129a543b6a6bbe8ccjk106b16&response_type=token&redirect_uri=http://localhost:9999/callback
```

We will be redirected to this link:
```shell
http://localhost:9999/callback#access_token=BQDZTkCAAiM0P_kL819Ah4RU1I6qm4hcdKKmq41twav2ldfKHYPnZ1wXK8YyzkfU_Z86uONgczEkebZ0gMxDYTef_Dlf4wlWBWGj5iq4RC-ObHmX5xHwJ57LpI3s4wJZsnsW4Fc7SA&token_type=Bearer&expires_in=3600
```

Our token is:
```shell
BQDZTkCAAiM0P_kL819Ah4RU1I6qm4hcdKKmq41twav2ldfKHYPnZ1wXK8YyzkfU_Z86uONgczEkebZ0gMxDYTef_Dlf4wlWBWGj5iq4RC-ObHmX5xHwJ57LpI3s4wJZsnsW4Fc7SA
```

## finding out the playlist id
- Log in to the spotify web player in your browser.
- Click on the playlist you want to download.
- Copy the link, everything after .../playlist/ is your playlistid.
### example
https://open.spotify.com/playlist/4oMRIwefQWsVxLRLqECDep

Your playlist id is:
```shell
4oMRIwefQWsVxLRLqECDep
```
