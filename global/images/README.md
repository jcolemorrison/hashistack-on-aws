# packer images

These directories contain the Packer definitions to build images and push them
to HCP Packer.

They include:

* `nomad-server` - Nomad server configuration, Docker, Vault, Consul
* `nomad-client` - Nomad client configuration, Docker, Vault, Consul

To push the images to HCP Packer, you need to have the following
credentials set in your environment:

```sh
export HCP_CLIENT_ID=
export HCP_CLIENT_SECRET=
export HCP_PROJECT=

export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
```

Go into the directory for the image you want build
to initialize and build Packer.

```sh
bash build.sh
```