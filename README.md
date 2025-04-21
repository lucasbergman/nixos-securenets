I use [NixOS](https://nixos.org) on machines at my house and in the cloud, and
I use [Terranix](https://terranix.org) and
[Terraform](https://developer.hashicorp.com/terraform) to manage cloud assets
with configuration in the Nix language. I have some simple
[WireGuard](https://www.wireguard.com) network mesh among those machines.

This repository has a NixOS module and a Terranix module. The former sets up
the WireGuard client on the hosts, and the latter sets up Google Cloud DNS
records, all from a single configuration in a Nix attrset.

This isn't turnkey for people other than me, but it... might be kind of close?
If you find this useful, I'd appreciate patches.
