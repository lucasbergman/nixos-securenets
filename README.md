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

To get started, make sure NixOS hosts import something vaguely like this to
describe all the hosts on the secure network:

```nix
slb.securenets.foonet = {
  domain = "foonet.example.com";
  hosts = [
    {
      name = "cloudy";
      addr = "10.9.0.1";
      pubkey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
      site = "linode-us-central";
      globalEndpoint = "1.2.3.4";
    }
    {
      name = "homeserver";
      addr = "10.9.0.2";
      pubkey = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
      site = "house";
      siteEndpoint = "192.168.1.3";
    }
    # ...
  ];
};
```

Then each host gets a WireGuard client interface set up based on the values
set in `slb.securenet.network` and `networking.hostname`. For example, this
setup on the `homeserver` machine causes its WireGuard interface to have the
address 10.9.0.2 and to have peer configs for all the other hosts in the list.

```nix
# on host homeserver
networking.hostname = "homeserver";
slb.securenet = {
  enable = true;
  network = "foonet";
  privateKeyPath = "/etc/foonet-wg-key";
};
```
