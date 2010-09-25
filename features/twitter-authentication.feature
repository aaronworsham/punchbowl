Feature: Twitter Authentication
  So that I can share my mango progress with my Twitter followers
  As a Customer
  I want to authenticate Mango with Twitter

@twitter
Scenario: Successfully authorize
	Given I have not previously authorized
	When I authorize with Twitter
	Then I should be authorized

