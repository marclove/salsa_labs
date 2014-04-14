require 'active_support/core_ext'

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
      def all
        SalsaLabs.request('api/getObjects.sjs', {object: object_name}) do |response|
          Hash.from_xml(response).
               try(:[], object_name).
               try(:[], 'item')
        end
      end

      # @return [String] the newly created object's key
      # @raise [APIResponseError]
      #   if the request to create the object failed
      def create(attributes)
        attributes.merge!({ object: object_name, key: '0' })
        SalsaLabs.request('save', attributes) do |response|
          SalsaLabs::SaveResponse.new(response).key
        end
      end

      # @return [Boolean] true if request was successful
      # @raise [APIResponseError]
      #   if the request to update the object failed
      def update(key, attributes)
        attributes.merge!({ object: object_name, key: key.to_s })
        SalsaLabs.request('save', attributes) do |response|
          SalsaLabs::SaveResponse.new(response).successful?
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
    end
  end
end