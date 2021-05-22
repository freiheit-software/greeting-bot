FROM ruby:2.6
WORKDIR /app

COPY Gemfile Gemfile.lock .
RUN gem install --no-document bundler \
    && bundle config --local frozen true \
    && bundle config --local without "development test" \
    && bundle install

COPY . .
ENV PORT=8080
ENTRYPOINT ["bundle", "exec", "functions-framework-ruby"]
