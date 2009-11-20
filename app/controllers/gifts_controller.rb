class GiftsController < BaseController
  include ApplicationHelper

  def create
    if params[:gift].nil?
      raise ArgumentError, :argument_error_no_class_params_supplied.l
    end

    pledge = get_or_init_pledge

    gift = Gift.new(params[:gift])
    gift_card = GiftCard.new(params[:gift_card])
    gift.gift_card = gift_card

    if gift.save
      pledge.add_line_item(gift)
      if !pledge.save
        logger.error("Tried to save a pledge unsuccessfully")
        pledge.errors.each do |error|
          logger.error(error.to_s)
        end
        render :new
      else
        redirect_to :controller => :pledges, :action => :render_show_or_edit
      end
    else
      # This shouldn't happen if we're only allowing select fields or
      # pre-filled ones that aren't editable
      logger.error("Tried to save a gift unsuccessfully", gift.errors)
      render :new
    end
  end

  def update
    if params[:gift].nil?
      raise ArgumentError, :argument_error_no_class_params_supplied.l
    end

    pledge = get_pledge
    if pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    gift = pledge.find_line_item_with_id(params[:gift][:id])
    if gift.nil?
      raise ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => params[:gift][:id])
    elsif gift.status
      raise SecurityError, :security_error_trying_to_update_processed_gift.l(:id => params[:gift][:id])
    end

    gift.update_attributes(params[:gift])

    if gift.save!
      redirect_to :controller => :pledges, :action => :render_show_or_edit
    end
  end

  def delete
    pledge = get_pledge
    if pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    gift = pledge.find_line_item_with_id(params[:id])
    if gift.nil?
      raise ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => params[:id])
    elsif !gift.status.nil?
      raise SecurityError, :security_error_trying_to_update_processed_gift.l(:id => params[:id])
    end

    unless pledge.line_items.delete(gift)
      logger.error("Could not delete gift from pledge #{pledge.id}", pledge.errors)
    end

    redirect_to :controller => :pledges, :action => :render_show_or_edit
  end

  def new
    
  end
end
