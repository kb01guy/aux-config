# My NixOS Configurations

![Forgejo Issues](https://img.shields.io/gitea/issues/open/kb01/nix-config?gitea_url=https%3A%2F%2Fgit.kb-one.de)
![Forgejo Release](https://img.shields.io/gitea/v/release/kb01/nix-config?gitea_url=https%3A%2F%2Fgit.kb-one.de)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

This repository contains my NixOS Configuration Files.

## Usage
Clone this Repository somewhere you can edit it easily:
```bash
git clone https://git.kb-one.de/kb01/aux-config ~/Projects/aux-config
```

> **Warning**
>
> Only do this if you know what you are doing.

Now clone your local Git-Repo to /etc/nixos:
```bash
sudo rm -R /etc/nixos
sudo git clone ~/Projects/aux-config /etc/nixos
```

Now When you want to change your System, you ...
1. Edit the config in ~/Project/aux-config `vim system/x86_64-linux/$HOST/default.nix`
2. Commit the Changes locally `git commit -m "Some Changes"`
3. Now you `cd /etc/nixos`
4. Update the Changes `sudo git pull --rebase`
5. Build your System to apply the changes `sudo nixos-rebuild switch --flake .`
6. If you are Satisfied with your Changes, switch to ~/Projects/aux-config and Push your Changes to the Remote

## Hosts

### HyperC
Surface Pro 2017 Tablet

Cpu: Intel i5-7300U

Ram: 8GB

### yerukall
Lenovo Thinkpad E14 Gen 4

Cpu: AMD Ryzen 5 5625U

Ram: 16GB

### voloxo
My Gaming Desktop

Cpu: AMD Ryzen 5 5600X

Ram: 32GB

Gpu: NVIDIA GeForce GTX 1070

## License

[MIT © kB01](../LICENSE)
