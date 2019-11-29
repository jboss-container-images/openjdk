# NOT tagged for any images - test broken
Feature: Openshift OpenJDK S2I tests
# NOTE: these tests should be usable with the other images once we have refactored the JDK scripts.
# These builds do not actually run maven. This is important, because the proxy
# options supplied do not specify a valid HTTP proxy.

  # test incremental builds
  Scenario: Check incremental builds cache .m2
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet
        | variable    | value               |
        | JAVA_ARGS   | Hello from CTF test |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test
     And s2i build log should contain Downloading:
    Given s2i build https://github.com/jboss-openshift/openshift-quickstarts from undertow-servlet with env and incremental
        | variable    | value               |
        | JAVA_ARGS   | Hello from CTF test |
    Then container log should contain /deployments/undertow-servlet.jar Hello from CTF test
     And s2i build log should not contain Downloading:
