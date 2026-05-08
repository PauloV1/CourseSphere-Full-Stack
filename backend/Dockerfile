FROM ruby:4.0-slim

RUN apt-get update -qq && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]