namespace :pb do
  namespace :test_users do
    namespace :twitter do
      desc 'Create the test user for Dev or Test ENV' 
      task :create => :environment do 
        user = Customer.find_or_create_by_name_and_uuid(AppConfig.twitter["test_name"], AppConfig.twitter["test_email"])
        twitter_account = user.twitter_account
        if twitter_account
          if twitter_account.greenlit?
            return 'Account Ready to Use'
          else
            twitter_account.update_attributes(
              :secret => AppConfig.twitter["test_secret"],
              :token => AppConfig.twitter["test_token"]
            )
            
          end
        else
          TwitterAccount.create(
            :customer => user,
            :secret => AppConfig.twitter["test_secret"],
            :token => AppConfig.twitter["test_token"]
          )
        end
      end
    end
  end
end
