class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, touch: true

  mount_uploader :file, FileUploader
end
