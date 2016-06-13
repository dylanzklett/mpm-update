class Profile < ActiveRecord::Base
  belongs_to :person, polymorphic: true

  def name_for_select
    [
     person.email,
     full_name,
     full_title,
     city_address,
     contry_address
    ].reject{|item| item.blank? }.join(' ')
  end

  def full_title
    [first_title, second_title].compact.join(' ')
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def city_address
    [first_address, second_address].compact.join(' ')
  end

  def contry_address
    [city, state, zip].compact.join(' ')
  end

  def address_for_email
    [full_name,
     first_title,
     second_title,
     first_address,
     second_address,
     contry_address,
     person.email,
     phone_o
    ].reject{|item| item.blank? }.join('<br />').html_safe
  end
end
