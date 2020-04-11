cask 'wpilib' do
  version '2020.3.2'
  sha256 'e1aa02d7026c923d4b2c8f32c5ec1872f7ef903ca27652af279f79d19cbd5f15'

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
