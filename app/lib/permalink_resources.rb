module PermalinkResources
  def self.included(klass)
    klass.class_eval do
      alias :_collection :collection
      include InstanceMethods
    end
  end
  
  module InstanceMethods  
    # Find by permalink instead of by id
    def resource
      get_resource_ivar || set_resource_ivar(end_of_association_chain.find_by_permalink!(params[:id]))
    end
    
    def collection
      get_collection_ivar || set_collection_ivar(_collection)
    end
  end
end