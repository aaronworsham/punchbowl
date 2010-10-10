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

      #grap submitted tangos that have no reward yet, have an email, and were created this week
      potential_winners = MangoTango.potential_winners
      if reward_week < 5
        potential_winners.each do |t|
          tango_reward t
        end
      else
        #Find the top five tangos with most dance partners, that have an email, no reward yet and created this week
        top5 = MangoTango.top_5
        top5.each do |m|
          tango_reward m
        end
        #subtract top five winners from potential winners
        new_potential_winners = potential_winners - top5

        #take remaining potential winners, rand select them, remove them from the list, send them an email, and break when 0 left
        20.times do |i|
          winner = new_potential_winners.rand
          tango_reward winner
          new_potential_winners = new_potential_winners.delete winner
          break if new_potential_winners == 0
        end
      end
    end
    desc "Fulfill rewards for Tango"
    task :fulfill_tango => :environment do
      rewards = Reward.where('rewards.redeemed_at > ? and rewards.rewardable_type = ?', MangoTango.start_date.to_s(:db), "MangoTango").all
      TangoMailer.fulfill(rewards).deliver if rewards.present?
    end

    task :increment_week => :environment do
      AppStat.first.increment(:tango_reward_week)
    end
  end
end
