FROM ruby:2.5

WORKDIR /app

ADD Gemfile Gemfile.lock ./
RUN bundle install

ADD . .

EXPOSE 3000

ENTRYPOINT [ "rails", "db:migrate" ]
CMD ["rails", "server"]
