require "sf_leads/version"
require "restforce"

class SfLeads
  VALID_EMAIL_ADDRESS_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  @lead

  def initialize(lead)
    @lead = lead
    self
  end

  def get
    @lead
  end

  def valid?
    return false unless @lead.last_name
    return false unless @lead.company
    return false unless valid_email
    true
  end

  def has_all_attr_valid?
    return false unless valid?
    return false unless @lead.name
    return false unless @lead.job_title
    return false unless @lead.phone
    return false unless @lead.website
    true
  end

  def send_to_sales_force(access_token, instace_url)
    return false unless valid?
    create_lead(access_token, instace_url)
  end

  def self.link_to_login
    "https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=" +
      ENV['SALES_FORCE_TOKEN'] + "&redirect_uri=" + ENV['SALES_FORCE_REDIRECT_URI']
  end

  private
    def valid_email
      if @lead.email
        @lead.email.match VALID_EMAIL_ADDRESS_REGEX
      else
        true
      end
    end

    def create_lead(access_token, instace_url)
      client = get_sales_force_client(access_token, instace_url)
      # account = client.create('Account', name: @lead.name)
      client.create('Lead', FirstName: @lead.name, LastName: @lead.last_name, Company: @lead.company)
    end

    def get_sales_force_client(access_token, instace_url)
      Restforce.new :oauth_token => access_token,
        :instance_url  => instace_url
    end
end
