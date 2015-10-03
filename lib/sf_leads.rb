require "sf_leads/version"

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
    return false unless @lead.name
    return false unless valid_email
    true
  end

  def has_all_attr_valid?
    return false unless valid?
    return false unless @lead.last_name
    return false unless @lead.company
    return false unless @lead.job_title
    return false unless @lead.phone
    return false unless @lead.website
    true
  end

  def self.link_to_login(redirect_uri)
    "https://login.salesforce.com/services/oauth2/authorize?response_type=token&client_id=" +
      ENV['SALES_FORCE_TOKEN'] + "&redirect_uri=" + redirect_uri
  end

  private
    def valid_email
      return false unless @lead.email
      @lead.email.match VALID_EMAIL_ADDRESS_REGEX
    end
end
