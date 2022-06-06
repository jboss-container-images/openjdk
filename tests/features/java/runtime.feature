@ubi9/openjdk-11
@ubi9/openjdk-17
Feature: Openshift OpenJDK Runtime tests

  Scenario: Ensure JAVA_ARGS is passed through, diagnostic options work correctly, JVM_ARGS not present in run script, OPENJDK-474 JAVA_ARGS not repeated
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
       | variable         | value  |
       | JAVA_ARGS        | unique |
       | JAVA_DIAGNOSTICS | true   |
    Then container log should contain /deployments/undertow-servlet.jar unique
     And container log should contain -XX:NativeMemoryTracking=summary
     And file /usr/local/s2i/run should not contain JVM_ARGS
     And container log should not contain unique unique

  @ubi9
  Scenario: Check JAVA_OPTS overrides defaults
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS | --show-version |
    Then container log should not contain -XX:MaxRAMPercentage

  @ubi9
  Scenario: Check empty JAVA_OPTS overrides defaults
    Given container is started with env
    | variable  | value          |
    | JAVA_OPTS |                |
    Then container log should not contain -XX:MaxRAMPercentage

  @ubi9
  Scenario: Check JAVA_OPTS overrides JAVA_OPTS_APPEND
    piv
    Given container is started with env
    | variable         | value          |
    | JAVA_OPTS        | -verbose:gc    |
    | JAVA_OPTS_APPEND | -Xint          |
    Then container log should contain -verbose:gc
     And container log should not contain -Xint
