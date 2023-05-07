# Vanilla OS Pico Image
Containerfile for building a vanilla OS Pico image.

> This image is not intended to be used directly. It is used as a base image for 
> the [Vanilla OS Core](https://github.com/vanilla-os/core-image) image.

## Build

You need the [Vib](https://github.com/vanilla-os/Vib) tool to generate the Containerfile.

```bash
cd rootfs && sh build.sh && cd ..
vib build recipe.yml
podman image build -t vanillaos/pico .
```
