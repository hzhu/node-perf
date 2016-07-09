FROM ubuntu

ENV APP_ROOT /node-perf

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
RUN apt-get install -y build-essential flex bison curl sudo apt-utils vim
RUN cd linux/tools/perf/ && make all && cp perf /usr/bin/ && /usr/bin/perf -h

RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs

ADD server.js ${APP_ROOT}/server.js
ADD scripts/start.sh start.sh

EXPOSE 8080

CMD ["bash", "start.sh"]