# Capistrano Pusher [![Build Status](https://travis-ci.org/onthebeach/capistrano-pusher.svg)](https://travis-ci.org/onthebeach/capistrano-pusher) [![Code Climate](https://codeclimate.com/github/onthebeach/capistrano-pusher/badges/gpa.svg)](https://codeclimate.com/github/onthebeach/capistrano-pusher) [![Gem Version](https://badge.fury.io/rb/capistrano-pusher.svg)](http://badge.fury.io/rb/capistrano-pusher)

Publish deploy notifications to [Pusher](https://pusher.com) - for [Capistrano v3](https://github.com/capistrano/capistrano).

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-pusher'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-pusher

## Usage

Require the gem in your `Capfile`:

    require 'capistrano/pusher'

And then set the required variables in `config/deploy.rb`:

    set :pusher_url,  'http://abc:123@api.pusherapp.com/apps/0'

The task will run automatically on deploy. Alternatively, you can notify of a deploy started manually by using:

    bundle exec cap production pusher:notify_started

Or to notify of a finished deploy:

    bundle exec cap production pusher:notify_finished

By default, this will publish a `started` event to the `Capistrano` channel with the following payload

    {
      message: 'production deploy starting with revision/branch 64a3c1de for my_app',
      user: 'seenmyfate',
      application: 'my_app',
      revision: '64a3c1de',
      branch: 'master',
      stage: 'production',
      state: 'started'
    }
   
When a deploy has finished, a `finished` event will be published:

    {
      message: 'Revision 64a3c1de of my_app deployed to production by seenmyfate in 333 seconds.',
      user: 'seenmyfate',
      application: 'my_app',
      revision: '64a3c1de',
      branch: 'master',
      stage: 'production',
      state: 'finished'
    } 

If a deploy has failed, a `failed` event will be published::

    {
      message: 'production deploy of my_app with revision/branch 64a3c1de failed',
      user: 'seenmyfate',
      application: 'my_app',
      revision: '64a3c1de',
      branch: 'master',
      stage: 'production',
      state: 'failed'
    }

As with the other tasks, it is also possible to notify failures manually:

    bundle exec cap production pusher:notify_failed

###  Customisation

Any of the defaults can be over-ridden in `config/deploy.rb`:

    set :pusher_channel, 'capistrano'
    set :pusher_user, ENV['GIT_AUTHOR_NAME']
    set :pusher_payload, -> {
      {
        message: fetch(:pusher_message),
        user: fetch(:pusher_user),
        application: fetch(:application),
        revision: fetch(:current_revision),
        branch: fetch(:branch),
        stage: fetch(:stage),
        state: fetch(:pusher_state)
      }
    }
    set :pusher_deploy_completed_text, -> {
      elapsed = Integer(fetch(:time_finished) - fetch(:time_started))
      "Revision #{fetch(:current_revision, fetch(:branch))} of " \
      "#{fetch(:application)} deployed to #{fetch(:stage)} by #{fetch(:pusher_user)} " \
      "in #{elapsed} seconds."
    }
    set :pusher_deploy_started_text, -> {
      "#{fetch(:stage)} deploy started with revision/branch #{fetch(:current_revision, fetch(:branch))} for #{fetch(:application)}"
    }
    set :pusher_deploy_failed_text, -> {
      "#{fetch(:stage)} deploy of #{fetch(:application)} with revision/branch #{fetch(:current_revision, fetch(:branch))} failed"
    }

### Copyright

Copyright (c) 2014 OnTheBeach Ltd. See LICENSE.txt for
further details.
