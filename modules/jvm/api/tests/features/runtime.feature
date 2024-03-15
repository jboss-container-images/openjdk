@ubi8/openjdk-8
@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: OpenJDK Runtime tests 

  @ubi8
  Scenario: Check JAVA_APP_NAME can contain spaces (OPENJDK-104)
    Given container is started with env
    | variable         | value   |
    | JAVA_APP_NAME    | foo bar |
  Then container log should not contain exec: bar': not found

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

  Scenario: JAVA_OPTIONS sets JAVA_OPTS and overrides defaults (OPENJDK-2009)
    Given container is started with env
    | variable     | value          |
    | JAVA_OPTIONS | --show-version |
    Then container log should not contain -XX:MaxRAMPercentage
    And  container log should contain --show-version

  @ubi8
  Scenario: Check default JAVA_APP_DIR (OPENJDK-2033)
  When container is ready
  Then available container log should contain INFO running in /deployments

  @ubi8
  Scenario: Check custom JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value       |
    | JAVA_APP_DIR | /home/jboss |
  Then available container log should contain INFO running in /home/jboss

  @ubi8
  Scenario: Check relative path JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value  |
    | JAVA_APP_DIR | .      |
  Then available container log should contain INFO running in /home/jboss

  @ubi8
  Scenario: Check non-existent path JAVA_APP_DIR (OPENJDK-2033)
    Given container is started with env
    | variable     | value  |
    | JAVA_APP_DIR | /nope  |
  Then available container log should contain ERROR No directory /nope found for auto detection
