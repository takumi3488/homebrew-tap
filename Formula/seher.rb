class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/smartcrabai/seher"
  version "0.0.21"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.21/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "a29bb663a10f1725e541bf5fd63931ea3694e9e63c5185e5094f4112577df608"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.21/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "098c13952d3232b55614824a1a0900dd1702c01769ec8fc492b7dee9d61c6ec1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.21/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ec174c4de89b886b5006c7eabdabc7baf3d94657125860b19010960bde537c5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/seher/releases/download/v0.0.21/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fddf23edd80eb37b27fecfabf3e31088ad28686f167114da47b82052d51a63eb"
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
