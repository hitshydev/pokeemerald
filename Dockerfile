# syntax=docker/dockerfile:1

FROM devkitpro/devkitarm:latest AS build
LABEL maintainer="hitshydev"

WORKDIR /repos
RUN sudo apt-get update
RUN sudo apt-get install -y build-essential binutils-arm-none-eabi git libpng-dev
RUN sudo ln -s /proc/self/mounts /etc/mtab
RUN dkp-pacman -Sy
RUN dkp-pacman -S gba-dev --noconfirm
RUN mkdir repos
RUN cd repos
RUN git clone https://github.com/hitshydev/pokeemerald.git
RUN git clone https://github.com/pret/agbcc
WORKDIR /repos/agbcc
RUN ./build.sh
RUN ./install.sh ../pokeemerald
WORKDIR /repos/pokeemerald
RUN make 

FROM scratch AS export
COPY --from=build /repos/pokeemerald/pokeemerald.gba /pokeemerald.gba