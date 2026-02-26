class Zzsleep < Formula
  desc "A CLI timer tool that waits until a specified time with a progress bar"
  homepage "https://github.com/takumi3488/zz"
  version "0.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.6/zzsleep-aarch64-apple-darwin.tar.xz"
      sha256 "0cb9740fba98ccb36e899ecd8cd653351ae1af70333b46cda95dcd814bebb789"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.6/zzsleep-x86_64-apple-darwin.tar.xz"
      sha256 "6bf1181c7978772b1fb1977f56255b3fc2200c028190f9535b8a5f843f9d036a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.6/zzsleep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e78f6b8e8f2a45799ee373d0d68081b5dd705390d7f1688e94344c77f412d086"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.6/zzsleep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c2857c4836e1c65f9566d74ee7a6a88e7c9d52e4dd03238524b2fa589937fe6"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
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
    bin.install "zz" if OS.mac? && Hardware::CPU.arm?
    bin.install "zz" if OS.mac? && Hardware::CPU.intel?
    bin.install "zz" if OS.linux? && Hardware::CPU.arm?
    bin.install "zz" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
