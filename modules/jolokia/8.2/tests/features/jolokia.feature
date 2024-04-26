@ubi8/openjdk-8
@ubi8/openjdk-11
# Tests for jboss/container/jolokia
Feature: Openshift OpenJDK Jolokia tests

  Scenario: Ensure JOLOKIA_VERSION variable aligns with JAR
    When container is started with command sh
    Then run sh -c 'jar xf /usr/share/java/jolokia-jvm-agent/jolokia-jvm.jar META-INF/maven/org.jolokia/jolokia-jvm/pom.properties && grep ${JOLOKIA_VERSION} META-INF/maven/org.jolokia/jolokia-jvm/pom.properties' in container and check its output for version=

  Scenario: Check jolokia port is available
    Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from undertow-servlet
    Then check that port 8778 is open
    And  inspect container
       | path                    | value       |
       | /Config/ExposedPorts    | 8778/tcp    |

  Scenario: Ensure Jolokia diagnostic options work correctly
    Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from undertow-servlet
       | variable         | value               |
       | JAVA_ARGS        | Hello from CTF test |
       | JAVA_DIAGNOSTICS | true                |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test
      And container log should contain Jolokia: Agent started
