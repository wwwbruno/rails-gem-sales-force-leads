require 'spec_helper'

def user
  Class.new do
    attr_accessor :name, :last_name, :email,
    :company, :job_title, :phone, :website
  end
end

describe SfLeads do

  before :each do
    ENV.stub(:[])
    ENV.stub(:[]).with("SALES_FORCE_TOKEN").and_return("BiGsAlEsFoRcEtOkEn")
    ENV.stub(:[]).with("SALES_FORCE_CLIENT_ID").and_return("123456789")
    ENV.stub(:[]).with("SALES_FORCE_REDIRECT_URI").and_return("https://localhost:3000/auth/salesforce/callback")
  end

  it 'has a version number' do
    expect(SfLeads::VERSION).not_to be nil
  end

  it 'set a lead' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.get).to equal(usr)
  end

  it 'check invalid lead without last name and company' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be false
  end

  it 'check invalid e-mail lead' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    usr.email = 'bruno@disvolvicom'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be false
  end

  it 'check valid lead' do
    # Arrange
    usr = user.new
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be true
  end

  it 'check valid lead but has no all attributes' do
    # Arrange
    usr = user.new
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be true
    expect(lead.has_all_attr_valid?).to be false
  end

  it 'check valid lead but with some attributes empty' do
    # Arrange
    usr = user.new
    usr.name = ''
    usr.email = ''
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    usr.job_title = ''
    usr.phone = ''
    usr.website = ''
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be true
    expect(lead.has_all_attr_valid?).to be false
  end

  it 'check valid lead with all attributes' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvi.com'
    usr.last_name = 'Almeida'
    usr.company = 'Disvolvi'
    usr.job_title = 'Full-stack Developer'
    usr.phone = '48 8888-8888'
    usr.website = 'http://disvolvi.com/'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be true
    expect(lead.has_all_attr_valid?).to be true
  end

  it 'get sales force url login' do
    # Arrange
    # Act
    url = SfLeads::link_to_login
    # Assert
    expect(url).to eq("https://login.salesforce.com/services/oauth2/authorize?response_type=code&client_id=BiGsAlEsFoRcEtOkEn&redirect_uri=https://localhost:3000/auth/salesforce/callback")
  end

  it 'try to create an invalid lead without last name in Sales Force' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    # Act
    lead = SfLeads.new(usr)
    result = lead.send_to_sales_force('aCcEsStOkEn',
      'http://instance.salesforce.com')
    # Assert
    expect(result).to be false
  end

  it 'create a valid lead in Sales Force' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvi.com'
    usr.company = 'Disvolvi'
    usr.last_name = 'Almeida'
    usr.job_title = 'Full-stack Developer'
    # Act
    lead = SfLeads.new(usr)
    lead.stub(:send_to_sales_force).and_return(true)
    result = lead.send_to_sales_force('aCcEsStOkEn',
      'http://instance.salesforce.com')
    # Assert
    expect(result).to be true
  end

  it 'get the access token from code' do
    # Arrange
    SfLeads.stub(:get_access_token).and_return({access_token:"aCcEsStOkEn"})
    # Act
    result = SfLeads::get_access_token('cOdEfRoMsAlEsFoRcE')
    # Assert
    expect(result).to eq({access_token:"aCcEsStOkEn"})
  end

  it 'get invalid access token from code' do
    # Arrange
    SfLeads.stub(:get_access_token).and_return({error:"invalid_grant", error_description:"expired authorization code"})
    # Act
    result = SfLeads::get_access_token('InVaLiDcOdEfRoMsAlEsFoRcE')
    # Assert
    expect(result).to eq({error:"invalid_grant", error_description:"expired authorization code"})
  end
end
