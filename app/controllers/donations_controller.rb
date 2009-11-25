class DonationsController < ApplicationController
  include ApplicationHelper

  def create
    if params[:donation].nil?
      raise ArgumentError, :argument_error_no_class_params_supplied.l
    end

    @pledge = get_or_init_pledge

    @donation = Donation.create!(params[:donation].merge(:invoice => @pledge))

    redirect_to :controller => :pledges, :action => :render_show_or_edit
  end

  def update
    if params[:donation].nil?
      raise ArgumentError, :argument_error_no_class_params_supplied.l
    end

    @pledge = get_pledge
    if @pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    @donation = @pledge.find_line_item_with_id(params[:id])
    if @donation.nil?
      raise ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => params[:id])
    elsif @donation.status
      raise SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => params[:id], :status => @donation.status)
    end

    @donation.update_attributes params[:donation]

    if @donation.save!
      redirect_to :controller => :pledges, :action => :render_show_or_edit
    else
      logger.error("Tried to save a gift unsuccessfully", @donation.errors)
    end
  end

  def delete
    @pledge = get_pledge
    if @pledge.nil?
      raise RuntimeError, :runtime_error_no_pledge_in_session.l
    end

    @donation = @pledge.find_line_item_with_id(params[:id])
    if @donation.nil?
      raise ArgumentError, :argument_error_gift_not_in_current_pledge.l(:id => params[:id])
    elsif @donation.status
      raise SecurityError, :security_error_trying_to_update_processed_line_item.l(:id => params[:id], :status => @donation.status)
    end

    unless @pledge.line_items.delete(@donation)
      logger.error("Could not delete gift from pledge #{@pledge.id}", @pledge.errors)
    end

    redirect_to :controller => :pledges, :action => :render_show_or_edit
  end
end
