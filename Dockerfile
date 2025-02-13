FROM ruby:3.4.1

# Install dependencies including PostgreSQL client
RUN apt-get update -qq && \
    apt-get install -y nodejs npm postgresql-client libpq-dev && \
    npm install -g yarn

WORKDIR /myapp

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

# Add script to wait for PostgreSQL
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
