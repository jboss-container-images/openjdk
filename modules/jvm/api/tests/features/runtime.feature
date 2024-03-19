@ubi8/openjdk-8
@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: OpenJDK Runtime tests 

  @ubi8
  Scenario: Check JAVA_OPTS overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS | --show-version |
    Then container log should not contain -XX:MaxRAMPercentage

  @ubi8
  Scenario: Check empty JAVA_OPTS overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS |                |
    Then container log should not contain -XX:MaxRAMPercentage
