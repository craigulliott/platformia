class NotNilValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, (options[:message] || "can not be null"))
    end
  end
end
