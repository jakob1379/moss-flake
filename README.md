# MOSS Plagiarism Detection Flake

This repository provides a Nix flake for installing the MOSS (Measure of Software Similarity) plagiarism detection tool. This flake helps set up a reproducible environment to run the MOSS script, which is used to detect plagiarism in programming assignments.

## Requirements

- [Nix](https://nixos.org/download.html) with experimental features enabled for flakes.
  
  To enable flakes, you can add the following to your Nix configuration (`/etc/nix/nix.conf` or `~/.config/nix/nix.conf`):

  ```ini
  experimental-features = nix-command flakes
  ```

## Installation and Usage

To build and use the MOSS script, run the following command:

```sh
MOSS_SCRIPT_URL=http://example.com/mossnet nix build --impure
```

- `MOSS_SCRIPT_URL`: Set this environment variable to specify the URL for the MOSS script. By default, this script cannot be hosted publicly, so you must provide the URL yourself.
- The `--impure` flag is required because the URL is fetched from an environment variable.

After building, you can run the script using:

```sh
./result/bin/moss
```

This command makes the `moss` script available for use in your environment.

## Configuration Options

The MOSS script URL can be provided in three ways:

1. **Environment Variable (`MOSS_SCRIPT_URL`)**: This is the preferred method. The URL for the script can be set at runtime, ensuring compliance with legal requirements.

   ```sh
   export MOSS_SCRIPT_URL=http://example.com/mossnet
   nix build --impure
   ```

2. **Flake Input Override**: You can override the `mossUrl` input in another flake if using this as a dependency. Example:

   ```nix
   {
     inputs.moss.url = "github:jakob1379/moss-flake";
     inputs.moss.inputs.mossUrl = "http://example.com/mossnet";
   }
   ```

3. **Default Placeholder**: If no URL is provided via environment variable or flake input, a placeholder URL (`http://example.com/mossnet`) is used. This will not work until replaced with the actual MOSS script URL.

## Legal Notice

The MOSS script (`mossnet`) is **not freely redistributable**. According to the legal notice in the script itself:

> "Feel free to share this script with other instructors of programming classes, but **please do not place the script in a publicly accessible place**."

By default, this flake does **not include the MOSS script** directly. Instead, it allows you to **fetch the script yourself**, ensuring compliance with MOSS's terms of use.

Please ensure that you use this flake responsibly and in accordance with the legal notice provided by Stanford University.

## Dependencies

- **Perl**: The MOSS script is written in Perl. This flake ensures that Perl is available in the environment when running the script.

## Example Workflow

1. **Set the URL for the MOSS script**:
   ```sh
   export MOSS_SCRIPT_URL=http://example.com/mossnet
   ```
2. **Build the package**:
   ```sh
   nix build --impure
   ```
3. **Run the MOSS script**:
   ```sh
   ./result/bin/moss
   ```

## License

The MOSS script is licensed by Stanford University and is not freely redistributable. This repository itself, excluding the downloaded MOSS script, is licensed under the [MIT License](./LICENSE).

## Disclaimer

This repository does not host or redistribute the MOSS script itself. It provides tooling to help you install it, but you must ensure that your usage complies with Stanford University's guidelines.

