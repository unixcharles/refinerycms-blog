# RefineryCMS Blog

__A blog plugin for the [Refinery](http://github.com/resolve/refinerycms) content management system.__

## Description:

Blog post with

* Title, Body & Excerpt
* Filter by Categories tag
* Filter by Tags
* Filter by Authors tag
* RSS feed

Blog comments with

* Title, name, email, body
* Email confirmation by comment author
* Optional Captcha
* Optional manual moderation
* Optional email notification

Administration panel

* write blogs
* manage comments (unmoderated/approved/refused)
* Change settings

## Dependencies

RefineryCMS blog's gem requirements are:

* [acts-as-taggable-on](http://github.com/mbleigh/acts-as-taggable-on)
* [fattr](http://github.com/ahoward/fattr)

Instructions for installing these gems follows below.

### Tags

You need to install [http://github.com/mbleigh/acts-as-taggable-on](http://github.com/mbleigh/acts-as-taggable-on)

> gem install acts-as-taggable-on

add the line:

> gem "acts-as-taggable-on"

to your Gemfile

> bundle install

If you are already using acts-as-taggable-on in your app, you may want to remove the migration file for "tags/taggings" tables.

### Captcha

The Captcha use Raptcha, a really cool "one file lib" that just work from ahoward @ [http://github.com/ahoward/raptcha](http://github.com/ahoward/raptcha)
If you want to use Captcha, you need [rMagick](http://rubygems.org/gems/rmagick) (which is already a dependency of RefineryCMS) and [fattr](http://github.com/ahoward/fattr):

> gem install fattr

add the line:

> gem "fattr"

to your Gemfile

> bundle install

_The lib is located at /lib/raptcha.rb, you can update it or edit to fit your need._

## Installation (as a plugin)

First, make sure you've run the migration on RefineryCMS (db:setup / db:migrate).

Deal with the dependencies (see dependencies)

Clone the plugin:

> script/plugin install git://github.com/unixcharles/refinerycms-blog.git

Copy the migration with

> rake refinery:blog:install

& run the migration

> rake db:migrate

## Credit

This is somewhat news plugin from Philip Arndt + comments. see: [http://github.com/resolve/refinerycms-news](http://github.com/resolve/refinerycms-news)
