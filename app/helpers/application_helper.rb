# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_column_value(record, column)
    if column == 'amount'
      return record.amount.format(:html)
    end
    super(record, column)
  end

  def build_date_from_params(field_name, params)
    Date.new(params["#{field_name.to_s}(1i)"].to_i,
         params["#{field_name.to_s}(2i)"].to_i,
         params["#{field_name.to_s}(3i)"].to_i)
  end  
end
