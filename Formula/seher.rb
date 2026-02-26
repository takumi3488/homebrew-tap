class Seher < Formula
  desc "CLI tool to monitor Claude API rate limits and execute code after reset"
  homepage "https://github.com/takumi3488/seher"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.10/sehercode-aarch64-apple-darwin.tar.xz"
      sha256 "078e97fe554509424edc4118dda12f9da9b881af39f77b5ba56defec6f0d9c10"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.10/sehercode-x86_64-apple-darwin.tar.xz"
      sha256 "54490773fc8115b2b435d231feaba239e64e6bdcff3340fe6881f951099d4264"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.10/sehercode-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b57e032541720eaae0a516211ab9250e98748ea56e8bbb67615c07ed5bac1c7f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/seher/releases/download/v0.0.10/sehercode-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2df01ac49d3fb7cb54e6ba339305768a2fe1da8100aaa4ad1d07d419b5849d40"
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
