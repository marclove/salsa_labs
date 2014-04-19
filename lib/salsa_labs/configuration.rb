module SalsaLabs
  class Configuration
    attr_accessor :email, :password, :endpoint_uri

    # @return [Boolean]
    #   true if {#email} and {#password} are both not +nil+
    def valid?
      !email.nil? && !password.nil? && !endpoint_uri.nil?
    end
  end
end
