# frozen_string_literal: true

module Cacheable
  module DocumentBuster
    extend ActiveSupport::Concern

    included do
      cattr_accessor :cache_busting_attributes, :belongs_to_user, :has_many_users
      self.cache_busting_attributes = Set.new
      self.belongs_to_user = reflect_on_all_associations(:belongs_to).map(&:name).include?(:user)
      self.has_many_users = reflect_on_all_associations(:has_many).map(&:name).include?(:users)

      after_update :bust_document_cache
      def bust_document_cache
        change_set = Set.new(saved_changes.keys)
        return unless change_set.intersect?(self.class.cache_busting_attributes)

        users = Set.new
        users.add user if self.class.belongs_to_user
        users.merge self.users.to_a if self.class.has_many_users
        touch_all_users_documents(users) if users.any?
      end
    end

    def touch_all_users_documents(users)
      user_ids = users.map(&:id)

      document_klasses = [Estimate, Invoice]

      document_klasses.each do |klass|
        next unless klass.included_modules.include?(Cacheable::Etag)

        # for etags
        klass.where(user_id: user_ids).select("user_id,id").find_each(&:invalidate_etag!)
        user_ids.each { |user_id| klass.invalidate_etag!(user_id) }
      end
    end

    module ClassMethods
      def document_buster_attributes(attrs)
        cache_busting_attributes.merge attrs
      end
    end
  end
end
