# builder only
@ubi9/openjdk-11
@ubi9/openjdk-17
Feature: Openshift OpenJDK-only S2I tests
  Scenario: Check java perf dir owned by jboss (CLOUD-2070)
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
    Then run jstat -gc 1 1000 1 in container and check its output for S0C
    And run stat --printf="%U %G" /tmp/hsperfdata_jboss/ in container and check its output for jboss root

  Scenario: Ensure Quarkus CDS doesn't fail due to timestamp mismatch (OPENDJK-1673)
    Given s2i build https://github.com/jerboaa/quarkus-quickstarts from getting-started using quickstart-2.16-s2i-cds
    Then container log should not contain A jar file is not the one used while building the shared archive file
