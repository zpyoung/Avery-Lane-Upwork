module ListItemsController
  extend ActiveSupport::Concern
  
  included do
    layout "list_items"

    responders :ajax_modal, :collection

    respond_to :html, only: [:index, :destroy]
    respond_to :js, except: [:index, :destroy]

    helper_method :list_item, :list_items, :list_item_class

    load_and_authorize_resource
  end

  class_methods do
    def local_prefixes
      [controller_name, "list_items"]
    end
  end

  def index
    self.list_items = list_items.sorted.page(params[:page])
    respond_with(list_items)
  end

  def new
    respond_with(list_item)
  end

  def create
    list_item.save
    respond_with(list_item)
  end

  def edit
    respond_with(list_item)
  end

  def update
    list_item.update_attributes(resource_params)
    respond_with(list_item)
  end

  def destroy
    list_item.destroy
    respond_with(list_item)
  end

  protected

  def resource_params
    params.require(controller_name.singularize).permit(:name)
  end

  def list_item
    instance_variable_get("@#{controller_name.singularize}")
  end

  def list_items
    instance_variable_get("@#{controller_name}")
  end

  def list_items=(value)
    instance_variable_set("@#{controller_name}", value)
  end

  def list_item_class
    controller_name.singularize.classify.constantize
  end
end