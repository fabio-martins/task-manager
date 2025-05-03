FROM ruby:3.4.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client tzdata

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -\
  && apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get upgrade -qq \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*\
  && npm install -g yarn@ \
  && ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

ENV TZ="America/Sao_Paulo"

RUN mkdir /usr/src/task-manager
WORKDIR /usr/src/task-manager
COPY Gemfile /task-manager/Gemfile
COPY Gemfile.lock /task-manager/Gemfile.lock
ADD . /usr/src/task-manager
RUN gem install bundler
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000