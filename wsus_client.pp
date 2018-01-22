# Profile for windows wsus_client
class profile::windows::wsus_client {
  case $::hostname {
    /-(orl|tm1)|(blr1|del1)-dc/:  {
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
    /-orl/                                     => lookup('wsus_client::oracle::target_group'),
    /-tm1/                                     => lookup('wsus_client::tm1::target_group'),
    /(?!irn1-dc\d)irn1|(?!acm1-dc\d)acm1|yyz1/ => lookup('wsus::atg_servers::target_group'),
    /-dc\d/                                    => lookup('wsus_client::domain_controllers::target_group'),
    default                                    => lookup('wsus_client::default::target_group'),
  }

  class { 'wsus_client':
    server_url                     => "http://sjc1-wsus01.${::domain}:8530",
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
