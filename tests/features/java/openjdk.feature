# TODO: it would be nice to make the below less specific to 8 & 11. What about when 12
# is released, etc.
Feature: Miscellaneous OpenJDK-related unit tests

  @ubi8/openjdk-8
  @ubi8/openjdk-8-runtime
  Scenario: Check that only OpenJDK 8 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-11
    Then available container log should not contain java-17

  @ubi8/openjdk-11
  @ubi8/openjdk-11-runtime
  Scenario: Check that only OpenJDK 11 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-17
    Then available container log should not contain java-21

  @ubi8/openjdk-17
  Scenario: Check that only OpenJDK 17 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-11
    Then available container log should not contain java-21

  @ubi8/openjdk-21
  @ubi8/openjdk-21-runtime
  Scenario: Check that only OpenJDK 21 is installed
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-11
    Then available container log should not contain java-17

  @ubi8
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
    Then available container log should not contain os-prober
    Then available container log should not contain rpm-plugin-systemd-inhibit

  @ubi8/openjdk-8
  Scenario: Check that directories from other JDKs are not present (JDK8)
    When container is started with args
    | arg     | value   |
    | command | ls -1 /usr/lib/jvm |
    Then available container log should not contain java-11
    And  available container log should not contain java-17

  @ubi8/openjdk-11
  Scenario: Check that directories from other JDKs are not present (JDK11)
    When container is started with args
    | arg     | value   |
    | command | ls -1 /usr/lib/jvm |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-17
    Then available container log should not contain java-21

  @ubi8/openjdk-17
  Scenario: Check that directories from other JDKs are not present (JDK17)
    When container is started with args
    | arg     | value   |
    | command | ls -1 /usr/lib/jvm |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-11
    Then available container log should not contain java-21

  @ubi8/openjdk-21
  @ubi8/openjdk-21-runtime
  Scenario: Check that directories from other JDKs are not present (JDK21)
    When container is started with args
    | arg     | value   |
    | command | ls -1 /usr/lib/jvm |
    Then available container log should not contain java-1.8.0
    Then available container log should not contain java-11
    Then available container log should not contain java-17

  @ubi8/openjdk-8
  @ubi8/openjdk-8-runtime
  @ubi8/openjdk-11
  @ubi8/openjdk-11-runtime
  @ubi8/openjdk-17
  @ubi8/openjdk-17-runtime
  Scenario: Ensure LANG is defined and contains UTF-8
    When container is started with args
    | arg     | value                                  |
    | command | bash -c "$JAVA_HOME/bin/java -XshowSettings:properties -version" |
    Then available container log should contain file.encoding = UTF-8

  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  Scenario: Check that transitive weak dependencies are not installed (OPENJDK-1335)
    When container is started with args
    | arg     | value   |
    | command | rpm -qa |
    Then container log should not contain procps-ng
    Then container log should not contain os-prober
    Then container log should not contain which
    Then container log should not contain systemd-pam
    Then container log should not contain libpwquality
    Then container log should not contain libxkbcommon
    Then container log should not contain kbd
