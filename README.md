<h1 align="center">MOSS Plagiarism Detection Flake</h1>

<p align="center">
  A Nix flake that installs Stanford's <a href="http://theory.stanford.edu/~aiken/moss/">MOSS</a> (Measure of Software Similarity) script,<br>
  without this repository ever holding a copy of it.
</p>

<p align="center">
  <img src=".github/assets/moss-pipeline.svg" width="100%" alt="Diagram of the build: you set MOSS_SCRIPT_URL to your private copy of the mossnet script, Nix fetchurl downloads it and checks it against the sha256 pinned in flake.nix, installs it in the Nix store as bin/moss, and links it to ./result/bin/moss. The script is never stored in this repository.">
</p>

MOSS detects plagiarism in programming assignments. Its client script,
`mossnet`, may be shared between instructors but must not be published, so it
cannot live in a public repository. This flake is for instructors who already
have that script: you point it at your copy, and Nix builds a reproducible
`moss` command from it.

## Quick start

1. Enable flakes. Add this to `/etc/nix/nix.conf` or `~/.config/nix/nix.conf`
   if your [Nix](https://nixos.org/download.html) install does not have it yet:

   ```ini
   experimental-features = nix-command flakes
   ```

2. Point the flake at your copy of the script and build:

   ```sh
   export MOSS_SCRIPT_URL=http://example.com/mossnet
   nix build --impure
   ```

   Replace `http://example.com/mossnet` with the URL of your own copy.
   `--impure` is required because the URL is read from the environment.

3. Run it:

   ```sh
   ./result/bin/moss
   ```

You can also build without cloning:

```sh
MOSS_SCRIPT_URL=http://example.com/mossnet nix build --impure github:jakob1379/moss-flake
```

## How the build works

- **The URL comes from you.** `flake.nix` reads `MOSS_SCRIPT_URL`. If it is
  unset or empty, evaluation stops with `No MOSS script URL provided. Build failed.`
- **The content is pinned.** The script is downloaded with `fetchurl` and must
  match the `sha256` in `flake.nix`. If your copy differs, the build fails with
  a hash mismatch; update the hash in `flake.nix` to the one Nix reports.
- **The result is a plain command.** The script is copied to `bin/moss` in the
  Nix store and linked to `./result/bin/moss`. It is also exposed as
  `packages.<system>.moss`.
- **It is marked unfree.** The package's license is `unfreeRedistributable`. If
  Nix refuses to evaluate it for that reason, allow unfree packages, for
  example with `NIXPKGS_ALLOW_UNFREE=1` alongside `--impure`.

### Dependencies

- **Perl**: `mossnet` is a Perl script. The flake adds `perl` to the build
  inputs.

## Legal notice

The MOSS script (`mossnet`) is **not freely redistributable**. According to the
legal notice in the script itself:

> "Feel free to share this script with other instructors of programming
> classes, but **please do not place the script in a publicly accessible
> place**."

This flake does **not include the MOSS script**. You fetch it yourself from a
location you control, which keeps you within MOSS's terms of use. Use this
flake responsibly and in accordance with the legal notice provided by Stanford
University.

## License

The MOSS script is licensed by Stanford University and is not freely
redistributable. This repository itself, excluding the downloaded MOSS script,
is licensed under the [MIT License](./LICENSE).

## Disclaimer

This repository does not host or redistribute the MOSS script itself. It
provides tooling to help you install it, but you must ensure that your usage
complies with Stanford University's guidelines.
