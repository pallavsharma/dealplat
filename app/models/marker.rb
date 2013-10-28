class Marker < Base::VersionModel

  belongs_to :user
  belongs_to :marker_category, :class_name => 'Marker::Category'

end
