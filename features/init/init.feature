Feature: Initialization
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  Scenario: Init simple project to given directory
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following files should exist:
      | some_tmp/test_repo/dummy/README.md |


