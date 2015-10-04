[![Build Status](https://travis-ci.org/wwwbruno/ruby-gem-sales-force-leads.svg?branch=master)](https://travis-ci.org/wwwbruno/ruby-gem-sales-force-leads)

# SfLeads

This Gem will help you to authenticate in Sales Force API and create leads. There are 3 main methods to generate login link, get access token and create the lead.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sf_leads', :github => 'wwwbruno/ruby-gem-sales-force-leads'
```

And then execute:

    $ bundle

Set token, client id and redirect URI to Env variables configured in your Sales Force Connect App:

```shell
export SALES_FORCE_TOKEN='8h8FJ29Kq3Hdd7HD79hd9DmfqPlZjUxWVbjMJFD4mR2RDejz.if9D8HD9nt920tmOB2.LQ2qrV2qrellkdif.9HJ'
export SALES_FORCE_CLIENT_ID='1968375613319381757'
export SALES_FORCE_REDIRECT_URI='https://localhost:3000/auth/salesforce/callback'
```

## Usage

To gerenate the login link, call this method (it will return a string with the full url):

```ruby
SfLeads::link_to_login
```

The login link will redirect the user the the redirect url with a code parameter that you will use to get the access token and instance url with the following method:

```ruby
result = SfLeads::get_access_token(params[:code])
if result['access_token'] && result['instance_url']
  # save the access token and the instance url
else
  # the error message should be in result['error']
end
```

With the access token and instance url in hands, you can create the lead:

```ruby
# create your User class
usr = User.new
usr.name = 'Bruno'
usr.email = 'bruno@disvolvi.com'
usr.last_name = 'Almeida'
usr.company = 'Disvolvi'
usr.job_title = 'Full-stack Developer'
usr.phone = '+55 48 8888-8888'
usr.website = 'http://disvolvi.com/'

# initialize the SFLeads class
lead = SfLeads.new(usr)

# check if the lead is valid
lead.valid?
# => true

# create the lead
lead.send_to_sales_force(access_token, instance_url)
# => true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wwwbruno/sf_leads. This project is intended to be a safe, welcoming space for collaboration.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
