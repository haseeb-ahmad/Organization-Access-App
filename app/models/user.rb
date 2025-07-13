class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :memberships
  has_many :organizations, through: :memberships
  has_many :spaces, through: :organizations
  has_many :posts, foreign_key: :author_id
  has_many :space_memberships, dependent: :destroy
  has_many :joined_spaces, through: :space_memberships, source: :space

  accepts_nested_attributes_for :memberships, allow_destroy: true


  def self.ransackable_attributes(auth_object = nil)
    %w[id email custom_attributes created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[organizations memberships spaces posts]
  end

  def age
    return unless dob

    dob.present? ? ((Time.zone.now - dob.to_time) / 1.year.seconds).floor : nil
  end

  def member_of?(organization)
    memberships.exists?(organization: organization)
  end
  
  def role_in(organization)
    memberships.find_by(organization: organization)&.role
  end
  
  def admin_of?(organization)
    role_in(organization) == "admin"
  end

  def moderator_of?(organization)
    role_in(organization) == "moderator"
  end

  def admin_or_moderator?(organization)
    admin_of?(organization) || moderator_of?(organization)
  end
end
