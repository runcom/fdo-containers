FROM centos:stream8 AS fdo-base

RUN yum update -y && yum install -y cargo gcc golang git-core openssl-devel tpm2-tss-devel jq
RUN git clone https://github.com/fedora-iot/fido-device-onboard-rs.git && \
    cd fido-device-onboard-rs && \
    git checkout v0.4.0 && \
    cargo vendor vendor && \
    sed -i 's/2.3.3/2.3.2/g' vendor/tss-esapi-sys/build.rs && \
    cat vendor/tss-esapi-sys/.cargo-checksum.json |jq '.files."build.rs" = "4c8649e92bafa9834c7db410c08bd5da8017708dec46a7ddbc526a8f86e91f11"' \
    > /tmp/.cargo-checksum.json && mv /tmp/.cargo-checksum.json vendor/tss-esapi-sys/.cargo-checksum.json && \
    mkdir .cargo && \
    printf '[source.crates-io]\n\
replace-with = "vendored-sources"\n\
[source.vendored-sources]\n\
directory = "vendor"' >> .cargo/config.toml && \
    cargo build --release --features openssl-kdf/deny_custom,fdo-data-formats/use_noninteroperable_kdf

FROM registry.access.redhat.com/ubi8/ubi-minimal AS fdo-manufacturing-server
COPY --from=fdo-base /fido-device-onboard-rs/target/release/fdo-manufacturing-server /usr/local/bin
RUN microdnf install tpm2-tss
RUN mkdir -p /etc/fdo/sessions
RUN mkdir -p /etc/fdo/manufacturing-server.conf.d
ENV LOG_LEVEL=trace
ENTRYPOINT ["fdo-manufacturing-server"]

FROM registry.access.redhat.com/ubi8/ubi-minimal AS fdo-owner-onboarding-server
COPY --from=fdo-base /fido-device-onboard-rs/target/release/fdo-owner-onboarding-server /usr/local/bin
RUN microdnf install tpm2-tss
RUN mkdir -p /etc/fdo/sessions
RUN mkdir -p /etc/fdo/owner-onboarding-server.conf.d
ENV LOG_LEVEL=trace
ENV ALLOW_NONINTEROPERABLE_KDF=1
ENTRYPOINT ["fdo-owner-onboarding-server"]

FROM registry.access.redhat.com/ubi8/ubi-minimal AS fdo-rendezvous-server
COPY --from=fdo-base /fido-device-onboard-rs/target/release/fdo-rendezvous-server /usr/local/bin
RUN microdnf install tpm2-tss
RUN mkdir -p /etc/fdo/sessions
RUN mkdir -p /etc/fdo/rendezvous-server.conf.d
ENV LOG_LEVEL=trace
ENTRYPOINT ["fdo-rendezvous-server"]

FROM registry.access.redhat.com/ubi8/ubi-minimal AS fdo-admin-cli
COPY --from=fdo-base /fido-device-onboard-rs/target/release/fdo-admin-tool /usr/local/bin
ENTRYPOINT ["fdo-admin-tool"]
