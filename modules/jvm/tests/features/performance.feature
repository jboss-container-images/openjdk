# builder only
@ubi9/openjdk-11
@ubi9/openjdk-17
@ubi9/openjdk-21
Feature: JVM Performance tests

  @ignore
  Scenario: Check java perf dir owned by default (CLOUD-2070, OPENJDK-91)
    Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from undertow-servlet
    Then run jstat -gc 1 1000 1 in container and check its output for S0C
    And run stat --printf="%U %G" /tmp/hsperfdata_default/ in container and check its output for default root
