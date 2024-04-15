@ubi8/openjdk-8
@ubi8/openjdk-11
@ubi8/openjdk-17
@ubi8/openjdk-21
Feature: Openshift S2I tests
  # OPENJDK-84 - /tmp/src should not be present after build
  Scenario: run an s2i build and check that /tmp/src has been removed afterwards
    Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from spring-boot-sample-simple
    Then run stat /tmp/src in container and immediately check its output does not contain File:

  # OPENJDK-2824 - ensure binary-only s2i doesn't try to change timestamps of
  # S2I_TARGET_DEPLOYMENTS_DIR. Use /var/tmp as a directory where attempting to
  # will fail. This simulates the s2i process running as a random UID, which can't
  # change timestamps on the default directory, /deployments.
  Scenario: Ensure binary-only build doesn't fail trying to set timestamp of S2I_TARGET_DEPLOYMENTS_DIR (OPENJDK-2850)
      Given s2i build https://github.com/jboss-container-images/openjdk-test-applications from OPENJDK-2408-bin-custom-s2i-assemble with env
       | variable                   | value |
       | S2I_TARGET_DEPLOYMENTS_DIR | /var/tmp  |
     Then s2i build log should not contain rsync: [generator] failed to set permissions on "/var/tmp/.": Operation not permitted
     And  run stat /var/tmp/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar in container and check its output for Access:
