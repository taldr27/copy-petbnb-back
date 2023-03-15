class PetRoom < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
  has_one_attached :image
  validates :name, presence: true, length: { maximum: 50 }
  validates :type_of_pet, presence: true, length: { maximum: 50 }
  validates :max_size_accepted, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }

  def image_url
    if image.attached?
      Rails.application.routes.url_helpers.url_for(
        image.variant(resize_to_limit: [500, 500]),
        only_path: true,
        host: 'your-host-name-here.com'
      )
    end
  end
end
