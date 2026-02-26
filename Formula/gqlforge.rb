class Gqlforge < Formula
  desc "A high-performance GraphQL runtime"
  homepage "https://gqlforge.pages.dev"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/gqlforge/releases/download/v0.1.3/gqlforge-aarch64-apple-darwin.tar.xz"
      sha256 "e442125db0a8d673f860f4057c9ca15fefe4dc7f353e4611d72b20a1e5fda5bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/gqlforge/releases/download/v0.1.3/gqlforge-x86_64-apple-darwin.tar.xz"
      sha256 "3ab0709106142e362afc2f0b210c4f01192c19a53a932787107483ada87db72b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/gqlforge/releases/download/v0.1.3/gqlforge-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e2fc2d0ad84fbe4bd096a8153dc3aac465488032eed58627aa8b0fa3a0d39f6e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/gqlforge/releases/download/v0.1.3/gqlforge-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c32f5d7fe21ff358ce39e68b6bc8c129329db8a74b71da98c1acd77daf6923c2"
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
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.mac? && Hardware::CPU.intel?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.arm?
    bin.install "gqlforge" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
