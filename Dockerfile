FROM python:stretch
MAINTAINER Michael Becker

ENV PYTHONUNBUFFERED 1

# System requirements. Remove mysql since that will run in a seperate container
RUN wget https://raw.githubusercontent.com/dlatk/dlatk/public/install/requirements.sys && cat requirements.sys | egrep -v "mysql-server|libmysqlclient-dev" > requirements.sys2 && mv requirements.sys2 requirements.sys && apt-get update && xargs apt-get -y install < requirements.sys && rm -f requirements.sys && apt-get -y install \
    default-mysql-client \
    default-jre 

# Python requirements
RUN wget https://raw.githubusercontent.com/dlatk/dlatk/public/install/requirements.txt && pip install -r requirements.txt && pip install \
    dlatk \ 
    jsonrpclib-pelix \
    simplejson \
    textstat \
&& rm -f requirements.txt

# wordnet
RUN python -c "import nltk; nltk.download('wordnet')"

# mallet
RUN wget http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz && mkdir -p /opt/mallet && tar -xvzf mallet-2.0.8.tar.gz -C /opt/mallet --strip-components=1 && rm -f mallet-2.0.8.tar.gz
ENV PATH="${PATH}:/opt/mallet/bin"

# stanford parser
RUN wget https://nlp.stanford.edu/software/stanford-parser-full-2017-06-09.zip && export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && mkdir -p $DLATK_DIR/Tools/StanfordParser && unzip stanford-parser-full-2017-06-09.zip -d $DLATK_DIR/Tools/StanfordParser && rm -f stanford-parser-full-2017-06-09.zip && wget https://raw.githubusercontent.com/dlatk/dlatk/public/dlatk/Tools/oneline.sh && mv oneline.sh $DLATK_DIR/Tools/StanfordParser/stanford-parser-full-2017-06-09/

# tweet nlp
RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ark-tweet-nlp/ark-tweet-nlp-0.3.2.tgz && export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && mkdir -p $DLATK_DIR/Tools/TwitterTagger && tar -xvzf ark-tweet-nlp-0.3.2.tgz -C $DLATK_DIR/Tools/TwitterTagger && rm -f ark-tweet-nlp-0.3.2.tgz

# can't download IBM wordcloud so patch wordcloud.py to use amueller version
RUN export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && cat "$DLATK_DIR/lib/wordcloud.py" | sed "s/='ibm'/='amueller'/" > "$DLATK_DIR/lib/wordcloud.py"

COPY bashrc.template /root/
COPY mycnf.template /root/
COPY setup_env.sh /root/

ENTRYPOINT bash /root/setup_env.sh && /bin/bash
