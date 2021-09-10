# TODO: it would be nice to make the below less specific to 8 & 11. What about when 12
# is released, etc.
Feature: Miscellaneous OpenJDK-related unit tests

  @redhat-openjdk-18/openjdk18-openshift
  @openjdk/openjdk-1.8-ubi8
  @openj9/openj9-8-rhel8
  @ubi8/openjdk-8
  @ubi8/openjdk-8-runtime
  Scenario: Check that only OpenJDK 8 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-11
    Then available container log should not contain java-17

  @openjdk/openjdk-11-rhel7
  @openjdk/openjdk-11-ubi8
  @openj9/openj9-11-rhel8
  @ubi8/openjdk-11
  @ubi8/openjdk-11-runtime
  Scenario: Check that only OpenJDK 11 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-17

  @ubi8/openjdk-17
  Scenario: Check that only OpenJDK 17 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-11

  @ubi8
  @openjdk
  @openj9
  Scenario: Ensure JAVA_HOME is defined and contains Java
    When container is started with args
    | arg     | value                                  |
    | command | bash -c "$JAVA_HOME/bin/java -version" |
    Then available container log should contain OpenJDK Runtime Environment

  @ubi8
  Scenario: Check that certain non-UBI packages are not installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain grub
    Then available container log should not contain dejavu-sans-mono-fonts
    Then available container log should not contain os-prober
    Then available container log should not contain rpm-plugin-systemd-inhibit
