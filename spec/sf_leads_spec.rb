require 'spec_helper'

def user
  Class.new do
    attr_accessor :name, :last_name, :email,
    :company, :job_title, :phone, :website
  end
end

describe SfLeads do

  it 'has a version number' do
    expect(SfLeads::VERSION).not_to be nil
  end

  it 'set a lead' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvi.com'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.get).to equal(usr)
  end

  it 'check invalid lead without email' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be false
  end

  it 'check invalid lead without name' do
    # Arrange
    usr = user.new
    usr.email = 'bruno@disvolvi.com'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be false
  end

  it 'check invalid e-mail lead' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvicom'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be false
  end

  it 'check valid lead' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvi.com'
    # Act
    lead = SfLeads.new(usr)
    # Assert
    expect(lead.valid?).to be true
  end

  it 'check valid lead but has no all attributes' do
    # Arrange
    usr = user.new
    usr.name = 'Bruno'
    usr.email = 'bruno@disvolvi.com'
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
end
