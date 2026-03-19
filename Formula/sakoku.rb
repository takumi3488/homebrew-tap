class Sakoku < Formula
  desc "A fast CLI tool to detect non-ASCII bytes in source files"
  homepage "https://github.com/smartcrabai/sakoku"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.5/sakoku-aarch64-apple-darwin.tar.xz"
      sha256 "2d99024e62d2d76807bdb566395cb433bfb4ab7b57f74980574429f1b0264cd2"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.5/sakoku-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "609f52cca9cdd19b74b1c45faaf614f035e5c520b5d340b482174707fb06e9a2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/sakoku/releases/download/v0.1.5/sakoku-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7df78e91e71b93408030b763d483aa51eef4899b2d8ac0771991ca8155890c65"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-pc-windows-gnu":    {},
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
    bin.install "sakoku" if OS.mac? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.arm?
    bin.install "sakoku" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
