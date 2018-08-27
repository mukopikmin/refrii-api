FROM ruby:2.5

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install

ADD . .

ENV RACK_ENV production
ENV RAILS_ENV production

EXPOSE 3000

CMD ["rails", "server"]
