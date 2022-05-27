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

  Scenario: Check configured JVM max heap configuration
    Given container is started with env
    | variable               | value  |
    | JAVA_INITIAL_MEM_RATIO | 25.0   |
    Then container log should contain -XX:InitialRAMPercentage=25.0

  Scenario: check JAVA_MAX_INITIAL_MEM overrides JAVA_INITIAL_MEM_RATIO
    Given container is started with env
    | variable               | value  |
    | JAVA_INITIAL_MEM_RATIO | 25.0   |
    | JAVA_MAX_INITIAL_MEM   | 4096m  |
    Then container log should contain -Xms4096m
    And  container log should not contain -XX:InitialRAMPercentage=25.0
