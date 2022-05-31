Feature: Miscellaneous general settings unit tests

  @ubi9
  Scenario: Check the attributes of /home/jboss using stat
    When container is started with args
    | arg     | value            |
    | command | stat /home/jboss |
    Then available container log should contain Access: (0770/drwxrwx---)
