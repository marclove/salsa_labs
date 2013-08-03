module SalsaLabs
  class Configuration
    attr_accessor :email, :password

    # @return [Boolean]
    #   true if {#email} and {#password} are both not +nil+
    def valid?
      !email.nil? && !password.nil?
    end
  end
end
