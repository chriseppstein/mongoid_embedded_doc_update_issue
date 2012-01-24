# Reproducible test case for mongoid issue

This repo is the simplest case I could construct that demonstrates
how an embedded document updating against a root document that
uses inheritance can result in a `$push` operation instead of a `$set`.

To reproduce:

```
$ bundle install
$ bundle exec ruby reproduce.rb
```
