# frozen_string_literal: true

# Primary model for application users. Devise is used for authentication
#
# Schema Information
#
# Table name: users
#
# id                     :bigint           not null, primary key
# email                  :string           default(""), not null
# encrypted_password     :string           default(""), not null
# reset_password_token   :string
# reset_password_sent_at :datetime
# remember_created_at    :datetime
# created_at             :datetime         not null
# updated_at             :datetime         not null
#
# Indexes
#
# index_users_on_email                 (email) UNIQUE
# index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
