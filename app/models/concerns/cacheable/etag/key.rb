# frozen_string_literal: true

module Cacheable
  module Etag
    module Key
      def resource_key(user_id, resource_type, resource_id)
        key = key_root(user_id, resource_type) + "/#{resource_id}"
        Digest::SHA1.hexdigest(key)
      end

      def index_key(user_id, resource_type, page = nil)
        key = key_root(user_id, resource_type) + "/index"
        key += "/page-#{page}" if page.present?
        Digest::SHA1.hexdigest(key)
      end

      def key_root(user_id, resource_type)
        "etag/users/#{user_id}/#{resource_type}"
      end

      module_function :resource_key, :index_key, :key_root
    end
  end
end
