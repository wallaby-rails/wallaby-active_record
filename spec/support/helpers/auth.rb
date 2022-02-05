module Auth
  def cancancan_context(ability)
    Struct.new(:current_ability).new(ability)
  end

  def cancancan_authorzier(ability, model_class)
    Wallaby::ModelAuthorizer.new cancancan_context(ability), model_class
  end
end

RSpec.configure do |config|
  config.include Auth
end
