class Base::Model < ActiveRecord::Base
  self.abstract_class = true
  NAMES_LENGTH = 1...100

  #BASE_MODEL_CHILDREN_NAMES = %w(UserGeneratedContentModel SeedableModel VersionableModel)
  #def self.inherited(child_class)
  #  super
  #  unless BASE_MODEL_CHILDREN_NAMES.include?(child_class.name) || (child_class.ancestors.map(&:name) & BASE_MODEL_CHILDREN_NAMES).any?
  #    raise "#{child_class.name} mistakenly inherits from BaseAbstractModel - use one of BaseAbstractModel child classes as parent for #{child_class.name}\n"
  #  end
  #end

  class << self

    def cache_enabled?
      Rails.cache.stats.present?
    end

    def cached_all(params = {})
      self.cached_block_by_key(params[:key] || "#{self.name}.all") { all.to_a }
    end

    def cached_block_by_key(key)
      if cache_enabled?
        Rails.cache.fetch(key) do
          yield
        end
      else
        yield
      end
    end

    def random_record
      self.order("RAND()").first
    end

    def random_record_id
      self.random_record.try(:id)
    end

  end

end
