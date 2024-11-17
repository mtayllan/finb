class FormErrorsExplanation < ViewComponent::Base
  def initialize(errors)
    @errors = errors
  end
end
