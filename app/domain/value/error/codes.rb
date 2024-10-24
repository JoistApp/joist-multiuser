# frozen_string_literal: true

module Value
  module Error
    class Codes
      # common codes shared by all services
      RECORD_NOT_FOUND = 1001
      RECORD_INVALID = 1002
      RECORD_NOT_DESTROYED = 1003
      STATEMENT_INVALID = 1004
      PARAMETER_MISSING = 1005
      JOIST_RESTRICTED_ACTION_ERROR = 1006
      JOIST_AUTHORIZATION_ERROR = 1007
      RECORD_NOT_UNIQUE = 1008
      UNKNOWN = 9999

      # these codes are service specific
      JOIST_RECORD_NOT_FOUND = 9001
      JOIST_RECORD_NOT_UNIQUE = 9003
    end
  end
end
