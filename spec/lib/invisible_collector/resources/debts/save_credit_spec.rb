require 'spec_helper'

describe InvisibleCollector::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save_credit' do

    { invalid: { code: 400, exception: InvisibleCollector::InvalidRequest, message: 'Invalid JSON' },
      unauthorized: { code: 401, exception: InvisibleCollector::Unauthorized,
                      message: 'Credentials are required to access this resource' },
      not_found: { code: 404, exception: InvisibleCollector::NotFound, message: 'Debt not found' },
      conflict: { code: 409, exception: InvisibleCollector::InvalidRequest, message: 'Debt already registered' },
      unprocessable: { code: 422, exception: InvisibleCollector::InvalidRequest,
                       message: 'Unprocessable request' } }.each do |key, attrs|

      it "fails on #{key} error" do
        fixture = api_fixture("debt/#{key}")
        gid = SecureRandom.uuid
        stub_do_api("/debts/#{gid}/credits", :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect { resource.save_credit(gid, params) }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'uses a debit object' do
      fixture = api_fixture('debt/save_credit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      credit = InvisibleCollector::Credit.new(attrs)
      stub_do_api("/debts/#{gid}/credits", :post).with(body: credit.to_json).to_return(body: fixture)
      credit = resource.save_credit(gid, credit)

      expect(credit).to be_kind_of(InvisibleCollector::Credit)

      expect(credit.number).to eq(parsed['number'])
      expect(credit.description).to eq(parsed['description'])
      expect(credit.date).to eq(parsed['date'])
      expect(credit.gross_total).to eq(parsed['grossTotal'])
    end

    it 'uses a credit object and a debt object' do
      fixture = api_fixture('debt/save_credit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', description: 'sdfsdafds', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      debt = InvisibleCollector::Debt.new(id: gid)
      credit = InvisibleCollector::Credit.new(attrs)
      stub_do_api("/debts/#{gid}/credits", :post).with(body: credit.to_json).to_return(body: fixture)
      credit = resource.save_credit(debt, credit)

      expect(credit).to be_kind_of(InvisibleCollector::Credit)

      expect(credit.number).to eq(parsed['number'])
      expect(credit.date).to eq(parsed['date'])
      expect(credit.gross_total).to eq(parsed['grossTotal'])
    end

    it 'uses a credit hash' do
      fixture = api_fixture('debt/save_credit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      stub_do_api("/debts/#{gid}/credits", :post).with(body: attrs.to_json).to_return(body: fixture)
      credit = resource.save_credit(gid, attrs.to_json)

      expect(credit).to be_kind_of(InvisibleCollector::Credit)

      expect(credit.number).to eq(parsed['number'])
      expect(credit.date).to eq(parsed['date'])
      expect(credit.gross_total).to eq(parsed['grossTotal'])
    end
  end
end
