class Zz < Formula
  desc "A CLI timer tool that waits until a specified time with a progress bar"
  homepage "https://github.com/smartcrabai/zz"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/zz/releases/download/v0.0.8/zzsleep-aarch64-apple-darwin.tar.xz"
      sha256 "ac5a00165516685cacc40e2f3ce5784e597372733d8af18897e91a1bd816e913"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/zz/releases/download/v0.0.8/zzsleep-x86_64-apple-darwin.tar.xz"
      sha256 "9a092dd33f9570a47d25791b1a4daa48b6b977952f82ada3599bf7655a476a5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/zz/releases/download/v0.0.8/zzsleep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe78458fc5aa486fd4415db83fe743ae59edf48a22dc6d9ca0a84ac157f1ce55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/zz/releases/download/v0.0.8/zzsleep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f16419cb76114fb171ccc353d0ffe99acc1ecdba14cb2ff7b27c7da7031cbe9"
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
