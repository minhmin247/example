class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_desc, ->{order created_at: :desc}

  feed = lambda do |id|
    where "user_id IN (SELECT followed_id FROM relationships
      WHERE follower_id = #{id}) OR user_id = #{id}"
  end
  scope :feeds, feed

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length:
    { maximum: Settings.content_length }
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.upload_size.megabytes
      errors.add :picture, t("error.text5")
    end
  end
end
