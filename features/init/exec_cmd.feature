Feature: Initialization repository
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  Scenario: run simple command
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
      https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
        - echo "succes1s!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "success!!!!\n"
    Then the output should contain "succes1s!!!!\n"

