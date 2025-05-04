module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by_scopes(scopes_value_hash)
      results = where(nil)
      scopes_value_hash.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end
  end
end
