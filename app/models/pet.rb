class Pet < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 50 }
  validates :pet_type, presence: true
  validates :date_of_birth, presence: true
  validates :size, presence: true
  validates :allergies, presence: true

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
