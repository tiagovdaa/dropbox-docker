

## Drobox in Docker

Run dropbox inside docker with local host folder linking with volumes.

### Usage Examples

____

### Quickstart

```
docker run -d --restart=always --name=dropbox tiagovdaa/dropbox-docker:latest
```

### Dropbox data mounted to local folder on the host

```
mkdir ~/dbox &&
docker run -d --restart=always --name=dropbox -v ${HOME}/dbox:/dbox tiagovdaa/dropbox-docker:latest
```

### Enable LAN Sync

```
docker run -d --restart=always --name=dropbox \
--net="host" \
tiagovdaa/dropbox-docker:latest
```

## Linking to Dropbox account after first start

Check the logs of the container to get URL to authenticate with your Dropbox account.

```
docker logs dropbox
```

Copy and paste the URL in a browser and login to your Dropbox account to associate.

```
docker logs dropbox
```

You should see something like this:

> "This computer is now linked to Dropbox. Welcome xxxx"

follow the link and authenticate on a browser.

##  check sync status

```
docker exec -t -i dropbox dropbox status
```

for help about usage:

```
docker exec -t -i dropbox dropbox help
```

## Exposed volumes

```
/dbox/Dropbox - Dropbox files
/dbox/.dropbox - Dropbox account configuration
```



Created with ![heart](https://github.githubassets.com/images/icons/emoji/unicode/2764.png) using VScodium and Debian Linux.

Made in Brazil ![brazil](https://github.githubassets.com/images/icons/emoji/unicode/1f1e7-1f1f7.png)