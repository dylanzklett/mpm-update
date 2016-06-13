class User < ActiveRecord::Base
  has_one :profile, as: :person, dependent: :destroy
  accepts_nested_attributes_for :profile

  delegate :first_name, :last_name, :first_title, :second_title, :first_address, :address_for_email,
           :second_address, :country, :city, :state, :zip, :phone_o, :phone_c, :name_for_select,
           :full_name,
           to: :profile, prefix: false

  has_many :customers
  has_many :projects, foreign_key: :sales_id

  after_initialize do |user|
    user.build_profile unless user.profile
  end

  def self.find_version_author(version)
    where(id: version.whodunnit).first
  end

  def self.search_by(term)
    query_term = "%#{term}%"
    user = self.arel_table
    profile = Profile.arel_table
    scoped_users = self.joins(:profile).where(
      user[:email].matches(query_term)\
      .or(user[:rep_number].matches(query_term))
      .or(profile[:first_name].matches(query_term))\
      .or(profile[:last_name].matches(query_term))\
      .or(profile[:first_title].matches(query_term))\
      .or(profile[:second_title].matches(query_term))\
      .or(profile[:first_address].matches(query_term))\
      .or(profile[:second_address].matches(query_term))\
      .or(profile[:country].matches(query_term))\
      .or(profile[:city].matches(query_term))\
      .or(profile[:state].matches(query_term))\
      .or(profile[:zip].matches(query_term))\
      .or(profile[:phone_o].matches(query_term))\
      .or(profile[:phone_c].matches(query_term))\
    )
  end
end
