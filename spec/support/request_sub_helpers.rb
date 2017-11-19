module RequestStubHelpers

  def stub_do_api(path, verb = :any)
    stub_request(verb, %r[#{InvoiceCapture::API::INVOICECAPTURE_API}#{Regexp.escape(path)}])
  end

  def api_fixture(fixture_name)
    Pathname.new('./spec/fixtures/').join("#{fixture_name}.json").read
  end
end
