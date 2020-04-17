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

RUN mkdir -p /app
WORKDIR /app

ARG bundle_options_var='--jobs 20 --retry 5'

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install $bundle_options_var

COPY . ./

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
