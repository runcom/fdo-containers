# OpenShift / OKD deployment files

The files in this directory provide an easy to deployment example, by
no means this is designed to be used in production, but it should be a
foundation for test environments and initial details before building
something like an operator if necessary.

The generation of the deployment yaml files can be triggered via:
`make manifest`

This is based on the 0.3.0 version of `fido-device-onboard-rs` it's likely
to need changes in future versions since it's a fast moving project in
development.

# Pre-requisite

  As of today, the fido-device-onboard-rs projects uses disk storage in
the form of shared volumes as an initial form of sharing session details,
ownership vouchers, or registrations (rendezvous server).

# Notes

The manufacturing server and the onboarding server share a volume for the ownership
vouchers. In a normal environment, those volumes would be separate, and an out-of-band
mechanism should exist to send the ownership vouchers from the manufacturer to the
final owner. Even in the cases here manufacturer & owner could potentilly be the
same entity, still an instant trigger from Device Initialization into Onboarding is
probably not desired.

# Usage

1) Update the hostnames in:
 - manufacturing-server/config/rendezvous-info.yml:- dns: fido-rendezvous.ajo.es
 - manufacturing-server/route.yaml:  host: fido-manufacturer.ajo.es
 - onboarding-server/config/owner-addresses.yml:    - dns_name: fido-owner-onboarding.ajo.es
 - onboarding-server/route.yaml:  host: fido-owner-onboarding.ajo.es
 - rendezvous-server/route.yaml:  host: fido-rendezvous.ajo.es

2) Insert the entries in your DNS server, pointing to the IP address of the OpenShift router,
   or the OpenShift router load balancer. See `domain-dns-entries.txt` as an example.

3) `oc new-project fido`

4) `make manifest | oc apply -f -`

# Using it from a device example

## Device initialization
```
sudo LOG_LEVEL=trace\
     MANUFACTURING_INFO=123456 \
     DIUN_PUB_KEY_HASH=$(cat keys/diun_pub_key_hash) \
     DI_KEY_STORAGE_TYPE=filesystem USE_PLAIN_DI=false \
     MANUFACTURING_SERVER_URL=http://fido-manufacturer.ajo.es \
     fdo-manufacturing-client
```

This will create `/etc/device-credentials` on the device, and an ownership voucher in
the manufacturing server volume `manufacturing-ownership-vouchers`.

## Device onboarding

```
sudo LOG_LEVEL=trace \
     DEVICE_CREDENTIAL=/etc/device-credentials \
     ALLOW_NONINTEROPERABLE_KDF=1 fdo-client-linuxapp
```

This will trigger the look up on the rendevouz-server (details stored in the device-credentils),
and if the onboarding-server has claimed the device having access to the ownership voucher, it
will be redirected to the onboarding-server, running the onboarding process.
