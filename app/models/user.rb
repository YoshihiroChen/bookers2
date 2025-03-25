class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

  has_many :books, dependent: :destroy

  # 重写：用 name 替代 email 作为认证字段
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    name = conditions.delete(:name)
    where(conditions).where(["lower(name) = :value", { value: name.strip.downcase }]).first
  end
end
