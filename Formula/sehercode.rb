class Sehercode < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/takumi3488/seher"
  version "0.0.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.8/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "cf5a286ed65c3bba75a633c9c994cade8a857c53db4bb1065343f7a7b30010bd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.8/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "03b1c7588b1292bcb18de3ae66285b0174328cfc7918b86954af9a746c81ffcc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.8/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e01a1b94b41cfbe6cffe864774c81c8f19c35ddf8f429ff3adad43ab7443d322"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.8/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b3e89eeb71acb4b32aeb068278d717642de60337e171bfa9e28c2c79b10921c2"
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
