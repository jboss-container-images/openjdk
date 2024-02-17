@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: Openshift OpenJDK S2I tests (Quarkus-based)
  Scenario: Ensure that run-env.sh placed in the JAVA_APP_DIR is sourced in the run script before launching java
      Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from quarkus-quickstarts/getting-started-3.0.1.Final-nos2i
       | variable            | value        |
       | S2I_SOURCE_DATA_DIR | ./           |
       | S2I_TARGET_DATA_DIR | /deployments |
      Then container log should contain INFO exec -a "someUniqueString" java
