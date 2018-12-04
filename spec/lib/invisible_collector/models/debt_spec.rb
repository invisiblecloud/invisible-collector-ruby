require 'spec_helper'

describe InvisibleCollector::Model::Debt do

  it 'converts to json' do
    attrs = {
      number: 'some number',
      external_id: 'some external id',
      type: 'SD',
      status: 'PENDING',
      date: '2018-01-01',
      due_date: '2018-02-01',
      customer: 'some customer',
      net_total: 34.5,
      tax: 10.0,
      gross_total: 44.5,
      currency: 'EUR'
    }
    json = InvisibleCollector::Model::Debt.new(attrs).to_json
    expect(json).to include('"number":"some number"')
    expect(json).to include('"externalId":"some external id"')
    expect(json).to include('"type":"SD"')
    expect(json).to include('"status":"PENDING"')
    expect(json).to include('"date":"2018-01-01"')
    expect(json).to include('"dueDate":"2018-02-01"')
    expect(json).to include('"netTotal":34.5')
    expect(json).to include('"grossTotal":44.5')
  end

  describe 'creation' do

    it 'supports symbol attributes' do
      debt = InvisibleCollector::Model::Debt.new(number: 'some number', external_id: 'someId')
      expect(debt.number).to eq('some number')
      expect(debt.external_id).to eq('someId')
    end

    it 'supports string attributes' do
      debt = InvisibleCollector::Model::Debt.new(number: 'some number', external_id: 'someId')
      expect(debt.number).to eq('some number')
      expect(debt.external_id).to eq('someId')
    end
  end
end
