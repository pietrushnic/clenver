Feature: Initialization links
  In order to save time and money
  User should be able to bootstrap project environment ASAP

  Scenario: Init project with symbolic links
   Given The default aruba timeout is 10 seconds
   Given a file named "test_repo.yml" with:
   """
    https://github.com/pietrushnic/dummy.git:
        dst:
            - src/dummy
    links:
        src/dummy/foobar.txt:
            - src/dummy/foobar_link
        src/dummy/foobar:
            - src/dummy/foobar_dir_link
   """
   When I run `clenver init test_repo.yml`
   Then the following links should exist:
     | src/dummy/foobar_link     |
     | src/dummy/foobar_dir_link |

  Scenario: files backup verification
   Given The default aruba timeout is 10 seconds
   Given a file named "test_repo.yml" with:
   """
    https://github.com/pietrushnic/dummy.git:
    links:
      dummy/foobar.txt:
        - foobar_link
        - foobar_link
      dummy/foobar:
        - foobar_dir_link
   """
   When I run `clenver init test_repo.yml`
   Then the following links should exist:
     | foobar_link     |
     | foobar_link_old |
     | foobar_dir_link |

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

  @wip
  Scenario: destination already exist
  Scenario: destination not exist
  Scenario: access denied
