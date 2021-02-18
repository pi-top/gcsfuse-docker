# reprepro-gcs-docker

Docker image for mounting a GCS bucket that stores the files for a reprepro-managed repository.

### Suggested Usage - GitHub Actions

```
mkdir -p ${{ github.workspace }}/gcloud ${{ github.workspace }}/mnt

docker create \
  --privileged \
  --name reprepro-gcs \
  --volume ${{ github.workspace }}/gcloud:/gcloud \
  --volume ${{ github.workspace }}/mnt:/mnt \
  --tty \
  pitop/reprepro-gcs \
  sleep inf
docker start reprepro-gcs
docker exec reprepro-gcs /mount-gcs.sh
docker exec reprepro-gcs /import-gpg-keys.sh  # Only required if .gnupg not already configured
docker exec reprepro-gcs /include-from-incoming.sh
```

### Volumes

#### `/config`

Path to GPG key files at `/config/reprepro_pub.gpg` and `/config/reprepro_sec.gpg`, or `.gnupg` if already imported. Run `/import-gpg-keys.sh` if keys have not yet been imported.

#### `/gcloud`

Provide service account credentials at `/gcloud/service-account.json` to mount gcsfuse.

#### `/incoming`

Path to Debian package files - e.g. `.deb`, `.dsc`, `.buildinfo`, `.changes`.
