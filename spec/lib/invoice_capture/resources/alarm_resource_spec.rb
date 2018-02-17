require 'spec_helper'

describe InvoiceCapture::AlarmResource do

  let(:client) { InvoiceCapture::API.new(api_token: 'bogus_token') }
  let(:connection) { client.connection }
  let(:resource) { described_class.new(connection: connection) }

  describe '#get' do

    it 'returns null if not found' do
      fixture = api_fixture('alarm/not_found')
      stub_do_api("/alarms/something").to_return(body: fixture, status: 404)
      alarm = resource.get('something')

      expect(alarm).to be_nil
    end

    it 'returns the alarm info using gid' do
      fixture = api_fixture('alarm/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/alarms/#{parsed['gid']}").to_return(body: fixture)
      alarm = resource.get(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

  describe '#get!' do

    it 'fails if not found' do
      fixture = api_fixture('alarm/not_found')
      stub_do_api("/alarms/something").to_return(body: fixture, status: 404)
      expect {
        resource.get!('something')
      }.to raise_exception(InvoiceCapture::NotFound).with_message('404: Alarm not found')
    end

    it 'returns the customer info using gid' do
      fixture = api_fixture('alarm/get')
      parsed  = JSON.load(fixture)

      stub_do_api("/alarms/#{parsed['gid']}").to_return(body: fixture)
      alarm = resource.get!(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq(parsed['status'])
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

  describe '#close' do

    it 'closes an alarm using gid' do
      fixture = api_fixture('alarm/close')
      parsed  = JSON.load(fixture)
      stub_do_api("/alarms/#{parsed['gid']}/close", :put).with(body: nil).to_return(body: fixture)
      alarm = resource.close(parsed['gid'])

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

    it 'closes an alarm using the actual alarm' do
      fixture = api_fixture('alarm/close')
      parsed  = JSON.load(fixture)
      alarm = InvoiceCapture::Alarm.new gid: parsed['gid']
      stub_do_api("/alarms/#{parsed['gid']}/close", :put).with(body: nil).to_return(body: fixture)
      alarm = resource.close(alarm)

      expect(alarm).to be_kind_of(InvoiceCapture::Alarm)

      expect(alarm.gid).to eq(parsed['gid'])
      expect(alarm.status).to eq('CLOSED')
      expect(alarm.createdAt).to eq(parsed['createdAt'])
      expect(alarm.updatedAt).to eq(parsed['updatedAt'])
    end

  end

end
