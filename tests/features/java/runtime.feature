Feature: Openshift OpenJDK Runtime tests

  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  Scenario: Ensure JVM_ARGS is no longer present in the run script
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
    Then file /usr/local/s2i/run should not contain JVM_ARGS

  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  Scenario: Ensure JAVA_ARGS are passed through to the running java application
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
       | variable    | value               |
       | JAVA_ARGS   | Hello from CTF test |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test

  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  Scenario: Ensure diagnostic options work correctly
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
       | variable         | value               |
       | JAVA_ARGS        | Hello from CTF test |
       | JAVA_DIAGNOSTICS | true                |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test
      And container log should contain -XX:NativeMemoryTracking=summary

  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  Scenario: OPENJDK-474 to ensure JAVA_ARGS is not duplicated in the java command line
    Given container is started with env
    | variable  | value  |
    | JAVA_ARGS | unique |
  Then container log should not contain unique unique

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
