# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_column_value(record, column)
    if column == 'amount'
      return record.amount.format(:html)
    end
    super(record, column)
  end
end
