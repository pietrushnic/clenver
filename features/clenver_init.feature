Feature: Initialization
    In order to save time and money
    User should be able to bootstrap project environment ASAP

    Scenario: No valid config file
        When I run `clenver init no_name.yml`
        Then the exit status should be 2


