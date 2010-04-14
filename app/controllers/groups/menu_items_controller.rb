class Groups::MenuItemsController < Groups::BaseController
  javascript 'effects', 'dragdrop', 'controls', 'autocomplete' # require for find page autocomplete
  helper 'groups'
  prepend_before_filter :fetch_data
  before_filter :login_required
  before_filter :load_menu_items
  stylesheet 'menu_items'

  verify :only => :update, :method => :put

  def index
    @second_nav = "administration"
    @third_nav = "settings"
  end

  # not used yet.
  #def show
  #end

  # we are not using this right now. there is a
  # new empty menu item displayed at the end of the
  # list.
  #def new
  #  @menu_item = MenuItem.new
  #  @menu_item.position = @group.menu_items.count
  #end

  #not used yet.
  #the list also displays edit forms.
  #def edit
  #end

  def create
    @menu_item=@group.add_menu_item(params[:menu_item])
  end

  # this can be called in two ways:
  # * saving an edited menu_item
  # * changing the order of menu_items via drag&drop.
  def update
    # single item changed:
    if @menu_item
      @menu_item.update_attributes(params[:menu_item])
    end
    # order changed:
    if params[:menu_items_list].any?
      @group.menu_items.update_order(params[:menu_items_list].map(&:to_i))
    end
  end

  def destroy
    @menu_item.destroy
  end

  protected

  # this also makes sure that @menu_item belongs to the group if an
  # id is given.
  def load_menu_items
    @menu_items = @group.menu_items
    if params[:menu_item_id]
      @menu_item = @menu_items.find(params[:menu_item_id])
    end
  end

  def fetch_data
    # must have a group
    @group = Group.find_by_name(params[:id])
  end

  def context
    group_settings_context
  end

  def authorized?
    may_edit_menu?
  end

end
