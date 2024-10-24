# frozen_string_literal: true

module Cacheable
  module Etag
    extend ActiveSupport::Concern

    included do
      after_save :etag! # We can only have one after commit per model otherwise we have issues, this makes more sense as an after save
      after_touch :etag!

      next unless ActiveRecord::Base.connected? && table_exists? && new.has_attribute?(:user_id) == false

      raise "#{name} is not Etaggable because it requires a user_id attribute"
    end

    def invalidate_etag!
      resource_type = self.class.etag_resource_type
      key_to_delete = Cacheable::Etag::Key.resource_key(user_id, resource_type, id)
      Cacheable::Etag::Storage.delete(key_to_delete)
    end

    # Change the etag
    def etag!
      self.class.resource_etag!(user_id, id)
    end

    module ClassMethods
      def etag_resource_type
        name.underscore
      end

      # Individual Resource Etag Caching ===============================
      def resource_etag(user_id, resource_id, original_fullpath)
        raise "original_fullpath must be a string path" unless original_fullpath.is_a?(String) && original_fullpath[0] == "/"

        resource_type = etag_resource_type
        key = Cacheable::Etag::Key.resource_key(user_id, resource_type, resource_id)
        value = Cacheable::Etag::Storage.fetch(key) { resource_etag!(user_id, resource_id) }
        version = etag_version
        "#{Base64.strict_encode64 original_fullpath}:#{key}:#{value}:#{version}"
      end

      def resource_etag!(user_id, resource_id)
        resource_type = etag_resource_type
        key = Cacheable::Etag::Key.resource_key(user_id, resource_type, resource_id)
        value = SecureRandom.base64(16)
        Cacheable::Etag::Storage.write(key, value)
        # JoistLogging.info "Cacheable::Etag:: set etag  #{key} => #{value} = #{resource_etag(user_id, resource_id)}"

        invalidate_etag!(user_id)

        value
      end

      # Index Etag Caching ===============================
      # Fetch the current etag
      def etag(user_id, original_fullpath)
        raise "original_fullpath must be a string path" unless original_fullpath.is_a?(String) && original_fullpath[0] == "/"

        resource_type = etag_resource_type
        key = Cacheable::Etag::Key.index_key(user_id, resource_type)
        value = Cacheable::Etag::Storage.fetch(key) { SecureRandom.base64(16) }
        version = etag_version
        # JoistLogging.debug "Cacheable::Etag:: user_id: #{user_id}, etag for #{self.name}: original_fullpath:#{original_fullpath} version:#{version} #{key} => #{value}"
        "#{Base64.strict_encode64 original_fullpath}:#{key}:#{value}:#{version}"
      end

      # Invalidate the index etag
      def invalidate_etag!(user_id)
        resource_type = etag_resource_type
        # delete the generic key (assumes no pages)
        key_to_delete = Cacheable::Etag::Key.index_key(user_id, resource_type)
        # JoistLogging.info "Cacheable::Etag:: #{self.name} invalidate_etag! delete key #{key_to_delete}"
        Cacheable::Etag::Storage.delete(key_to_delete)

        # iterate through page numbers until no more exist
        page = 0
        key_to_delete = Cacheable::Etag::Key.index_key(user_id, resource_type, page)
        while Cacheable::Etag::Storage.delete(key_to_delete)
          # JoistLogging.info "Cacheable::Etag:: #{self.name} invalidate_etag! delete key #{key_to_delete}"
          page += 1
          key_to_delete = Cacheable::Etag::Key.index_key(user_id, resource_type, page)
        end
      end

      def etag_version
        HttpCacheable::Versioning.instance.current_etag_version
      end
    end
  end
end
