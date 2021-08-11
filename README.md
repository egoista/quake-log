# Quake Log

## CLI program to solve the [challenge](CHALLENGE.MD)

Table of contents
=================

* [Installation](#installation)
* [Usage](#usage)
* [Tests](#tests)

# Installation
Make sure you have [Ruby](http://www.ruby-lang.org/en/downloads/) 3.0.1 installed.

You can check your Ruby version by running `ruby -v`:

    $ ruby -v
    ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-darwin20]


Then install [bundler](https://bundler.io/):

    $ gem install bundler

Then install project dependencies
    
    $ bundle install

# Usage

To access the system run:

    $ bin/quake_log

The program will load the log and give 3 reporting options, choose one with keyboard:

    Hi, this program parse the quake log and give you 3 reports
    Choose an option
    ‣ Player's kill report
    Player's ranking report
    Weapon's kill report
    Exit

To exit, choose Exit option

# Tests

Run specs with [Rspec](https://rspec.info/)

    $ rspec