# Start with a rust alpine image
FROM rust:1-alpine3.19
# This is important, see https://github.com/rust-lang/docker-rust/issues/85
ENV RUSTFLAGS="-C target-feature=-crt-static"
# if needed, add additional dependencies here
RUN apk add --no-cache musl-dev
# set the workdir and copy the source into it
WORKDIR /app
COPY ./ /app
# do a release build
RUN cargo build --release
RUN strip target/release/ovos_messagebus

# use a plain alpine image, the alpine version needs to match the builder
FROM alpine:3.19
ARG IMAGE_VERSION
ARG VCS_REF
LABEL org.opencontainers.image.title="OpenVoiceOS Rust message bus image"
LABEL org.opencontainers.image.description="Message bus service, the nervous system of OpenVoiceOS (Rust implementation)"
LABEL org.opencontainers.image.documentation="https://github.com/thalovant/ovos-rust-messagebus"
LABEL org.opencontainers.image.source="https://github.com/thalovant/ovos-rust-messagebus"
LABEL org.opencontainers.image.vendor="Thalovant"
LABEL org.opencontainers.image.license="Apache-2.0"
# Fail the build rather than ship blank provenance. An image whose version and
# revision labels are empty cannot be traced back to what produced it, and the
# failure is silent at build time and only noticed when somebody needs it.
RUN test -n "${IMAGE_VERSION}" || (echo "IMAGE_VERSION build arg is required: --build-arg IMAGE_VERSION=<version>" >&2; exit 1); \
    test -n "${VCS_REF}" || (echo "VCS_REF build arg is required: --build-arg VCS_REF=\$(git rev-parse HEAD)" >&2; exit 1)
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.revision="${VCS_REF}"
# if needed, install additional dependencies here
RUN apk add --no-cache libgcc netcat-openbsd
# copy the binary into the final image
COPY --from=0 /app/target/release/ovos_messagebus .

# Be sure to secure this with a firewall or reverse proxy
ENV OVOS_BUS_HOST=0.0.0.0

HEALTHCHECK --interval=60s --timeout=10s --retries=3 --start-period=60s \
    CMD nc -z 127.0.0.1 8181 || exit 1

# set the binary as entrypoint
ENTRYPOINT ["/ovos_messagebus"]
