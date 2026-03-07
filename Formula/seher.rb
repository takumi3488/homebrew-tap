class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.18"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.18/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "380376e0ba57e56c90b8620c5a4b207860567c8a75ff02380656e7a1a6853632"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.18/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "35b192bd9c0722985abc7c4785f1a6af98a2d91ff00ebf86ca31f7ebffd8efe4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.18/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "26c96d6dcf54ddfec4eb67d68521e65c9458ac7538ae2f7004c5ed4e86bf992a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.18/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01d7c7981d19fe65526324e7d14a6f3613b0b29fc378c7c90b386fff0157b385"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
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
    bin.install "seher" if OS.mac? && Hardware::CPU.arm?
    bin.install "seher" if OS.mac? && Hardware::CPU.intel?
    bin.install "seher" if OS.linux? && Hardware::CPU.arm?
    bin.install "seher" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
