FROM ruby:2.5.1-alpine

RUN apk add --update --no-cache \
  build-base \
  tzdata \
  libxml2-dev \
  libxslt-dev \
  bash \
  mysql-dev \
  nodejs

RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
RUN echo "America/Sao_Paulo" >  /etc/timezone

ENV RAILS_ROOT /partners-api
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

ARG bundle_options_var="--jobs 20 --retry 5"

COPY Gemfile Gemfile.lock $RAILS_ROOT/

RUN gem install bundler && bundle install $bundle_options_var

COPY . $RAILS_ROOT

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
