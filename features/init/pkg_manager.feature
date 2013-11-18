Feature: Initialization repository
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  @sudo
  Scenario: apt: check if package installed
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    apt:
      - vim
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "vim is already the newest version.\n"

  @sudo
  Scenario: package installed and simple command run
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    apt:
      - vim
    https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "vim is already the newest version.\n"
    Then the output should contain "success!!!!\n"

  Scenario: install gem
    Given The default aruba timeout is 120 seconds
    Given a file named "test_repo.yml" with:
    """
      gem:
        - tmuxinator
      https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "installed\n"
    Then the output should contain "success!!!!\n"

  @sudo
  Scenario: install gems and packages
    Given The default aruba timeout is 120 seconds
    Given a file named "test_repo.yml" with:
    """
    apt:
      - vim
      - mutt
    gem:
      - tmuxinator
      - git
    https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "gems installed\n"
    Then the output should contain "vim is already the newest version.\n"
    Then the output should contain "mutt is already the newest version.\n"
    Then the output should contain "success!!!!\n"
