class Cruise < Formula
  desc "YAML-driven coding agent workflow orchestrator"
  homepage "https://github.com/smartcrabai/cruise"
  version "0.1.35"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.35/cruise-aarch64-apple-darwin.tar.xz"
      sha256 "e18b7fdcac0132aac28faf0bef2581f58b2ca26a99c77dff10b50a404bb31d0c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.35/cruise-x86_64-apple-darwin.tar.xz"
      sha256 "a4fcbb7ce24e478214e5cb37f441d81ff6204321ca34bcc7920bc75d2bf1767c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.35/cruise-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a08b4c41fd2a1909c223b9d809eeb5e5804e70d46a0e9d22b364d339f108d07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/cruise/releases/download/v0.1.35/cruise-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9328207cb392b6f524f931b93dd058cb34eb16a37cd2c96d15dd8071153bb3ec"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cruise" if OS.mac? && Hardware::CPU.arm?
    bin.install "cruise" if OS.mac? && Hardware::CPU.intel?
    bin.install "cruise" if OS.linux? && Hardware::CPU.arm?
    bin.install "cruise" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
