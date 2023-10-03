# ou-mst374-vce-demo
Demo of Docker container for OU MST374 module

## Building and Cross-Building

Uses (a forked version of) `ou-container-builder` to generate a Dockerfile from which the image is built:

```bash
# Generate Dockerfile etc
ou-container-builder --no-build --no-clean

# Simple build test
docker build -t mst374test .

# Cross-build and push to DockerHub
docker buildx build --platform linux/amd64,linux/arm64 . --tag  ousefuldemos/mst374test --push
```
