# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def find_pledge
    if session[:pledge_id].nil?
      pledge = Pledge.create!
      session[:pledge_id] = pledge.id
    end
    pledge = Pledge.find(session[:pledge_id])
  end

  def select_pledge_amounts_cents_values(max=30000)
    pledge_amounts = Array.new
    2500.step(max, 2500) do |amt|
      # Map amount string (in dollars) to amount integer (in cents)
      pledge_amounts << [(:donation_amount.l :amount => amt/100), amt]
    end
    pledge_amounts << [(:donation_amount.l :amount => max/100), max] if pledge_amounts.last[1] < max
    pledge_amounts
  end

  def select_savetogether_amounts_cents_values
    factors = [0.1, 0.15, 0.2, 0.25, 0.3, 0.4, 0.5]
    opts = []
    ctotal = 0
    storg_id = Organization.find_savetogether_org.id
    find_pledge.donations.each do |d|
      unless d.to_user_id == storg_id
        ctotal = ctotal + d.cents
      end  
    end  

    factors.each_with_index do |f, i|
      camount = ctotal.to_f * f
      percent = f * 100.to_f
      amount = Money.new(camount.to_i)
      opts << [:donation_amount_to_st.l(:amount => amount.format(:html), :percent => percent), camount.to_i]
    end
    return opts
  end
end
