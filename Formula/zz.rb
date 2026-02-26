class Zz < Formula
  desc "A CLI timer tool that waits until a specified time with a progress bar"
  homepage "https://github.com/takumi3488/zz"
  version "0.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.7/zzsleep-aarch64-apple-darwin.tar.xz"
      sha256 "7b40d4806a2add8dc1361f1051ac7b763f56046964db86cb174d20d071a2d0ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.7/zzsleep-x86_64-apple-darwin.tar.xz"
      sha256 "e178a8a04cec11716a5c6ead237d44f9270207f47f67741c97f79d3139a32b49"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.7/zzsleep-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "185ff0ac8ad2729e8761c58e7defe8ee19fb1e7fa6f87c8f25d8e90819a098fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/zz/releases/download/v0.0.7/zzsleep-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c1fdacbb5474732d02be748613fe02a9394619f2f7d8408b148cd66adb8daca0"
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
