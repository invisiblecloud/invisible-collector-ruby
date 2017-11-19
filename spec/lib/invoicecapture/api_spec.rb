require "spec_helper"

describe InvoiceCapture::API do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }

  describe '#initialize' do

    it 'initializes with an api token' do
      expect(client.api_token).to eq('bogus_token')  
    end

  end

  it "has a version number" do
    expect(InvoiceCapture::VERSION).not_to be nil
  end

end
