require 'invoice_capture/version'
require 'json'
require 'active_support/all'

module InvoiceCapture

  autoload :API, 'invoice_capture/api'

  autoload :NotFound, 'invoice_capture/not_found'
  autoload :InvalidRequest, 'invoice_capture/invalid_request'

  autoload :ModelAttributes, 'invoice_capture/models/model_attributes'
  autoload :Company, 'invoice_capture/models/company'
  autoload :Customer, 'invoice_capture/models/customer'
  autoload :Debt, 'invoice_capture/models/debt'

  autoload :DefaultHandlers, 'invoice_capture/resources/default_handlers'
  autoload :CompanyResource, 'invoice_capture/resources/company_resource'
  autoload :CustomerResource, 'invoice_capture/resources/customer_resource'
  autoload :DebtResource, 'invoice_capture/resources/debt_resource'
end
