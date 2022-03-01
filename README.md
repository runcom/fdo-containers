```bash
sudo podman build -t localhost/fdo-manufacturing-server --target fdo-manufacturing-server .
sudo podman build -t localhost/fdo-owner-onboarding-server --target fdo-owner-onboarding-server .
sudo podman build -t localhost/fdo-rendezvous-server --target fdo-rendezvous-server .
sudo podman build -t localhost/fdo-admin-cli --target fdo-admin-cli .
./create-keys

# edit $PWD/config/manufacturing-server.yaml to point to the correct rendezvous server
# edit $PWD/config/owner-onboarding-server.yaml to point to the correct owner server

sudo podman run --init \
  -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers:z \
  -v $PWD/config/manufacturing-server.yml:/etc/fdo/manufacturing-server.conf.d/00-default.yml:z \
  -v $PWD/keys:/etc/fdo/keys:z \
  -p 0.0.0.0:8080:8080 \
  localhost/fdo-manufacturing-server
sudo podman run --init \
  -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers:z \
  -v $PWD/config/owner-onboarding-server.yml:/etc/fdo/owner-onboarding-server.conf.d/00-default.yml:z \
  -v $PWD/keys:/etc/fdo/keys:z \
  -p 0.0.0.0:8081:8081 \
  localhost/fdo-owner-onboarding-server
sudo podman run --init \
  -v $PWD/rendezvous_registered:/etc/fdo/rendezvous_registered:z \
  -v $PWD/config/rendezvous-server.yml:/etc/fdo/rendezvous-server.conf.d/00-default.yml:z \
  -v $PWD/keys:/etc/fdo/keys:z \
  -p 0.0.0.0:8082:8082 \
  localhost/fdo-rendezvous-server
```
