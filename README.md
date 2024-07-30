# Vanilla OS Pico Image

Containerfile for building a Vanilla OS Pico image.

> [!NOTE]
> This image is not intended to be used directly. It is used as a base image for the [Vanilla OS Core](https://github.com/vanilla-os/core-image) vision image.

## Build

You need the Git, Podman and [Vib](https://github.com/vanilla-os/Vib) to generate the Containerfile and build the image locally.

```bash
git clone https://github.com/Vanilla-OS/pico-image -b vision
cd rootfs && sh build.sh && cd ..
vib build recipe.yml
podman image build -t vanillaos/pico .
```

## Verify Image Build Provenance Attestation

All the image builds/pushes are attested for build provenance and integrity using the [attest-build-provenance`](https://github.com/actions/attest-build-provenance) action. The attestations can be verified [here](https://github.com/Vanilla-OS/pico-image/attestations) or by having the latest version of [GitHub CLI](https://github.com/cli/cli/releases/latest) installed in your system. Then, execute the following command:

```sh
gh attestation verify oci://ghcr.io/vanilla-os/pico:vision --owner Vanilla-OS
```
