namespace :pb do
  namespace :rewards do
    def tango_reward(t)
       token = t.generate_token
       r = Reward.create(:customer => t.customer, :issued_at => Time.now, :token => t.generate_token)
       t.reward = r
       t.save
       TangoMailer.reward(t.customer.email, token).deliver
    end

    desc "Tango tasks for a week"
    task :tango => [:send_tango, :fulfill_tango, :increment_week]

    desc "Run rewards for Tango"
    task :send_tango => :environment do
      reward_week = AppStat.first.tango_reward_week
      start_date = Time.parse( AppConfig.rewards["tango"]["start_date"] ).advance(:weeks => reward_week)
      tangos = MangoTango.joins("INNER JOIN rewards, customers 
                                ON mango_tangos.id != rewards.rewardable_id and 
                                rewards.rewardable_type = 'MangoTango' and
                                mango_tangos.created_at > '#{start_date.to_s(:db)}' and
                                mango_tangos.customer_id = customers.id and
                                customers.email is not null")
      if reward_week < 5
        tangos.each do |t|
          tango_reward t
        end
      else
        best_tangos = DancePartner.find_by_sql("SELECT mango_tango_id,count(*) as num_partners 
                                                FROM dance_partners 
                                                GROUP by mango_tango_id 
                                                ORDER by num_partners desc limit 5")
        best_tangos.each do |bt|
          t = MangoTango.find bt.mango_tango_id
          tango_reward t
        end
        20.times do |i|
          tango_reward tangos.rand
        end
      end
    end
    desc "Fulfill rewards for Tango"
    task :fulfill_tango => :environment do
      reward_week = AppStat.first.tango_reward_week
      start_date = Time.parse( AppConfig.rewards["tango"]["start_date"] ).advance(:weeks => reward_week)
      rewards = Reward.where('rewards.redeemed_at > ? and rewards.rewardable_type = ?', start_date.to_s(:db), "MangoTanog").all
      TangoMailer.fulfill(rewards).deliver if rewards.present?
    end

    task :increment_week => :environment do
      AppStat.first.increment(:tango_reward_week)
    end
  end
end
