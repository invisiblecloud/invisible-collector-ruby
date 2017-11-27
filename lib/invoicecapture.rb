require 'invoicecapture/version'
require 'active_support/all'

module InvoiceCapture

  autoload :API, 'invoicecapture/api'

  autoload :NotFound, 'invoicecapture/not_found'
  autoload :InvalidRequest, 'invoicecapture/invalid_request'

  autoload :Company, 'invoicecapture/models/company'
  autoload :Customer, 'invoicecapture/models/customer'

  autoload :CompanyResource, 'invoicecapture/resources/company_resource'
  autoload :CustomerResource, 'invoicecapture/resources/customer_resource'
end
