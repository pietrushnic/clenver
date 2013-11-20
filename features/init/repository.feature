Feature: Initialization repository
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  @announce
  Scenario: Connect remote and check uri
    Given The default aruba timeout is 25 seconds
    Given a file named "test_repo.yml" with:
    """
      https://github.com/pietrushnic/spf13-vim.git:
        remotes:
          upstream:
          - https://github.com/spf13/spf13-vim.git
    """
    When I run `clenver init test_repo.yml`
    Then the following remote uris should be connected in "spf13-vim":
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
    When I run `clenver init test_repo.yml`
    Then the following remote branches should be connected in "spf13-vim":
      | upstream |

  Scenario: Clone repo and verify its destination
    Given The default aruba timeout is 25 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/spf13-vim.git:
      dst:
        - $HOME/abs_path_test/spf13-vim
    """
    When I run `clenver init test_repo.yml`
    Then the following absolute path should exist: "$HOME/abs_path_test/spf13-vim"

  @wip
  Scenario: destination already exist
  Scenario: destination not exist
  Scenario: access denied
  Scenario: multiple destinations
    Given The default aruba timeout is 25 seconds
    Given a file named "test_repo.yml" with:
    """
    https://github.com/pietrushnic/spf13-vim.git:
      dst:
        - $HOME/abs_path_test/spf13-vim
      dst:
        - $HOME/abs_path_test/spf13-vim-1
    """
    When I run `clenver init test_repo.yml`
    Then the following absolute path should exist: "$HOME/abs_path_test/spf13-vim"
