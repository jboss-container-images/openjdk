# TODO: it would be nice to make the below less specific to 8 & 11. What about when 12
# is released, etc.
Feature: Container only has one OpenJDK version installed

  @centos/openjdk-8-centos7
  @redhat-openjdk-18/openjdk18-openshift
  Scenario: Check that only OpenJDK 8 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-11

  @centos/openjdk-11-centos7
  @openjdk/openjdk-11-rhel7
  @openjdk/openjdk-11-rhel8
  Scenario: Check that only OpenJDK 8 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
