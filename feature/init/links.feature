Feature: Initialization links
  In order to save time and money
  User should be able to bootstrap project environment ASAP

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

  Scenario: files backup verification
   Given The default aruba timeout is 10 seconds
   Given a file named "test_repo.yml" with:
   """
   https://github.com/pietrushnic/dummy.git:
     links:
       foobar.txt:
       - foobar_link
       - foobar_link
       foobar:
       - foobar_dir_link
   """
   When I run `clenver init test_repo.yml some_tmp`
   Then the following links should exist:
     | some_tmp/test_repo/foobar_link     |
     | some_tmp/test_repo/foobar_link_old |
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
