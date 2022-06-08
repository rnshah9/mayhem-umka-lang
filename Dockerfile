# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y gcc

ADD . /umka-lang
WORKDIR /umka-lang
RUN ./build_linux.sh

RUN mkdir -p /deps
RUN ldd /umka-lang/umka_linux/umka | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /umka-lang/umka_linux/umka /umka-lang/umka_linux/umka
ENV LD_LIBRARY_PATH=/deps
