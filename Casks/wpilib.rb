cask "wpilib" do
  arch arm: "Arm64", intel: "Intel"
  url_arch = on_arch_conditional arm: "Arm", intel: ""

  version "2024.1.1"
  sha256 arm:   "69ee98b0456dae36cce9fe836024f9fcf5e7424a7bf75979b6a7a608ce74c78f",
         intel: "fb68cf2f5f8d6a5d7160e9e458f84dec31c29b5a8362d5128e4546589803de86"

  # github.com/wpilibsuite/allwpilib was verified as official when first introduced to the cask
  url "https://packages.wpilib.workers.dev/installer/v#{version}/macOS#{url_arch}/WPILib_macOS-#{arch}-#{version}.dmg",
      verified: "packages.wpilib.workers.dev"
  name "WPILib Suite"
  desc "Tools and libraries to create FRC robot programs"
  homepage "https://wpilib.org/"

  livecheck do
    url "https://github.com/wpilibsuite/allwpilib"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on formula: "python@3"
  depends_on cask: "visual-studio-code"

  year = "#{version.split(".", -1)[0]}"
  install_dir = "#{ENV["HOME"]}/wpilib/#{year}"
  artifacts_arch = on_arch_conditional arm: "Arm", intel: ""

  artifact "artifacts", target: install_dir

  preflight do
    system_command "mkdir", args: ["-p", "#{staged_path}/artifacts"]
    system_command "xattr", args: ["-d", "com.apple.quarantine", "#{staged_path}/WPILib_Mac#{artifacts_arch}-#{version}-artifacts.tar.gz"]
    system_command "tar", args: ["-zxf", "#{staged_path}/WPILib_Mac#{artifacts_arch}-#{version}-artifacts.tar.gz", "-C", "#{staged_path}/artifacts"]

    system_command Formula["python@3"].opt_bin/"python3", args: ["#{staged_path}/artifacts/tools/ToolsUpdater.py"]

    Dir.glob("#{staged_path}/artifacts/vsCodeExtensions/*.vsix") do |vsix_file|
      system_command "#{ENV["HOMEBREW_PREFIX"]}/bin/code", args: ["--install-extension", vsix_file]
    end

    system_command "rm", args: ["#{staged_path}/WPILib_Mac#{artifacts_arch}-#{version}-artifacts.tar.gz"]
    system_command "rm", args: ["-rf", "#{staged_path}/WPILibInstaller.app"]
  end

  uninstall_preflight do
    system_command "#{ENV["HOMEBREW_PREFIX"]}/bin/code",
                   args: ["--uninstall-extension", "wpilibsuite.vscode-wpilib"],
                   must_succeed: false
  end
end
