FROM amazonlinux:latest

RUN yum -y update && yum install -y gcc-c++ make git

RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs

RUN node -v && npm -v

######################
# ffmpeg install
RUN cd /tmp \
    && git clone git://source.ffmpeg.org/ffmpeg.git ffmpeg \
    && cd ffmpeg \
    && ./configure \
        --disable-debug \
        --disable-x86asm \
        --disable-gpl \
        --enable-nonfree \
    && make install
######################

# image: 8-onbuild
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD ARG NODE_ENV
ONBUILD ENV NODE_ENV $NODE_ENV
ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm install && npm cache clean --force
ONBUILD COPY . /usr/src/app

CMD [ "npm", "start" ]

