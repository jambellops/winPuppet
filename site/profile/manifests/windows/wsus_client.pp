# Profile for windows wsus_client
class profile::windows::wsus_client {
  case $::hostname {
    /-(mytag1|mytag2)|(intl2|intl3)-dc/:  {
      $auto_update_option           = lookup('wsus_client::altcase::auto_update_option')
      $scheduled_install_day        = undef
      $scheduled_install_hour       = undef
      $reschedule_wait_time_minutes = undef
    }
    default: {
      $auto_update_option           = lookup('wsus_client::default::auto_update_option')
      $scheduled_install_day        = lookup('wsus_client::default::scheduled_install_day')
      $scheduled_install_hour       = lookup('wsus_client::default::scheduled_install_hour')
      $reschedule_wait_time_minutes = lookup('wsus_client::default::reschedule_wait_time_minutes')
    }
  }
  $target_group = $::hostname ? {
    /mytag1/                                   => lookup('wsus_client::oracle::target_group'),
    /mytag2/                                   => lookup('wsus_client::tm1::target_group'),
    /(?!loc1-dc\d)loc1|(?!loc2-dc\d)loc2|intl1/=> lookup('wsus::exception_servers::target_group'),
    /-dc\d/                                    => lookup('wsus_client::domain_controllers::target_group'),
    default                                    => lookup('wsus_client::default::target_group'),
  }

  class { 'wsus_client':
    server_url                     => "http://my-wsus01.${::domain}:8530",
    auto_update_option             => $auto_update_option,
    scheduled_install_day          => $scheduled_install_day,
    scheduled_install_hour         => $scheduled_install_hour,
    target_group                   => $target_group,
    reschedule_wait_time_minutes   => $reschedule_wait_time_minutes,
    accept_trusted_publisher_certs => true,
    enable_status_server           => true,
    elevate_non_admins             => false,
  }
}
