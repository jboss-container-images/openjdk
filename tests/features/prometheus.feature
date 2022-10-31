@openjdk
@redhat/openjdk-8-rhel7
@ubi8/openjdk-8
@ubi8/openjdk-11
@ubi8/openjdk-17
Feature: Prometheus agent tests

  Scenario: Verify API and defaults
    When container is started with args and env
      | arg_env                  | value |
      | env_AB_PROMETHEUS_ENABLE | false |
      | arg_command              | bash -c 'source $JBOSS_CONTAINER_PROMETHEUS_MODULE/prometheus-opts; get_prometheus_opts' |
    Then container log should not contain -javaagent:/usr/share/java/prometheus-jmx-exporter/jmx_prometheus_javaagent.jar=9799:/opt/jboss/container/prometheus/etc/jmx-exporter-config.yaml

  Scenario: Check Prometheus configuration
    When container is started with args and env
      | arg_env                  | value |
      | env_AB_PROMETHEUS_ENABLE | true  |
      | arg_command              | bash -c 'source $JBOSS_CONTAINER_PROMETHEUS_MODULE/prometheus-opts; get_prometheus_opts' |
    Then container log should contain -javaagent:/usr/share/java/prometheus-jmx-exporter/jmx_prometheus_javaagent.jar=9799:/opt/jboss/container/prometheus/etc/jmx-exporter-config.yaml

  Scenario: Check Prometheus custom configuration
    When container is started with args and env
      | arg_env                               | value                                  |
      | env_AB_PROMETHEUS_ENABLE              | true                                   |
      | env_AB_PROMETHEUS_JMX_EXPORTER_PORT   | 8080                                   |
      | env_AB_PROMETHEUS_JMX_EXPORTER_CONFIG | /path/to/some/jmx-exporter-config.yaml |
      | arg_command                           | bash -c 'source $JBOSS_CONTAINER_PROMETHEUS_MODULE/prometheus-opts; get_prometheus_opts' |
    Then container log should contain -javaagent:/usr/share/java/prometheus-jmx-exporter/jmx_prometheus_javaagent.jar=8080:/path/to/some/jmx-exporter-config.yaml

  @redhat-openjdk-18
  @openjdk
  Scenario: Ensure the Prometheus Agent JAR has the expected checksum
    When container is started with args
    | arg     | value                                                                            |
    | command | bash -c "md5sum $JBOSS_CONTAINER_PROMETHEUS_MODULE/jmx_prometheus_javaagent.jar" |
    Then available container log should contain 8b3af39995b113baf35e53468bad7aae
