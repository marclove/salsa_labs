require 'active_support/core_ext'

module SalsaLabs
  module SalsaObject
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def object_name
        self.to_s.split('::').last.gsub(/(?:([A-Za-z])|^)(?=[^a-z])/) { "#{$1}#{$1 && '_'}" }.downcase
      end
      
      def get(key)
        SalsaLabs.request('getObject.sjs', {object: object_name, key: key}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end

      def count
        SalsaLabs.request('getCounts.sjs', {object: object_name}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'count').
               try(:[], 'count').
               try(:to_i)
        end
      end

      def all
        SalsaLabs.request('getObjects.sjs', {object: object_name}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end
    end
  end
end