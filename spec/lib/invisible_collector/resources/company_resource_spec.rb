require 'spec_helper'

describe InvisibleCollector::Resources::CompanyResource do

  let(:client) {InvisibleCollector::API.new(api_token: 'bogus_token')}
  let(:connection) {client.connection}
  let(:resource) {described_class.new(connection: connection)}

  describe '#get' do

    it 'returns the company info' do
      fixture = api_fixture('company/get')
      parsed = JSON.load(fixture)

      stub_do_api('/companies').to_return(body: fixture)
      response = resource.get
      expect(response).to be_success

      company = response.content
      expect(company).to be_kind_of(InvisibleCollector::Model::Company)

      expect(company.name).to eq(parsed['name'])
      expect(company.vat_number).to eq(parsed['vatNumber'])
      expect(company.address).to eq(parsed['address'])
      expect(company.zip_code).to eq(parsed['zipCode'])
      expect(company.city).to eq(parsed['city'])
      expect(company.country).to eq(parsed['country'])
      expect(company.gid).to eq(parsed['gid'])
      expect(company.notifications_enabled).to eq(parsed['notificationsEnabled'])
    end

  end

  describe '#update' do

    it 'updates the company info' do
      fixture = api_fixture('company/update')
      parsed = JSON.load(fixture)

      company = InvisibleCollector::Model::Company.new
      as_json = {}
      stub_do_api('/companies', :put).with(body: as_json).to_return(body: fixture, status: 201)
      response = resource.update company
      expect(response).to be_success

      company = response.content
      expect(company).to be_kind_of(InvisibleCollector::Model::Company)

      expect(company.name).to eq(parsed['name'])
      expect(company.vat_number).to eq(parsed['vatNumber'])
      expect(company.address).to eq(parsed['address'])
      expect(company.zip_code).to eq(parsed['zipCode'])
      expect(company.city).to eq(parsed['city'])
      expect(company.country).to eq(parsed['country'])
      expect(company.gid).to eq(parsed['gid'])
      expect(company.notifications_enabled).to eq(parsed['notificationsEnabled'])
    end

  end

  describe '#enable_notifications' do

    it 'enables notifications' do
      fixture = api_fixture('company/enableNotifications')
      parsed = JSON.load(fixture)

      stub_do_api('/companies/enableNotifications', :put).to_return(body: fixture)
      response = resource.enable_notifications
      expect(response).to be_success

      company = response.content
      expect(company).to be_kind_of(InvisibleCollector::Model::Company)

      expect(company.name).to eq(parsed['name'])
      expect(company.vat_number).to eq(parsed['vatNumber'])
      expect(company.address).to eq(parsed['address'])
      expect(company.zip_code).to eq(parsed['zipCode'])
      expect(company.city).to eq(parsed['city'])
      expect(company.country).to eq(parsed['country'])
      expect(company.gid).to eq(parsed['gid'])
      expect(company.notifications_enabled).to eq(true)
    end

  end

  describe '#disable_notifications' do

    it 'disables notifications' do
      fixture = api_fixture('company/disableNotifications')
      parsed = JSON.load(fixture)

      stub_do_api('/companies/disableNotifications', :put).to_return(body: fixture)
      response = resource.disable_notifications
      expect(response).to be_success

      company = response.content
      expect(company).to be_kind_of(InvisibleCollector::Model::Company)

      expect(company.name).to eq(parsed['name'])
      expect(company.vat_number).to eq(parsed['vatNumber'])
      expect(company.address).to eq(parsed['address'])
      expect(company.zip_code).to eq(parsed['zipCode'])
      expect(company.city).to eq(parsed['city'])
      expect(company.country).to eq(parsed['country'])
      expect(company.gid).to eq(parsed['gid'])
      expect(company.notifications_enabled).to eq(false)
    end

  end

end
