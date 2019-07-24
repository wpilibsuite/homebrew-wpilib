cask 'wpilib' do
  version '2019.4.1'
  sha256 '7ab231d07a7a99c9ad40e1b3585368b8b55981509754b5158c623ffc1a226e2b'

  url "https://github.com/wpilibsuite/allwpilib/releases/download/v#{version}/WPILib_Mac-#{version}.tar.gz"
  appcast 'https://github.com/wpilibsuite/allwpilib/releases.atom'
  name 'WPILib 2019'
  homepage "https://wpilib.org/"

  auto_updates = false
  depends_on cask: 'visual-studio-code'

  install_dir = "#{ENV['HOME']}/frc2019"

  artifact '.', target: install_dir

  preflight do
    system_command '/usr/bin/python', args: ["#{staged_path}/tools/ToolsUpdater.py"]

    Dir.glob("#{staged_path}/vsCodeExtensions/*.vsix") do |vsix_file|
      system_command '/usr/local/bin/code', args: ['--install-extension', vsix_file]
    end
  end

  uninstall_preflight do
    system_command '/usr/local/bin/code', args: ['--uninstall-extension', 'wpilibsuite.vscode-wpilib']
  end
end
