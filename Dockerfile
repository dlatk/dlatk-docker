FROM python:stretch
MAINTAINER Michael Becker

ENV PYTHONUNBUFFERED 1

# System requirements. Remove mysql since that will run in a seperate container
RUN apt-get update
RUN wget https://raw.githubusercontent.com/dlatk/dlatk/public/install/requirements.sys
RUN cat requirements.sys | egrep -v "mysql-server|libmysqlclient-dev" > requirements.sys2 && mv requirements.sys2 requirements.sys
RUN xargs apt-get -y install < requirements.sys && rm -rf requirements.sys
RUN apt-get -y install default-mysql-client

# Python requirements
RUN wget https://raw.githubusercontent.com/dlatk/dlatk/public/install/requirements.txt
RUN pip install -r requirements.txt && rm -rf requirements.txt

# dlatk
RUN pip install dlatk

# wordnet
RUN python -c "import nltk; nltk.download('wordnet')"

# mallet
RUN apt-get install -y default-jre 
RUN wget http://mallet.cs.umass.edu/dist/mallet-2.0.8.tar.gz 
RUN tar -xvzf mallet-2.0.8.tar.gz && mv mallet-2.0.8 /mallet && rm -rf mallet-2.0.8.tar.gz
ENV PATH="${PATH}:/mallet/bin"

# stanford parser
RUN wget https://nlp.stanford.edu/software/stanford-parser-full-2017-06-09.zip
RUN export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && mkdir -p $DLATK_DIR/Tools/StanfordParser && unzip stanford-parser-full-2017-06-09.zip -d $DLATK_DIR/Tools/StanfordParser && rm -rf stanford-parser-full-2017-06-09.zip
RUN export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && wget https://raw.githubusercontent.com/dlatk/dlatk/public/dlatk/Tools/oneline.sh && cp oneline.sh $DLATK_DIR/Tools/StanfordParser/stanford-parser-full-2017-06-09/ && rm -rf oneline.sh

# tweet nlp
RUN wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ark-tweet-nlp/ark-tweet-nlp-0.3.2.tgz
RUN export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && mkdir -p $DLATK_DIR/Tools/TwitterTagger && tar -xvzf ark-tweet-nlp-0.3.2.tgz -C $DLATK_DIR/Tools/TwitterTagger
RUN rm -rf ark-tweet-nlp-0.3.2.tgz

# optional python packages
RUN pip install jsonrpclib-pelix simplejson textstat

# can't download IBM wordcloud so patch wordcloud.py to use amueller version
RUN export DLATK_DIR=`find /usr/local/lib -name 'dlatk'` && cat "$DLATK_DIR/lib/wordcloud.py" | sed "s/='ibm'/='amueller'/" > "$DLATK_DIR/lib/wordcloud.py"

COPY bashrc.template /root/
COPY mycnf.template /root/
COPY setup_env.sh /root/

ENTRYPOINT bash /root/setup_env.sh && /bin/bash
