class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, -> {order(created_at: :desc)}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content.max_length}
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                  message: I18n.t("micropost.image.mess_image") },
                                  size: { less_than: Settings.micropost.size_image.size.megabytes,
                                    message: I18n.t("micropost.image.size_mess.size") }
  # def display_image
  #   image.variant resize_to_limit: [500, 500]
  # end
end
