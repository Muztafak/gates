# Gates

[![Build
Status](https://travis-ci.org/phillbaker/gates.png?branch=master)](https://travis-ci.org/phillbaker/gates)

This is a form from https://github.com/phillbaker/gates: an implementation of the ideas expressed in this post about Stripe's public API versioning, [Move fast, don't break your API](http://amberonrails.com/move-fast-dont-break-your-api/). The goal is to separate layers of request and response compatibility from the API logic, with two important drivers:
 * let your customers migrate API versions at their convenience, minimize the pain of upgrades when they do upgrade.
 * make it feasible to fix backward incompatible API schema mistakes (they will happen).

Besides this in [Envia Ya](https://enviaya.com.mx) had the idea of why not to this even more dynamic, obviously we have breaking changes in API versions but most of the times we are just adding intern fuctionality, adding parameters to the response, changing names. And now with the popularity of GraphQL the use of just the Gates ideas becomes very outdated.

Why if we have files stating parameters and types, nested and unnested, and in every verssion substract and add the new parameters, even combine it with the GraphQL request and so on.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gates', :git => 'https://github.com/Muztafak/gates.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gates

## Usage

Check for whether a gate is enabled:

```ruby
version = request.api_version || user.api_version
version = Gates.for(version)
version.enabled?(:foo) # => true / false

Gates.available_versions # => [<Gates::ApiVersion ...>]
```

In CI make sure to lint the version manifest:

```ruby
rake gates:lint
```

This can be combined with A/B testing or feature flipping like:

```ruby
def foo
  return unless feature_enabled?(user, :foo) || ab_test?(:foo) || version.enabled?(:foo)

  "foo"
end
```

```yaml
----
versions:
  -
    id: 2016-01-30-1
    gates:
      -
        name: reallows_amount
        description: |
          Just kidding. Sending amount is supported for some folks.
  -
    id: 2016-01-30
    gates:
      -
        name: disallows_amount
        description: |
          Sending amount is now deprecated.
  -
    id: 2016-01-20
    gates:
      -
        name: allows_amount
        description: |
          Sending amount is supported.
```

In this version you can separate your files and perform :

```
Gates.load('some dir route')
```
```yaml
---
version:
  id: '2020-01-01'
  gates:
    - name: 'allow amount'
      description: 'The user can pay with bitcoin'
  actions:
    - name: 'paymentsIndex'
      request:
        allowed:
          type: String
          customer:
            name: Integer
      response:
        allowed:
          date: Date
          tax: Integer
        deprecated:
          - old_parameter

### Testing

Make sure to test both paths in order to not break compatibility!
