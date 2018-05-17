require "spec_helper"

describe InvisibleCollector::API do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }

  describe '#initialize' do

    it 'initializes with an api token' do
      expect(client.api_token).to eq('bogus_token')
    end

  end

  describe '#resources' do

    {
      company: InvisibleCollector::CompanyResource,
      customer: InvisibleCollector::CustomerResource,
      debt: InvisibleCollector::DebtResource,
      group: InvisibleCollector::GroupResource,
      alarm: InvisibleCollector::AlarmResource
    }.each do |key, value|

      it "supports #{key} requests" do
        expect(client.send key).to be_a(value)
      end

    end

  end

  it "has a version number" do
    expect(InvisibleCollector::VERSION).not_to be nil
  end
end
