@ubi8/openjdk-8
@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: OpenJDK JAVA s2i Runtime tests

  Scenario: JAVA_OPTIONS sets JAVA_OPTS and overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable     | value          |
    | JAVA_OPTIONS | --show-version |
    Then container log should not contain -XX:MaxRAMPercentage
    And  container log should contain --show-version
