Feature: Miscellaneous general settings unit tests

  @ubi8
  @redhat-openjdk-18/openjdk18-openshift
  @openjdk/openjdk-11-rhel7
  Scenario: Check the attributes of /home/jboss using stat
    When container is started with args
    | arg     | value            |
    | command | stat /home/jboss |
    Then available container log should contain Access: (0771/drwxrwx--x)
