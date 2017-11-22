require 'invoicecapture/version'

module InvoiceCapture

  autoload :API, 'invoicecapture/api'

  autoload :NotFound, 'invoicecapture/not_found'

  autoload :Company, 'invoicecapture/models/company'
  autoload :Customer, 'invoicecapture/models/customer'

  autoload :CompanyResource, 'invoicecapture/resources/company_resource'
  autoload :CustomerResource, 'invoicecapture/resources/customer_resource'
end
