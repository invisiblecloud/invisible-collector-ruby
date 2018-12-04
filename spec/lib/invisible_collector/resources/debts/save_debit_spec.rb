require 'spec_helper'

describe InvisibleCollector::Resources::DebtResource do

  let(:client) { InvisibleCollector::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#save_debit' do

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
        stub_do_api("/debts/#{gid}/debits", :post).with(body: '{}').to_return(body: fixture, status: attrs[:code])
        params = {}
        expect { resource.save_debit(gid, params) }.to raise_exception(attrs[:exception]).with_message("#{attrs[:code]}: #{attrs[:message]}")
      end
    end

    it 'uses a debit object' do
      fixture = api_fixture('debt/save_debit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      debit = InvisibleCollector::Model::Debit.new(attrs)
      stub_do_api("/debts/#{gid}/debits", :post).with(body: debit.to_json).to_return(body: fixture)
      debit = resource.save_debit(gid, debit)

      expect(debit).to be_kind_of(InvisibleCollector::Model::Debit)

      expect(debit.number).to eq(parsed['number'])
      expect(debit.date).to eq(parsed['date'])
      expect(debit.gross_total).to eq(parsed['grossTotal'])
    end

    it 'uses a debit object and a debt object' do
      fixture = api_fixture('debt/save_debit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      debt = InvisibleCollector::Model::Debt.new(id: gid)
      debit = InvisibleCollector::Model::Debit.new(attrs)
      stub_do_api("/debts/#{gid}/debits", :post).with(body: debit.to_json).to_return(body: fixture)
      debit = resource.save_debit(debt, debit)

      expect(debit).to be_kind_of(InvisibleCollector::Model::Debit)

      expect(debit.number).to eq(parsed['number'])
      expect(debit.date).to eq(parsed['date'])
      expect(debit.gross_total).to eq(parsed['grossTotal'])
    end

    it 'uses a debit hash' do
      fixture = api_fixture('debt/save_debit')
      parsed  = JSON.load(fixture)

      attrs = { number: 'sdfsad', date: Date.today, gross_total: 50.0 }
      gid = SecureRandom.uuid
      stub_do_api("/debts/#{gid}/debits", :post).with(body: attrs.to_json).to_return(body: fixture)
      debit = resource.save_debit(gid, attrs.to_json)

      expect(debit).to be_kind_of(InvisibleCollector::Model::Debit)

      expect(debit.number).to eq(parsed['number'])
      expect(debit.date).to eq(parsed['date'])
      expect(debit.gross_total).to eq(parsed['grossTotal'])
    end
  end
end
