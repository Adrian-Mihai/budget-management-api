module Users
  class Create < Base
    attr_reader :user

    def initialize(parameters:)
      @parameters = parameters
      @errors = []
    end

    def call
      @user = User.new(@parameters)
      check(@user)
      return self unless valid?

      @user.save
      self
    end
  end
end
