# might have special behavior in future; for the moment it's just convenient to track seedable models separately
class Base::SeedModel < Base::Model
  self.abstract_class = true

  class << self

    def seedable_models
      @seedable_models ||= descendants.select { |child| !child.abstract_class }
    end
    alias :models :seedable_models

    def seedable_tables
      @seedable_tables ||= seedable_models.map(&:table_name)
    end
    alias :tables :seedable_tables

  end

end