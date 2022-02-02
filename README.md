```
sudo podman build -t localhost/fdo-manufacturing-server --target fdo-manufacturing-server .
sudo podman build -t localhost/fdo-owner-onboarding-server --target fdo-owner-onboarding-server .
sudo podman build -t localhost/fdo-rendezvous-server --target fdo-rendezvous-server .
./create-keys
sudo podman run --init \
  -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers \
  -v $PWD/config/rendezvous-info.yml:/etc/fdo/rendezvous-info.yml \
  -v $PWD/config/manufacturing-server.yml:/etc/fdo/manufacturing-server.yml \
  -v $PWD/keys:/etc/fdo/keys \
  -p 0.0.0.0:8080:8080 \
  localhost/fdo-manufacturing-server
sudo podman run --init \
  -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers \
  -v $PWD/config/owner-onboarding-server.yml:/etc/fdo/owner-onboarding-server.yml \
  -v $PWD/config/owner-addresses.yml:/etc/fdo/owner-addresses.yml \
  -v $PWD/keys:/etc/fdo/keys \
  -p 0.0.0.0:8081:8081 \
  localhost/fdo-owner-onboarding-server
sudo podman run --init \
  -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers \
  -v $PWD/keys:/etc/fdo/keys \
  -v $PWD/config/rendezvous-server.yml:/etc/fdo/rendezvous-server.yml \
  -v $PWD/rendezvous_registered:/etc/fdo/rendezvous_registered \
  -p 0.0.0.0:8082:8082 \
  localhost/fdo-rendezvous-server
```
