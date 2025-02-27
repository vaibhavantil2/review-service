class Product < Reviewable
  include SwaggerDocs::Product
  include SwaggerDocs::Reviewable
  has_many :company_reviewable, as: :reviewable, dependent: :destroy
  has_many :companies, through: :company_reviewable, as: :reviewable

  validates_presence_of :name, :reviews_count
  validates :description, presence: true, allow_blank: true
end
