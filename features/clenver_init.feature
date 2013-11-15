Feature: Initialization
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  Scenario: Given config file doesn't exist
    When I run `clenver init no_name.yml`
    Then the exit status should be 2

  Scenario: Valid config file given
    Given The default aruba timeout is 10 seconds
    Given a file named "valid.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
      links:
        foobar.txt:
        - foobar_link
        foobar:
        - foobar_dir_link
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

  Scenario: Init simple project (repo w/ colon)
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
    """
    When I run `clenver init test_repo.yml`
    Then the following files should exist:
      | test_repo/dummy/README.md |

  Scenario: Init simple project (repo w/o colon)
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git
    """
    When I run `clenver init test_repo.yml`
    Then the following files should exist:
      | test_repo/dummy/README.md |

  Scenario: Init simple project to given directory
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following files should exist:
      | some_tmp/test_repo/dummy/README.md |

   Scenario: Init project with symbolic links
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
      links:
        foobar.txt:
        - foobar_link
        foobar:
        - foobar_dir_link
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following links should exist:
      | some_tmp/test_repo/foobar_link     |
      | some_tmp/test_repo/foobar_dir_link |

   Scenario: use system variable in path
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
      links:
        $HOME/foobar.txt:
        - $HOME/foobar_link
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following links should exist:
      | $HOME/foobar_link     |

  Scenario: Connect remote and check uri
    Given The default aruba timeout is 25 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/spf13-vim.git:
      remotes:
        upstream:
        - https://github.com/spf13/spf13-vim.git
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following remote uris should be connected in "some_tmp/test_repo/spf13-vim":
      | https://github.com/spf13/spf13-vim.git |

  Scenario: Connect remote and check its name
    Given The default aruba timeout is 25 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/spf13-vim.git:
      remotes:
        upstream:
        - https://github.com/spf13/spf13-vim.git
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the following remote branches should be connected in "some_tmp/test_repo/spf13-vim":
      | upstream |

  Scenario: run simple command
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "success!!!!\n"

  Scenario: apt: check if package installed
    Given The default aruba timeout is 10 seconds
    Given a file named "test_repo.yml" with:
    """
    apt:
      - vim
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "vim is already the newest version.\n"

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
    Given The default aruba timeout is 45 seconds
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
  @wip
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
  
  Scenario: install gem and package
    Given The default aruba timeout is 45 seconds
    Given a file named "test_repo.yml" with:
    """
    apt:
      - vim
    gem:
      - tmuxinator
    https://github.com/pietrushnic/dummy.git:
      run:
        - echo "success!!!!"
    """
    When I run `clenver init test_repo.yml some_tmp`
    Then the output should contain "installed\n"
    Then the output should contain "success!!!!\n"
