class GiftsController < BaseController
  include ApplicationHelper

  def create
    @pledge = get_or_init_pledge

    @gift = Gift.new(params[:gift].merge(:invoice_id => @pledge.id, :to_user_id => Organization.find_giftcard_org.id))
    @gift_card = GiftCard.new(params[:gift_card])
    @gift.from_gift_card = @gift_card

    if @gift.save
      redirect_to :controller => :pledges, :action => :render_show_or_edit
    else
      # This shouldn't happen if we're only allowing select fields or
      # pre-filled ones that aren't editable
      logger.error("Tried to save a gift unsuccessfully", @gift.errors)
      render :new
    end
  end

  def update
    @pledge = get_pledge
    if @pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    @gift = @pledge.find_line_item_with_id(params[:id])
    if @gift.nil?
      raise ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => params[:id])
    elsif @gift.status
      raise SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => params[:id], :status => @gift.status)
    end

    @gift.update_attributes(params[:gift].merge(:to_user_id => Organization.find_giftcard_org.id))

    if @gift.save!
      redirect_to :controller => :pledges, :action => :render_show_or_edit
    end
  end

  def delete
    @pledge = get_pledge
    if @pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    @gift = @pledge.find_line_item_with_id(params[:id])
    if @gift.nil?
      raise ArgumentError, :argument_error_line_item_not_in_current_pledge.l(:id => params[:id])
    elsif !@gift.status.nil?
      raise SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => params[:id], :status => @gift.status)
    end

    unless @pledge.line_items.delete(@gift)
      logger.error("Could not delete gift from pledge #{@pledge.id}", @pledge.errors)
    end

    redirect_to :controller => :pledges, :action => :render_show_or_edit
  end

  def new
    @gift = Gift.new(:to_user => Organization.find_giftcard_org)
    if current_user
      @gift.from_user_id = current_user.id
    end
  end
end
