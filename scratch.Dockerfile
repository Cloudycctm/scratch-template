FROM oven/bun:1 AS bun

FROM rust:1-bookworm AS builder

# scratch-interface / cargo-xwin build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    clang \
    git \
    lld \
    llvm \
    nasm \
    pkg-config \
    python3 \
    tar \
    && rm -rf /var/lib/apt/lists/*

# scratch-interface build.rs invokes bun
COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun

# Linux + Windows MSVC targets
RUN rustup target add \
    x86_64-unknown-linux-gnu \
    x86_64-pc-windows-msvc

RUN rustup component add rustfmt llvm-tools

RUN cargo install --locked cargo-xwin

COPY . /workspace

WORKDIR /workspace/scratch-interface

# Build native Linux bridge
RUN cargo build \
    --release \
    --locked \
    --target x86_64-unknown-linux-gnu

# Cross-compile Windows MSVC bridge
RUN cargo xwin build \
    --release \
    --locked \
    --target x86_64-pc-windows-msvc

# Bob receives everything written to _BOB_OUT
RUN mkdir -p \
      /workspace/_BOB_OUT/x86_64-linux \
      /workspace/_BOB_OUT/x86_64-windows \
    && cp \
      target/x86_64-unknown-linux-gnu/release/rlbot-scratch-bridge \
      /workspace/_BOB_OUT/x86_64-linux/rlbot-scratch-bridge \
    && cp \
      target/x86_64-pc-windows-msvc/release/rlbot-scratch-bridge.exe \
      /workspace/_BOB_OUT/x86_64-windows/rlbot-scratch-bridge.exe \
    && chmod +x \
      /workspace/_BOB_OUT/x86_64-linux/rlbot-scratch-bridge \
    && cp \
      /workspace/project.sb3 \
      /workspace/_BOB_OUT/project.sb3

WORKDIR /workspace/_BOB_OUT

CMD ["tar", "-cf", "-", "."]