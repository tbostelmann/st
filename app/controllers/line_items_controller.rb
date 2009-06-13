class LineItemsController < BaseController
  before_filter :admin_required

  active_scaffold :line_item do |config|
    config.actions = [:list]
    config.label = "Line Items"
    config.columns = [:type, :invoice_id, :cents, :amount, :status, :from_user, :to_user]
    config.list.columns = [:type, :invoice_id, :amount, :status, :from_user, :to_user]
    list.sorting = {:to_user_id => 'ASC'}
  end
end
