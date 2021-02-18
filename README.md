# reprepro-gcs-docker

Docker image for mounting a GCS bucket that stores the files for a reprepro-managed repository.

### Suggested Usage - GitHub Actions

```
      - name: Write secrets to file
        shell: bash
        env:
          APT_GCS_SERVICE_ACCT_KEY: ${{secrets.APT_GCS_SERVICE_ACCT_KEY}}
          APT_PUB_GPG_SIGNING_KEY: ${{secrets.APT_PUB_GPG_SIGNING_KEY}}
          APT_SEC_GPG_SIGNING_KEY: ${{secrets.APT_SEC_GPG_SIGNING_KEY}}
        # Private key must have perms reduced
        run: |
          mkdir -p ${{ github.workspace }}/{gcloud,config}
          echo "$APT_GCS_SERVICE_ACCT_KEY" > ${{ github.workspace }}/gcloud/service-account.json
          echo "$APT_PUB_GPG_SIGNING_KEY" > ${{ github.workspace }}/config/reprepro_pub.gpg
          echo "$APT_SEC_GPG_SIGNING_KEY" > ${{ github.workspace }}/config/reprepro_sec.gpg
          chmod 600 ${{ github.workspace }}/config/reprepro_sec.gpg

      - name: Create and start Docker image
        run: |
          docker create \
            --privileged \
            --name reprepro-gcs \
            --env GCS_BUCKET_NAME=${{ secrets.APT_GCS_BUCKET_NAME }} \
            --env DISTRO_NAME=pi-top-os \
            --volume ${{ github.workspace }}/gcloud:/gcloud \
            --volume ${{ github.workspace }}/config:/config \
            --volume ${{ github.workspace }}/deb:/incoming \
            --tty \
            pitop/reprepro-gcs:latest \
            sleep inf
          docker start reprepro-gcs

      - name: Mount GCS to filesystem
        run: |
          docker exec reprepro-gcs /mount-gcs.sh

      - name: Import GPG signing keys
        run: |
          docker exec reprepro-gcs /import-gpg-keys.sh

      - name: Deploy to APT repository
        run: |
          docker exec reprepro-gcs /include-changes-from-incoming.sh
```

### Environment Variables

* `GCS_BUCKET_NAME` - name of the GCS bucket that you want to access
* `DISTRO_NAME` - name of the distribution to include the Debian package in

### Volumes

#### `/config`

Path to GPG key files at `/config/reprepro_pub.gpg` and `/config/reprepro_sec.gpg`, or `.gnupg` if already imported. Run `/import-gpg-keys.sh` if keys have not yet been imported.

#### `/gcloud`

Provide service account credentials at `/gcloud/service-account.json` to mount gcsfuse.

#### `/incoming`

Path to Debian package files - e.g. `.deb`, `.dsc`, `.buildinfo`, `.changes`.
