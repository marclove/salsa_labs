require 'active_support'
require 'active_support/core_ext'
require 'active_support/deprecation'

module SalsaLabs
  module SalsaObject
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # @param [String] key of the object being requested
      # @return [Hash] a hash representing the requested object
      def get(key)
        SalsaLabs.request('api/getObject.sjs', {object: object_name, key: key}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end

      # @return [Integer] the number of total objects
      def count
        SalsaLabs.request('api/getCounts.sjs', {object: object_name}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'count').
               try(:[], 'count').
               try(:to_i)
        end
      end

      # @return [Array<Hash>] an array of all the objects
      def all(attributes)
        attributes.merge!({ object: object_name })
        SalsaLabs.request('api/getObjects.sjs', attributes) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end

      def where(attributes)
        limit = attributes.delete(:limit)
        order_by = attributes.delete(:orderBy)
        params = { object: object_name, condition: conditions_for(attributes) }
        params.merge!(orderBy: limit) if limit
        params.merge!(orderBy: order_by) if order_by

        SalsaLabs.request('api/getObjects.sjs', params) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end

      # @return [String] the created or modified object's key
      # @raise [APIResponseError]
      #   if the request to save the object failed
      def save(attributes)
        attributes.merge!({ object: object_name })
        SalsaLabs.request('save', attributes) do |response|
          SalsaLabs::SaveResponse.new(response).key
        end
      end

      def delete(key)
        SalsaLabs.request('delete', {object: object_name, key: key}) do |response|
          true # we only get here if the response was deemed valid
        end
      end

      private

      # @return [String] the name of this class in lowercase and underscored format
      # @example
      #   class MySpecialClass
      #     include SalsaObject
      #   end
      #
      #   MySpecialClass.object_name #=> 'my_special_class'
      def object_name
        self.to_s.split('::').last.gsub(/(?:([A-Za-z])|^)(?=[^a-z])/) { "#{$1}#{$1 && '_'}" }.downcase
      end

      def conditions_for(attributes)
        conditions = []
        attributes.each_pair do |key, value|
          conditions << "#{key}=#{value}"
        end
        conditions.join('&')
      end
    end
  end
end
