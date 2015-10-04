require "sf_leads/version"
require "restforce"
require 'net/http'

class SfLeads
  VALID_EMAIL_ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  attr_accessor :lead

  def initialize(lead)
    self.lead = lead
    self
  end

  def get
    self.lead
  end

  def valid?
    return true if !self.lead.last_name.to_s.empty? &&
    !self.lead.company.to_s.empty? && valid_email?
    false
  end

  def has_all_attr_valid?
    return true if self.valid? && !self.lead.name.to_s.empty? &&
    !self.lead.job_title.to_s.empty? && !self.lead.phone.to_s.empty? &&
    !self.lead.website.to_s.empty?
    false
  end

  def send_to_sales_force(access_token, instace_url)
    return false unless valid?
    create_lead(access_token, instace_url)
  end

  def self.link_to_login
    "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=" +
      ENV['SALES_FORCE_TOKEN'] + "&redirect_uri=" + ENV['SALES_FORCE_REDIRECT_URI']
  end

  def self.get_access_token(code)
    form_data = 'code=' << code
    form_data << '&grant_type=authorization_code'
    form_data << '&client_id=' << ENV['SALES_FORCE_TOKEN']
    form_data << '&client_secret=' << ENV['SALES_FORCE_CLIENT_ID']
    form_data << '&redirect_uri=' << ENV['SALES_FORCE_REDIRECT_URI']

    uri = URI.parse("https://login.salesforce.com/services/oauth2/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new("https://login.salesforce.com/services/oauth2/token")
    req.content_type = "application/x-www-form-urlencoded"
    req["Accept"] = '*/*'
    req.body = form_data
    response = http.request req

    JSON.parse(response.body)
  end

  private
    def valid_email?
      if !self.lead.email.to_s.empty?
        self.lead.email.match VALID_EMAIL_ADDRESS_REGEX
      else
        true
      end
    end

    def create_lead(access_token, instace_url)
      client = get_sales_force_client(access_token, instace_url)
      client.create('Lead', FirstName: self.lead.name, LastName: self.lead.last_name,
        Company: self.lead.company, Email: self.lead.email, Phone: self.lead.phone,
        Title: self.lead.job_title, Website: self.lead.website)
    end

    def get_sales_force_client(access_token, instace_url)
      Restforce.new :oauth_token => access_token,
        :instance_url  => instace_url
    end
end
