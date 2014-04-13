[![Code Climate](https://codeclimate.com/github/marclove/salsa_labs.png)](https://codeclimate.com/github/marclove/salsa_labs)
[![Build Status](https://travis-ci.org/marclove/salsa_labs.svg?branch=master)](https://travis-ci.org/marclove/salsa_labs)

# SalsaLabs
A Ruby Gem for consuming the [Salsa Labs API](http://wfc2.wiredforchange.com/o/8001/p/salsa/website/public2/commons/dev/docs/).

##Usage
**This gem is still in a very alpha state and should not be used in production environments. The gem has purposely not been built or deployed to RubyGems. It will not be published until it is in a somewhat usable state.**

Configure the gem with your Salsa Labs login credentials:

```ruby
SalsaLabs.configure do |c|
  c.email    = 'myemail@example.com'
  c.password = 'mypassword'
end
```

Make your requests:

```ruby
SalsaLabs::Supporter.get('12345')
  #=> { "supporter_KEY" => "12345", "First_Name" => "Jane", "Last_Name" => "Doe", ... }

SalsaLabs::Supporter.all
  #=> [{ "supporter_KEY" => "12345", "First_Name" => "Jane", "Last_Name" => "Doe", ... }, { "supporter_KEY" => "12346", "First_Name" => "John", "Last_Name" => "Doe", ... }]
```
