class Base::VersionModel < Base::UserGeneratedContentModel
  self.abstract_class = true

  class << self
    #TODO: implement PaperTrail if will need

    def versionable_models
      @versionable_models ||= descendants.select { |child| !child.abstract_class }
    end
    alias :models :versionable_models

  end

end