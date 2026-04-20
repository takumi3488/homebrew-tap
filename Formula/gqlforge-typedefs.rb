class GqlforgeTypedefs < Formula
  desc "The gqlforge-typedefs application"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-typedefs-aarch64-apple-darwin.tar.xz"
      sha256 "ead4e2df595afb54c103ea67273b849a0e816f9dee74d19de449aa6df0f08234"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-typedefs-x86_64-apple-darwin.tar.xz"
      sha256 "2bed093956a8074af7b0e11d358da560bebbb4437d8a637a302e25d4f16b8e75"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-typedefs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d5bc13119341bd1ffcac7bc1c02ff14ab653eeb8d599a6a167290a7a3a4b05b4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/gqlforge/releases/download/v0.1.5/gqlforge-typedefs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e766c03f8d5c116b7b0d1398d8845b3b41010d675dda6ca0b3adcdec401eb7ae"
    end
  end

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
    bin.install "gqlforge-typedefs" if OS.mac? && Hardware::CPU.arm?
    bin.install "gqlforge-typedefs" if OS.mac? && Hardware::CPU.intel?
    bin.install "gqlforge-typedefs" if OS.linux? && Hardware::CPU.arm?
    bin.install "gqlforge-typedefs" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
