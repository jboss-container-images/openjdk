Feature: Tests for all openshift images

  @ubi8
  Scenario: Check that common labels are correctly set
    Given image is built
    # UBI base image versions are the RHEL version, e.g. "9.2", whereas all of
    # our image versions (so far) have been 1.x
    Then the image should contain label version containing value 1.
    And the image should contain label name containing value openjdk

  # builder-only test
  @ubi8/openjdk-8
  @ubi8/openjdk-11
  @ubi8/openjdk-17
  @ubi8/openjdk-21
  Scenario: Check that builder labels are correctly set
    Given image is built
    Then the image should contain label io.openshift.s2i.scripts-url with value image:///usr/local/s2i
