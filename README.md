# Dotidot scraper api

This README documents the Dotidot api challenge.

## Functionality
```
- I can pass css selectors to scrape data sign up to the platform
- I can scrape meta information from the page
```

## App description
```
- This is Ruby 3.1.2 and a Rails 7.2.1 monolith app
- The requests are made with Httparty
- The html data is parsed with Nokogiri 
- The requests has test coverage built with Rspec
```

## Dependencies
```
- Rspec
- Httparty
- Nokogiri
```

## Running the app
Clone this repo:
```
$ git clone git@github.com:{USER_NAME}/scraper-api
```
Install all dependancies:
```
$ bundle install
```
Create the DB:
```
$ rails db:create db:migrate
```
Start the server:
```
$ rails server
```

## Running tests
```
$ bundle exec rspec
```
