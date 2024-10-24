# frozen_string_literal: true

class HttpCacheable
  class Versioning
    include Singleton

    def current_etag_version
      7
    end
  end

  class Request < Rack::Request
    def cachable?
      get? && etag.present?
    end

    def etag
      @etag ||= @env["HTTP_IF_NONE_MATCH"]&.gsub(/^"(.*)"$/, '\1')
    end

    def modified?(original_fullpath)
      base_64_original_fullpath, key, value, version = etag.to_s.split(":", 4)

      begin
        Base64.strict_decode64(base_64_original_fullpath) != original_fullpath ||
          key.blank? ||
          value.blank? ||
          HttpCacheable::Versioning.instance.current_etag_version != version ||
          Cacheable::Etag::Storage.read(key) != value
      rescue ArgumentError
        # This is raised if the decode is not valid
        true
      end
    end
  end
end
