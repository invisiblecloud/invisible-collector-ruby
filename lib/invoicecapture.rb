require 'invoicecapture/version'

module InvoiceCapture

  autoload :API, 'invoicecapture/api'

  autoload :Company, 'invoicecapture/models/company'

  autoload :CompanyResource, 'invoicecapture/resources/company_resource'
end
