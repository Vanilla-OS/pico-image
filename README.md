# Vanilla OS Pico Image

Containerfile for building a Vanilla OS Pico image.

> [!NOTE]
> This image is not intended to be used directly. It is used as a base image for the [Vanilla OS Core](https://github.com/vanilla-os/core-image) image.

## Build

You need the [Vib](https://github.com/vanilla-os/Vib) tool to generate the Containerfile.

```bash
cd rootfs && bash build.sh && cd ..
vib build recipe.yml
podman image build -t vanillaos/pico .
```

## Verify Image Build Provenance Attestation

All the image builds/pushes are attested for build provenance and integrity using the [attest-build-provenance](https://github.com/actions/attest-build-provenance) action. The attestations can be verified [here](https://github.com/Vanilla-OS/pico-image/attestations) or by having the latest version of [GitHub CLI](https://github.com/cli/cli/releases/latest) installed in your system. Then, execute the following command:

```sh
gh attestation verify oci://ghcr.io/vanilla-os/pico:latest --owner Vanilla-OS
```

## Use of Generative AI

Maintainers may use generative AI tools as assistants while working on pico-image. Non-trivial assisted commits disclose the tool, model, and scope of the work.

AI tools may assist with code comments, documentation, repetitive code, and issue triage. Maintainers make project decisions and review every assisted change before it is merged.

Use these trailers for non-trivial assisted commits:

```plain
Assisted-by: <tool>:<model-version>
AI-Scope: <what the tool generated and the prompt or a short prompt summary>
```

Single-line completions, renames, and formatting changes do not need trailers.

Coding agents must also follow [AGENTS.md](AGENTS.md) before changing files,
creating commits, or opening pull requests.
