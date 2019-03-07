require 'spec_helper'

describe InvisibleCollector::Voice do

  let(:client) { InvisibleCollector::Voice.new(api_token: 'bogus_token') }

  describe '#initialize' do

    it 'initializes with an api token' do
      expect(client.api_token).to eq('bogus_token')
    end

  end

  describe '#resources' do

    {
      email: InvisibleCollector::Resources::EmailResource,
      sms: InvisibleCollector::Resources::SmsResource,
      vms: InvisibleCollector::Resources::VmsResource
    }.each do |key, value|

      it "supports #{key} requests" do
        expect(client.send key).to be_a(value)
      end

    end

  end

  it 'has a version number' do
    expect(InvisibleCollector::VERSION).not_to be nil
  end
end
