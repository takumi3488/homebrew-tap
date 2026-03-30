class Avocode < Formula
  desc "An AI coding agent with support for 15+ LLM providers, multiple interfaces (TUI/CLI/HTTP), and extensible tools"
  homepage "https://github.com/smartcrabai/avocode"
  version "0.1.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/avocode/releases/download/v0.1.1/avocode-aarch64-apple-darwin.tar.xz"
    sha256 "6d50f58f1984b5176ceaab930b9052c33249c5505cbba140120ee07d52c71c6c"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/avocode/releases/download/v0.1.1/avocode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "050c41dab6f18a00d75f08dc8aadf0bc1962b77fc82218e2677b603bbbb5a59f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/avocode/releases/download/v0.1.1/avocode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f520846d198cf3da5ef2dc211f60f9717d419aa83d1cea1828cca542dca07623"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "avocode" if OS.mac? && Hardware::CPU.arm?
    bin.install "avocode" if OS.linux? && Hardware::CPU.arm?
    bin.install "avocode" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
