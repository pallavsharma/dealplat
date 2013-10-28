# non-seedable, non-versionable model
class Base::UserGeneratedContentModel < Base::Model
  self.abstract_class = true

  class << self

    def ugc_models
      @ugc_models ||= descendants.select { |child| !child.abstract_class }
    end
    alias :models :ugc_models

  end

end