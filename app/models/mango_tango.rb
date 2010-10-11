class MangoTango < ActiveRecord::Base
  include TokenGenerator
  has_many :dance_partners
  belongs_to :customer
  has_one :reward, :as => :rewardable, :order => 'created_at DESC'
  belongs_to :badge 

  def self.top_5

      mt_ids = DancePartner.find_by_sql(  "SELECT d.mango_tango_id,count(*) as num_partners 
                                                FROM dance_partners d
                                                INNER JOIN
                                                  ( SELECT m.id 
                                                    FROM mango_tangos m
                                                    INNER JOIN customers c
                                                    WHERE m.created_at > '#{start_date.to_s(:db)}' and
                                                    m.customer_id = c.id and
                                                    c.email is not null and
                                                    NOT EXISTS 
                                                      ( SELECT * 
                                                        FROM rewards r
                                                        WHERE r.rewardable_id = m.id and 
                                                        r.rewardable_type = 'MangoTango')
                                                  ) mt
                                                ON d.mango_tango_id = mt.id
                                                GROUP by d.mango_tango_id 
                                                ORDER by num_partners desc limit 5"
                                            )
    top5 = []
    mt_ids.each{|m| top5 << MangoTango.find(m.mango_tango_id)}
    top5
  end

  def self.potential_winners
    MangoTango.find_by_sql(  "SELECT m.* 
                              FROM mango_tangos m 
                              INNER JOIN customers c
                              ON m.customer_id = c.id and
                              c.email is not null

                              WHERE m.created_at > '#{start_date.to_s(:db)}' and
                              NOT EXISTS 
                                (SELECT * 
                                FROM rewards r
                                WHERE r.rewardable_id = m.id and 
                                r.rewardable_type = 'MangoTango')

                                                              ")
  end

  def self.start_date
    @start_date ||= Time.parse( AppConfig.rewards["tango"]["start_date"] ).advance(:weeks => AppStat.first.tango_reward_week)
  end

end
