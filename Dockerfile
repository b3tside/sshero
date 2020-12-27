FROM debian:sid
#GIT
ENV SS_GIT_PATH="https://github.com/shadowsocks/shadowsocks-libev" \
    OBFS_GIT_PATH="https://github.com/shadowsocks/simple-obfs" 
    
COPY wwwroot.tar.gz /wwwroot/wwwroot.tar.gz
COPY entrypoint.sh /entrypoint.sh

RUN set -ex\
    && apt update -y \
    && apt upgrade -y \
    && apt install -y wget unzip qrencode\
    && apt install -y shadowsocks-libev\
    && apt autoremove -y\
    && cd /tmp \
    && git clone ${OBFS_GIT_PATH} \
    && cd ${OBFS_GIT_PATH##*/} \
    && git submodule update --init --recursive \
    && ./autogen.sh \
    && ./configure --prefix=/usr && make \
    && make install \
    && rm -rf /tmp/* \
    && chmod +x /entrypoint.sh

CMD /entrypoint.sh
