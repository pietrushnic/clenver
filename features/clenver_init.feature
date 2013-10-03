Feature: Initialization
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  Scenario: Given config file doesn't exist
    When I run `clenver init no_name.yml`
    Then the exit status should be 2

  Scenario: Valid config file given
    Given a file named "valid.yml" with:
    """
    Lorem:
    ipsum:
    dolor: sit amet,
    consectetur adipisicing elit, sed: do eiusmod tempor
    incididunt: ut
    labore et dolore: magna aliqua.
    """
    When I run `clenver init valid.yml`
    Then the exit status should be 0

  Scenario: Invalid config file given
    Given a file named "invalid.yml" with:
    """
    Lorem:{]}
    ipsum:
    dolor: sit amet,
    consectetur adipisicing elit, sed: do eiusmod tempor
    incididunt: ut
    labore et dolore: magna aliqua.
    """
    When I run `clenver init invalid.yml`
    Then the exit status should be 1

  Scenario: Init simpe project
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
    """
    When I run `clenver init test_repo.yml`
    Then the following files should exist:
      | test_repo/dummy/README.md |

  Scenario: Init simpe project to given directory
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following files should exist:
      | some_tmp/test_repo/dummy/README.md |

