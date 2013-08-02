module SalsaLabs
  class Configuration
    attr_accessor :email, :password

    def valid?
      !email.nil? && !password.nil?
    end
  end
end
