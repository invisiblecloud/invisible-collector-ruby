require 'spec_helper'

describe InvoiceCapture::Customer do

  describe 'creation' do

    it 'supports symbol attributes' do
      customer = InvoiceCapture::Customer.new(name: 'some name', address: 'some address')
      expect(customer.name).to eq('some name')
      expect(customer.address).to eq('some address')
    end

    it 'supports string attributes' do
      customer = InvoiceCapture::Customer.new('name' => 'some name', 'address' => 'some address')
      expect(customer.name).to eq('some name')
      expect(customer.address).to eq('some address')
    end

  end
end
