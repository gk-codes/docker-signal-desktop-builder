FROM fedora:35

ARG SIGNAL_VERSION
ARG NODE_VERSION

SHELL ["/bin/bash", "-c"]

RUN echo "Signal version: ${SIGNAL_VERSION}"
RUN echo "Node version: ${NODE_VERSION}"

RUN dnf groupinstall -y 'Development Tools'
RUN dnf install -y g++ git-lfs jq
RUN dnf clean all

ENV NVM_DIR=/root/.nvm

RUN git clone \
    -b v$SIGNAL_VERSION --single-branch \
    https://github.com/signalapp/Signal-Desktop.git /Signal-Desktop

WORKDIR /Signal-Desktop

RUN git checkout v$SIGNAL_VERSION

RUN curl --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN npm install --global yarn

RUN node --version
RUN npm --version

# find the build target line number in package.json and change it from "deb" to "AppImage"
RUN linenumber=$(jq . package.json | grep -n -m 1 -w '"deb"' | cut -d':' -f1) \
    && sed -i "${linenumber}s/deb/AppImage/" package.json

RUN git-lfs install
RUN yarn install --frozen-lockfile
RUN yarn generate
RUN yarn build:webpack
RUN yarn generate
RUN yarn build-release

WORKDIR /Signal-Desktop/release

EXPOSE 8080
CMD ["python3", "-m", "http.server", "8080"]
