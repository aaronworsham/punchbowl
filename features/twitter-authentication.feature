Feature: Twitter Authentication
  So that I can share my mango progress with my Twitter followers
  As a Customer
  I want to authenticate Mango with Twitter

@twitter
Scenario: Twitter is unavailable for authorization
	Given I have not authorized
	And Twitter is unavailable
	When I authorize with Twitter
	Then Twitter should be unavailable

@twitter
Scenario: Successfully authorize
	Given I have not previously authorized
	When I authorize with Twitter
	Then I should be authorized

