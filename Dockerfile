FROM ruby:2.5

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server"]
