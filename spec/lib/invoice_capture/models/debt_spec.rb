require 'spec_helper'

describe InvoiceCapture::Debt do

  it 'converts to json' do
    attrs = { number: 'some number', externalId: 'someId' }
    debt = InvoiceCapture::Debt.new(attrs)
    expect(debt.to_json).to include('some number')
  end

  describe 'creation' do

    it 'supports symbol attributes' do
      debt = InvoiceCapture::Debt.new(number: 'some number', externalId: 'someId')
      expect(debt.number).to eq('some number')
      expect(debt.external_id).to eq('someId')
    end

    it 'supports string attributes' do
      debt = InvoiceCapture::Debt.new(number: 'some number', externalId: 'someId')
      expect(debt.number).to eq('some number')
      expect(debt.external_id).to eq('someId')
    end

  end
end
