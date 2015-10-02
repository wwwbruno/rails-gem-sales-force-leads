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

  private
    def valid_email
      return false unless @lead.email
      @lead.email.match VALID_EMAIL_ADDRESS_REGEX
    end
end
