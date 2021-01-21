FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

# Install bazelisk so that it is available on the command line
RUN npm install -g @bazel/bazelisk

# Install buildifier and buildozer
ENV GOPATH=$HOME/go-packages
RUN go get -u -v github.com/bazelbuild/buildtools/buildifier
RUN go get -u -v github.com/bazelbuild/buildtools/buildozer
ENV GOPATH=/workspace/go