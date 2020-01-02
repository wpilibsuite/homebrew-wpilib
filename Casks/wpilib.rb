cask 'wpilib' do
  version '2020.1.2'
  sha256 'd14fe56b293ff2a9cddd7576801fa42c6f920e8e6c74cde9f2741864507ab375'

  # github.com/wpilibsuite/allwpilib was verified as official when first introduced to the cask
  url "https://github.com/wpilibsuite/allwpilib/releases/download/v#{version}/WPILib_Mac-#{version}.tar.gz"
  appcast 'https://github.com/wpilibsuite/allwpilib/releases.atom'
  name 'WPILib Suite'
  homepage 'https://wpilib.org/'

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
