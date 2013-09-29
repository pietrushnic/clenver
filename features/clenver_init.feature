Feature: Initialization
    In order to save time and money
    User should be able to bootstrap project environment ASAP

    Scenario: No valid config file given
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

