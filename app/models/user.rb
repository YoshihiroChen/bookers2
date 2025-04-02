class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }


  has_many :books, dependent: :destroy

  has_one_attached :profile_image

  def email_required?
    false
  end
  
  def will_save_change_to_email?
    false
  end
  

  # 重写：用 name 替代 email 作为认证字段
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    name = conditions.delete(:name)
    where(conditions).where(["lower(name) = :value", { value: name.strip.downcase }]).first
  end
end
