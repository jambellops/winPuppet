# Profile for windows servers to update.
class profile::windows::sus_update {
  }
  file { 'psSUSupdate.ps1':
    path   => 'C:\\opt\\psSUSupdate.ps1',
    source => 'puppet:///modules/profile/windows/psSUSupdate.ps1',
    before => scheduled_task['sus_update_task'],
  }
  scheduled_task { 'sus_update_task': # scheduled task to update computers if Wsus did not
  ensure    => present, # 
  enabled   => true, # 
  name      => 'susUpdateTask', # 
  arguments => '-NonInteractive -NoLogo -File C:\\opt\\psSUSupdate.ps1 -install', # 
  command   => 'C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe', # 
  provider  => 'win32_taskscheduler', # 
  trigger   => {
    schedule         => weekly,
    start_date       => '2018-01-20',
    start_time       => '20:00',
    day_of_week      => [sat],
  }
