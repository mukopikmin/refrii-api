FROM ruby:2.6.5

RUN gem install bundler:2.1.4

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
