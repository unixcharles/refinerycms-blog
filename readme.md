RefineryCMS-Blog
================

Description:
------------

Blog post with

* Title, Body & Excerpt
* Filter by Categories tag
* Filter by Tags
* Filter by Authors tag
* RSS feed

Blog comments with

* Title, name, email, body
* By default, Confirmable by Email
* Optional Captcha
* Optional Manual Moderation
* Optional Email Notification

Administration panel

* write blogs
* manage comments (unread/approved/refuse)
* Change settings

Dependencies
------------
Tags
----
You need to install http://github.com/mbleigh/acts-as-taggable-on

> gem install acts-as-taggable-on

add the line:

> gem "acts-as-taggable-on"

to your Gemfile

> bundle install

If you are already using acts-as-taggable-on in your app, you may want to remove the migration file for "tags/taggings" tables.

Captcha
-------

The Captcha use Raptcha, a really cool "one file lib" that just work from ahoward @ http://github.com/ahoward/raptcha
If you want to use Captcha, you need rMagick (which is already a dependency of RefineryCMS) and fattr:

> gem install fattr

add the line:

> gem "fattr"

to your Gemfile

> bundle install

_The lib is located at /lib/raptcha.rb, you can update it or edit to fit your need._

Installation (as a plugin)
--------------------------

First, make sure you've run the migration on RefineryCMS (db:setup / db:migrate).

Deal with the dependencies (see dependencies)

Clone the plugin:

> script/plugin install git://github.com/unixcharles/refinerycms-blog.git

Copy the migration with

> rake refinery:blog:install

& run the migration

> rake db:migrate

Credit
------
This is somewhat news plugin from Philip Arndt + comments. see: http://github.com/resolve/refinerycms-news
