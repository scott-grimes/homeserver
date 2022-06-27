# README

1) Assume root, copy files to `/data` then

```
if ! apt -qq list unzip 2> /dev/null | grep -q installed ; then
  apt install -y unzip
fi;

if ! apt -qq list fuse 2> /dev/null | grep -q installed ; then
  apt install -y fuse
fi;

if ! which rclone; then
  curl -O https://downloads.rclone.org/v1.57.0/rclone-v1.57.0-linux-arm64.zip;
  unzip rclone-v1.57.0-linux-arm64.zip;
  mv rclone-v1.57.0-linux-arm64/rclone /usr/bin;
  rm -rf rclone*;
fi;

mv rclone.service /etc/systemd/system/rclone.service
```

2) Complete rclone.conf

# move rclone.service to /etc/systemd/system/rclone.service
mkdir -p /data/media /data/localmedia
chmod 0777 /data/media /data/localmedia
docker-compose up -d

# Encrypt and Chunk on local, push to remote
```
FROM_FOLDER="mydir"
TO_FOLDER="somedir/mydir"
LOCAL_TEMP_STORAGE="/tmp"

ENC_DIR="$(rclone cryptdecode opendrivecrypt: "$TO_FOLDER" --reverse | awk '{print $NF}')";
LOCAL_FOLDER="${LOCAL_TEMP_STORAGE}/${ENC_DIR}";
REMOTE_FOLDER="data/${ENC_DIR}"

echo "~/git/rclone/rclone move --delete-empty-src-dirs \"./$FROM_FOLDER\"   \"localdata:$TO_FOLDER\" --progress && rm -rf \"./$FROM_FOLDER\""
echo "~/git/rclone/rclone move --delete-empty-src-dirs 'local:$LOCAL_FOLDER'   'opendrivebase:$REMOTE_FOLDER' -vv --log-file '${LOCAL_TEMP_STORAGE}/$FROM_FOLDER.log' --temp-dir '${LOCAL_TEMP_STORAGE}/tmp-$FROM_FOLDER' --timeout 15m --user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36' --retries 10 &"
```

# check for filenames longer than 100 chars
```
find . -type f -exec basename {} \; | awk '{ if(length($0) > 100) print $0 }'
```

# rename files
```
for i in *; do echo mv "\"$i\"" "\"$(echo $i | sed 's/FOO/BAR/i')\""; done;
```
