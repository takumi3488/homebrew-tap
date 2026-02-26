class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/takumi3488/seher"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.9/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "1b023cfb7b4858265ad50931c3e4c8c1da18a9f096ea775c98e0c0449ed9c6bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.9/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "c1e78824ce617c55bafff9089f5e68ad115c93a7cf65973a9f5b719b51ad8b7c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.9/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e18a1de58d918bb26b33029a1bc082249c0ac2ab8f2567f3664cd01000634844"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.9/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6722e9041d96e0ac61eb42f8dcd4b423321da7f3cdf7e8f9e888d86d38fb519a"
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
