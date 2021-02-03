FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

ARG CMAKE_VER=3.17.5

RUN apt-get update \
  && apt-get install -y ssh \
    build-essential \
    libssl-dev \
    gcc \
    g++ \
    gdb \
    clang \
    rsync \
    tar \
    python \
    sudo \
  && apt-get clean

# Upgrade cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v$CMAKE_VER/cmake-$CMAKE_VER.tar.gz -O cmake-$CMAKE_VER.tar.gz \
  && tar -xzf cmake-$CMAKE_VER.tar.gz \
  && cd cmake-$CMAKE_VER \
  && ./configure \
  && make \
  && sudo make install \
  && cd .. \
  && rm -r cmake-* \
  && sudo update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_development \
  && mkdir /run/sshd

ENV DEBIAN_FRONTEND=keyboard-interactive
RUN useradd -m remote && yes password | passwd remote

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_development"]
