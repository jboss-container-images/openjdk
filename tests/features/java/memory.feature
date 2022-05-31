@ubi9
Feature: OPENJDK-559 JVM Memory tests

  Scenario: Check default JVM max heap configuration
    Given container is started as uid 1000
    Then container log should contain -XX:MaxRAMPercentage=80.0

  Scenario: Check configured JVM max heap configuration
    Given container is started with env
    | variable           | value  |
    | JAVA_MAX_MEM_RATIO | 90.0   |
    Then container log should contain -XX:MaxRAMPercentage=90.0

  Scenario: Check default JVM initial heap configuration is unspecified
    Given container is started as uid 1000
    Then container log should not contain -XX:InitialRAMPercentage
    And  container log should not contain -Xms
