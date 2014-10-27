class SaleItem < ActiveRecord::Base
  attr_accessible :description, :price, :reputation, :title, :url, :username, :images, :hires_thumbnail, :category, :source_site, :brand
  before_save :cleanup_price, :strip_fs_and_wtb

  serialize :images
  after_create :create_thumbnail

  def create_thumbnail
    image = MiniMagick::Image.open(images.first)

    logger.info "Creating thumbnail image #{thumbnail}"
    image.resize "240"
    image.format "jpg"
    image.write local_thumbnail_path

    logger.info "Uploading image to S3..."
    AWS::S3::S3Object.store(thumbnail, open(local_thumbnail_path), 'rewear.me', :access => :public_read)

    self.update_attribute(:hires_thumbnail, remote_thumbnail_path)
  rescue
    logger.warn "Could not create thumbnail for Sale Item #{self.id}"
    # Don't really care to sell items without images, so destroy it!
    self.destroy
  end

  def thumbnail
    "sale_item_#{self.id}_thumb.jpg"
  end

  def remote_thumbnail_path
    "http://rewear.me.s3.amazonaws.com/#{thumbnail}"
  end

  def local_thumbnail_path
    "#{Rails.root}/tmp/#{thumbnail}"
  end


  private

  # Remove For Sale
  def strip_fs_and_wtb
    title.gsub!(/^FS:?\s*/, '')
  end

  def cleanup_price
    write_attribute(:price, price.gsub('(','').gsub(')','')) if price
  end
end
