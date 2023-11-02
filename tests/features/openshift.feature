  # builder-only test
@ubi9/openjdk-11
@ubi9/openjdk-17
Feature: Tests for all openshift images

  Scenario: Check that common labels are correctly set
    Given image is built
    Then the image should contain label version
    And the image should contain label name
    And the image should contain label io.openshift.s2i.scripts-url with value image:///usr/local/s2i
