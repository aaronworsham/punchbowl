require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.client  { Faker::Company.name }
Sham.name    { Faker::Lorem.words.first }
Sham.blah    { Faker::Lorem.paragraph }

Customer.blueprint do
  name 
end

TwitterAccount.blueprint do
  customer
  token     { Sham.name }  
  secret    { Sham.name }  
  verifier  { Sham.name }
end
