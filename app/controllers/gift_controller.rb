class GiftController < BaseController
  include ApplicationHelper

  def create

  end

  def update
    if params[:gift].nil?
      raise ArgumentError, :argument_error_no_class_params_supplied.l
    end

    @pledge = get_pledge
    if @pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    gift = @pledge.find_line_item_with_id(params[:gift][:id])
    if gift.nil?
      raise ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => params[:gift][:id])
    elsif !gift.status.nil?
      raise SecurityError, :security_error_trying_to_update_processed_gift.l(:id => params[:gift][:id])
    end

    gift.update_attributes = params[:gift]

    if gift.save!
      redirect_to :controller => :pledge, :action => :show
    else
      
    end
  end

  def delete

  end
end
