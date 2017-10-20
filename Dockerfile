FROM asciidoctor/docker-asciidoctor
RUN dnf install -y hostname npm bzip2 && dnf clean all
RUN npm install -g phantomjs-prebuilt
RUN npm install -g mermaid
ADD . /book
WORKDIR /book
VOLUME output /book/output
CMD ["make","all"]
