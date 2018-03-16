Facter.add(:windows_distinguishedname) do
  confine osfamily: 'Windows'
  setcode do
    value = nil
    Win32::Registry::HKEY_LOCAL_MACHINE.open('SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine') do |regkey|
      value = regkey['Distinguished-Name']
    end
    value
  end
end
