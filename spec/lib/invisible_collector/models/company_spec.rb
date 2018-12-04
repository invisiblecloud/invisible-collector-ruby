require 'spec_helper'

describe InvisibleCollector::Model::Company do

  it 'converts to json' do
    attrs = { name: 'some name', vatNumber: nil, address: 'some address' }
    company = InvisibleCollector::Model::Company.new(attrs)
    expect(company.to_json).to include('some name')
  end

  describe 'creation' do

    it 'supports symbol attributes' do
      company = InvisibleCollector::Model::Company.new(name: 'some name', address: 'some address')
      expect(company.name).to eq('some name')
      expect(company.address).to eq('some address')
    end

    it 'supports string attributes' do
      company = InvisibleCollector::Model::Company.new('name' => 'some name', 'address' => 'some address')
      expect(company.name).to eq('some name')
      expect(company.address).to eq('some address')
    end
  end
end
