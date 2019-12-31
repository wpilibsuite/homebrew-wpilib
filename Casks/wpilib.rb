cask 'wpilib' do
  version '2020.1.1'
  sha256 '3e30ca5e5c1282187bcc097cd024ccaae00a2d4d477282288613590740673a80'

  url "https://github.com/wpilibsuite/allwpilib/releases/download/v#{version}/WPILib_Mac-#{version}.tar.gz"
  appcast 'https://github.com/wpilibsuite/allwpilib/releases.atom'
  name 'WPILib Suite'
  homepage "https://wpilib.org/"

  auto_updates = false
  depends_on cask: 'visual-studio-code'

  install_dir = "#{ENV['HOME']}/wpilib/2020"

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
