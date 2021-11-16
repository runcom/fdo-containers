sudo podman build -t fdo-owner-onboarding-server --target fdo-owner-onboarding-server .
sudo podman build -t fdo-rendezvous-server --target fdo-rendezvous-server .
sudo podman build -t fdo-manufacturing-server --target fdo-manufacturing-server .
sudo pip3 install podman-compose
./create-keys
sudo podman-compose up
