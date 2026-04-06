class Crab < Formula
  desc "CLI binary for SmartCrab workflow orchestration engine"
  homepage "https://github.com/smartcrabai/smartcrab"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/smartcrab/archive/refs/tags/v0.1.12.tar.gz"
      sha256 "0b43d136963f80b15d1f4696dfad5df96ce4c5407950a549c8790bcaf2633a8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/smartcrab/releases/download/v0.1.4/smartcrab-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f917eaea3c51106a3c8b1cbc37aaed212795ec0b77d15d6f3c15e9ee12a00e19"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/smartcrabai/smartcrab/releases/download/v0.1.4/smartcrab-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4460284eaa259bba790fd2e9f02737ea6219447f8c56dfd75aa06f6dd6b2eb8"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "crab" if OS.mac? && Hardware::CPU.arm?
    bin.install "crab" if OS.mac? && Hardware::CPU.intel?
    bin.install "crab" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
