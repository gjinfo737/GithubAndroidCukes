Feature: Navigating to repository history

  Scenario: User is able to navigate to a member
    Given I am logged into github
    When I navigate to a repositories
    And select the "GithubAndroidCukes" repo
	Then I am shown the news for the repository


   Scenario: User can navigate to files
   Given I am viewing the "GithubAndroidCukes" repo
   When I select the "code" tab
   Then I can navigate to this feature file
   
   
