Feature: Clenver return its version
  In order to improve error reports from users
  Application should return correct version

  Scenario: Exit correctly when asked about version
    When I run `clenver version`
    Then the exit status should be 0

  Scenario: Return correct version number
    When I run `clenver version`
    Then the output should contain correct version
