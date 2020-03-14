class Base
  attr_reader :errors

  def valid?
    @errors.empty?
  end

  private

  def check(entity)
    @errors = entity.errors.as_json(full_messages: true).values.flatten unless entity.valid?
  end
end
