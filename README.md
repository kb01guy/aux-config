# My NixOS Configurations

![Forgejo Issues](https://img.shields.io/gitea/issues/open/kb01/nix-config?gitea_url=https%3A%2F%2Fgit.kb-one.de)
![Forgejo Release](https://img.shields.io/gitea/v/release/kb01/nix-config?gitea_url=https%3A%2F%2Fgit.kb-one.de)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This repository contains my Flake based NixOS Configuration Files.

## Usage

### Setup
Clone this Repository somewhere you can edit it easily:
```bash
git clone https://git.informatik.fh-nuernberg.de/SpiegelMa/aux-config ~/Project/aux-config
```

Check if your Hostname matches one of the [Hosts](#hosts) in the config.
```bash
hostname
```
<details>
  <summary>Hostname does not Match (click to expand)</summary>
  Install NixOS on the current system with forced hostname.
  ```bash
  cd ~/Project/aux-config
  sudo nixos-rebuild switch --flake .#voloxo
  ```
  > **Warning**
  > 
  > This will change the Hostname of your System to voloxo!
</details>

Install NixOS for your current Hostname.
```bash
cd ~/Project/aux-config
sudo nixos-rebuild switch --flake .
```

### Updating the Flake Based NixOS Installation
```bash
cd ~/Project/aux-config
sudo nix flake --update   # This Updates the flake.lock
sudo nixos-rebuild switch --flake .
```

### Modify NixOS Installation
1. Edit the config in ~/Project/aux-config `vim system/x86_64-linux/$HOST/default.nix`
2. Stage the Changes if you created or deleted Files `git add .` (They will be ignored if you miss this step!)
3. Build your System to apply the changes `sudo nixos-rebuild switch --flake .`
4. Commit your Changes if satisfied `git commit -m "Added Software hello-world"`
5. Then Push your Changes to the Remote, so that other systems can update `git push`

## Hosts

### [HyperC](./systems/x86_64-linux/HyperC)
Surface Pro 2017 Tablet

Cpu: Intel i5-7300U

Ram: 8GB

### [voloxo](.systems/x86_64-linux/voloxo)
My Gaming Desktop

Cpu: AMD Ryzen 5 5600X

Ram: 32GB

Gpu: NVIDIA GeForce GTX 1070

### [kb-games-01](.systems/x86_64-linux/kb-games-01)
My KVM Server for Gameservers

Cpu: AMD EPYC 7702P 64-Core (4 Cores)

Ram: 16GB

## License

[MIT © kB01](../LICENSE)
