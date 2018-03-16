require 'spec_helper'

describe InvisibleCollector::Customer do

  it 'converts to json' do
    attrs = { name: 'some name', vatNumber: nil, address: 'some address' }
    customer = InvisibleCollector::Customer.new(attrs)
    expect(customer.to_json).to include('some name')
  end

  describe 'creation' do

    it 'supports symbol attributes' do
      customer = InvisibleCollector::Customer.new(name: 'some name', address: 'some address')
      expect(customer.name).to eq('some name')
      expect(customer.address).to eq('some address')
    end

    it 'supports string attributes' do
      customer = InvisibleCollector::Customer.new('name' => 'some name', 'address' => 'some address')
      expect(customer.name).to eq('some name')
      expect(customer.address).to eq('some address')
    end

  end
end
