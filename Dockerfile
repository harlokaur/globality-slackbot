FROM python:3-slim

WORKDIR /globality
# install vim git curl
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git vim curl unzip


################################################
# NOT REQUIRED
################################################
#install aws cli
#RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
#    unzip awscliv2.zip && \
#    ./aws/install 

ADD aws/config /root/.aws/config
ADD aws/credentials /root/.aws/credentials
ADD ssh/id_rsa /root/.ssh/id_rsa
ADD ssh/id_rsa.pub /root/.ssh/id_rsa.pub

RUN chmod 0600 /root/.ssh/id_rsa && \
     chmod 0644 /root/.ssh/id_rsa.pub && \
     touch ~/.ssh/config; chmod 600 ~/.ssh/config; echo StrictHostKeyChecking no >> ~/.ssh/config

#cryptography module should solve the cffi issue
#lambda functions require - https://github.com/globality-corp/botoenv for local development
#lets you  assume role as automation which can then assume role as slackbot automation 
RUN git clone git@github.com:globality-corp/botoenv.git   && \
    cd botoenv && \
    python -m pip install virtualenv virtualenvwrapper python-lambda-local botoenv cryptography

#install dependent libraries for slackbot - marquez-aws and service-directory
RUN git clone git@github.com:globality-corp/marquez-aws.git  && \
    git clone git@github.com:globality-corp/service-directory.git 

COPY src/ /globality/

#NOT REQUIRED 
#To enable mkvirtualenv
#ENV PATH="/globality/globality-bots/functions/slackbot/bin:$PATH"
RUN echo "export WORKON_HOME=$HOME/.virtualenvs;export PROJECT_HOME=$HOME/Devel;source /usr/local/bin/virtualenvwrapper.sh " >> ~/.bashrc && \
    /bin/bash -c "source ~/.bashrc"

WORKDIR /globality/globality-bots/functions

#create a virtual env and activate it 
RUN python -m virtualenv slackbot && \
    /bin/bash -c "source slackbot/bin/activate" && \
    cd /globality/marquez-aws ; pip install . && \
    cd /globality/service-directory ; pip install . && \
    cd /globality/globality-bots/functions/slackbot && \
    pip install -r requirements.txt

#FIX timezone 
RUN echo "America/Boise" > /etc/timezone  && \
    ln -sf /usr/share/zoneinfo/America/Boise /etc/localtime 
RUN dpkg-reconfigure -f noninteractive tzdata

CMD tail -f /dev/null


#----
# docker exec -it f03390290fd1 bash
# cd slackbot 
# mkvirtualenv slackbot
# eval $(botoenv -p automation)
# python-lambda-local -t 600 -e env.json -f handler main.py test/fixtures/event-status.json 