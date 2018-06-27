FROM asciidoctor/docker-asciidoctor:latest

RUN apk --no-cache update; \
    apk --no-cache add git; \
    apk --no-cache add --virtual buildtools ruby-dev gcc libc-dev; \
    TDIR=$(mktemp -d); \
    ( cd $TDIR && \
      echo 'fix stem problem in asciidoctor-mathematical v0.1.0 gem' && \
      gem uninstall asciidoctor-mathematical && \
      git clone https://github.com/asciidoctor/asciidoctor-mathematical.git am && \
      cd am && \
      sed -r -i 's/VERSION = "[^"]*/&.1/' lib/asciidoctor-mathematical/version.rb && \
      gem build asciidoctor-mathematical.gemspec && \
      gem install --no-document asciidoctor-mathematical; \
    ); \
    rm -rf $TDIR; \
    apk --no-cache add ruby-bundler; \
    echo 'install kramdoc converter'; \
    cd /home && \
    git clone https://github.com/asciidoctor/kramdown-asciidoc.git kd && \
    cd kd && \
    bundle install --system --binstubs /usr/local/bin --without=coverage; \
    apk --no-cache del buildtools;
