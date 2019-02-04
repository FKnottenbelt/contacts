def validate_contact_info(info)
  INPUT_FIELDS.each do |field|
    method = "validate_#{field}"
    send(method, info[field])
  end
end

def contact_info_valid?
  @error_stack.empty?
end

####  Field validation

def validate_name(name)
  @error_stack << 'First name must be valid name' if
    name.to_s.empty? || name.strip == ''
end

def validate_phone(phone)
  mask = '000 000-0000'
  @error_stack << 'Invalid phone number' if phone.gsub(/\d/, '0') != mask
end

def validate_email(email)
  @error_stack << 'Invalid email' if (email =~ URI::MailTo::EMAIL_REGEXP).nil?
end
