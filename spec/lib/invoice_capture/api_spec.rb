require "spec_helper"

describe InvoiceCapture::API do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }

  describe '#initialize' do

    it 'initializes with an api token' do
      expect(client.api_token).to eq('bogus_token')
    end

  end

  describe '#resources' do

    {
      company: InvoiceCapture::CompanyResource,
      customer: InvoiceCapture::CustomerResource,
      debt: InvoiceCapture::DebtResource,
      alarm: InvoiceCapture::AlarmResource
    }.each do |key, value|

      it "supports #{key} requests" do
        expect(client.send key).to be_a(value)
      end

    end

  end

  it "has a version number" do
    expect(InvoiceCapture::VERSION).not_to be nil
  end

end
