# reprepro-gcs-docker

Docker image for mounting a GCS bucket that stores the files for a reprepro-managed repository.

### Suggested Usage - GitHub Actions

```
mkdir -p ${{ github.workspace }}/gcloud ${{ github.workspace }}/mnt

docker create \
  --privileged \
  --name reprepro-gcs-docker \
  --volume ${{ github.workspace }}/gcloud:/gcloud \
  --volume ${{ github.workspace }}/mnt:/mnt \
  --tty \
  pitop/reprepro-gcs \
  sleep inf
docker start reprepro-gcs-docker
docker exec reprepro-gcs-docker gcsfuse --implicit-dirs -o allow_other ${APT_GCS_BUCKET_NAME} /mnt
```

### Volumes

#### `/gcloud`

Service account credentials will be picked up at `/gcloud/service-account.json`.

#### `/config`

Either provide public and private GPG keys as `/config/reprepro_pub.gpg` and `/config/reprepro_sec.gpg` and call `/import-gpg-keys.sh` in the Docker machine to import them, or use `/config/.gnupg` directly.
