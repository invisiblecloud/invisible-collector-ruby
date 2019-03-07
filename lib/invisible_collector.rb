require 'invisible_collector/version'
require 'json'
require 'active_support/all'

# Invisible Collector load module
module InvisibleCollector
  autoload :API, 'invisible_collector/api'
  autoload :Voice, 'invisible_collector/voice'
  autoload :Response, 'invisible_collector/response'

  autoload :NotFound, 'invisible_collector/not_found'
  autoload :InvalidRequest, 'invisible_collector/invalid_request'
  autoload :Unauthorized, 'invisible_collector/unauthorized'

  module Model
    autoload :AbstractModel, 'invisible_collector/models/abstract_model'
    autoload :ModelAttributes, 'invisible_collector/models/model_attributes'
    autoload :Alarm, 'invisible_collector/models/alarm'
    autoload :AlarmEvent, 'invisible_collector/models/alarm_event'
    autoload :Company, 'invisible_collector/models/company'
    autoload :Customer, 'invisible_collector/models/customer'
    autoload :Group, 'invisible_collector/models/group'
    autoload :Debt, 'invisible_collector/models/debt'
    autoload :Debit, 'invisible_collector/models/debit'
    autoload :Credit, 'invisible_collector/models/credit'
    autoload :Payment, 'invisible_collector/models/payment'

    autoload :Sms, 'invisible_collector/models/sms'
  end

  autoload :DefaultHandlers, 'invisible_collector/resources/default_handlers'
  module Resources
    autoload :AlarmResource, 'invisible_collector/resources/alarm_resource'
    autoload :CompanyResource, 'invisible_collector/resources/company_resource'
    autoload :CustomerResource, 'invisible_collector/resources/customer_resource'
    autoload :GroupResource, 'invisible_collector/resources/group_resource'
    autoload :DebtResource, 'invisible_collector/resources/debt_resource'
    autoload :PaymentResource, 'invisible_collector/resources/payment_resource'

    autoload :SmsResource, 'invisible_collector/resources/sms_resource'
  end
end
