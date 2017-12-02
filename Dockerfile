FROM ubuntu:16.04
RUN apt-get update && apt-get install -y \
        build-essential \
        wget \
        git \
        python-dev \
        unzip \
        python-numpy \
        python-scipy \
        mecab \ 
        libmecab-dev \
        mecab-ipadic-utf8 \
        curl \
        ruby \
        ruby-dev \
        bundler \
        && rm -rf /var/cache/apk/*

RUN git clone --depth 1 https://github.com/facebookresearch/fastText.git /usr/local/fastText && \
  rm -rf /usr/local/fastText/.git* && \
  cd /usr/local/fastText && \
  make

RUN git config --global http.postBuffer 1048576000 && \
  git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/mecab-ipadic-neologd && \
  cd /tmp/mecab-ipadic-neologd && \
  ./bin/install-mecab-ipadic-neologd -n -a -y && \
  rm -rf /tmp/mecab-ipadic-neologd && \
  sed -i -e "s/^dicdir/dicdir = \/usr\/lib\/mecab\/dic\/mecab-ipadic-neologd\n; dicdir/g" /etc/mecabrc

WORKDIR /usr/src/app

## Cache bundle install
ADD ./Gemfile Gemfile
ADD ./Gemfile.lock Gemfile.lock
RUN bundle install

CMD ["/usr/local/fastText/fasttext"]