class LineItemsController < BaseController
  before_filter :admin_required

  active_scaffold :line_item do |config|
    config.actions = [:list]
    config.label = "Line Items"
    config.columns = [:type, :invoice_id, :cents, :amount, :status, :from_user, :to_user]
    config.list.columns = [:type, :invoice_id, :amount, :status, :from_user, :to_user]
    list.sorting = {:to_user_id => 'ASC'}
  end

  def conditions_for_collection
    conditions = {}
    if params[:to_user_id]
      conditions << [:to_user_id, params[:to_user_id]]
    end

    if params[:from_date]
      to_date = build_date_from_params(:from_date, params[:line_items])
    else
      from_date = Time.now.at_beginning_of_month
    end
    if params[:to_date]
      to_date = build_date_from_params(:to_date, params[:line_items])
    else
      to_date = Time.now.at_end_of_month
    end
    conditions[:updated_at] = from_date.to_date..to_date.to_date

    if params[:month]
      if params[:year]
        conditions[:updated_at] = DateTime.new(params[:year].to_i, params[:month].to_i, 1)..DateTime.new(params[:year].to_i, params[:month].to_i + 1, 1)
      else
        conditions[:updated_at] = DateTime.new(DateTime.now.year, params[:month].to_i, 1)..DateTime.new(DateTime.now.year, params[:month].to_i + 1, 1)
      end
    elsif params[:year]
      conditions[:updated_at] = DateTime.new(params[:year].to_i, 1, 1)..DateTime.new(params[:year].to_i + 1, 1, 1)
    end
    return conditions
  end
end
