# builder only
@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: JVM Performance tests

  @ubi8/openjdk-8
  # temporarily marking 'ignore' so these tests are skipped on GHA
  # See: https://issues.redhat.com/browse/OPENJDK-2602
  @ignore
  Scenario: Check java perf dir owned by jboss (CLOUD-2070)
    Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from undertow-servlet
    Then run jstat -gc 1 1000 1 in container and check its output for S0C
    And run stat --printf="%U %G" /tmp/hsperfdata_jboss/ in container and check its output for jboss root
