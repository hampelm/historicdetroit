module ImageHelper
  # See http://www.imagemagick.org/Usage/resize/ for syntax info
  # http://www.imagemagick.org/script/command-line-processing.php#geometry

  def photo?
    photo.attached?
  end

  def thumbnail
    photo.andand.variant(combine_options: {thumbnail: '100x100^', gravity: 'center', extent: '100x100', quality: 60 })
  end

  def polaroid(img = photo)
    img # photo.andand.variant(combine_options: {thumbnail: '218x200^', gravity: 'center', extent: '218x200'}) if photo.attachment
  end

  def full(img = photo)
    img # img.andand.variant(combine_options: {gravity: 'center', size: '1200x>'}) if img
  end

  def mobile(img = photo)
    img.andand.variant(combine_options: {gravity: 'center', size: '600x>'}) if img
  end

  def sidebar_photo
    photo.andand.variant(combine_options: {thumbnail: 'x300^', gravity: 'center', extent: '300'}) if photo.attachment
  end
end
