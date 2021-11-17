sudo podman build -t fdo-owner-onboarding-server --target fdo-owner-onboarding-server .
sudo podman build -t fdo-rendezvous-server --target fdo-rendezvous-server .
sudo podman build -t fdo-manufacturing-server --target fdo-manufacturing-server .
./create-keys
sudo podman run -e LOG_LEVEL=trace -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers -v $PWD/config/rendezvous-info.yml:/etc/fdo/rendezvous-info.yml -v $PWD/config/manufacturing-server.yml:/etc/fdo/manufacturing-server.yml -v $PWD/keys:/etc/fdo/keys -p 0.0.0.0:8080:8080 localhost/fdo-manufacturing-server
sudo podman run -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers -v $PWD/keys:/etc/fdo/keys -p 0.0.0.0:8081:8081 localhost/fdo-owner-onboarding-server
sudo podman run -v $PWD/ownership_vouchers:/etc/fdo/ownership_vouchers -v $PWD/keys:/etc/fdo/keys -v $PWD/rendezvous_registered:/etc/fdo/rendezvous_registered -p 0.0.0.0:8082:8082 localhost/fdo-rendezvous-server
