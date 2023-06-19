class ContactNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ ::CONTACT_NUMBER_REGEXP
      record.errors.add attribute, (options[:message] || "is not valid.")
    end
  end
end
