# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def find_pledge
    if session[:pledge_id].nil?
      pledge = Pledge.create!
      session[:pledge_id] = pledge.id
    end
    pledge = Pledge.find(session[:pledge_id])
  end

  def select_pledge_amounts_cents_values
    [["$25", 2500], ["$50", 5000], ["$75", 7500], ["$100", 10000],
     ["$125", 12500], ["$150", 15000], ["$175", 17500], ["$200", 20000],
     ["$225", 22500], ["$250", 25000], ["$275", 27500], ["$300", 30000]]
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
      opts << ["#{amount.format(:html)} (#{percent}%)", camount.to_i]
    end
    return opts
  end
end
