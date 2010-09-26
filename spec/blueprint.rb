require 'machinist/active_record'
require 'sham'
require 'faker'

Sham.email   { Faker::Internet.email }
Sham.name    { Faker::Lorem.words.first }
Sham.blah    { Faker::Lorem.paragraph }

Customer.blueprint do
  email 
end

TwitterAccount.blueprint do
  customer
  token     { Sham.name }  
  secret    { Sham.name }  
  verifier  { Sham.name }
end
