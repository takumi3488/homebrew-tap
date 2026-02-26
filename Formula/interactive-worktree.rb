class InteractiveWorktree < Formula
  desc "Interactive CLI for managing git worktrees"
  homepage "https://github.com/takumi3488/interactive-worktree"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.7/interactive-worktree-aarch64-apple-darwin.tar.xz"
      sha256 "3bd93067222b4aee77ada6aaa9d9915d0ac3f6e218a581c2ce0ba9d1f01c4f82"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.7/interactive-worktree-x86_64-apple-darwin.tar.xz"
      sha256 "b2c3a804976bb078f3979711ad3c03762c531efd050e34209ba771bce018e8be"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.7/interactive-worktree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3296d1aed94532b305b0876054b6add20639de27d832e9338aec5623c3585499"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "iwt" if OS.mac? && Hardware::CPU.arm?
    bin.install "iwt" if OS.mac? && Hardware::CPU.intel?
    bin.install "iwt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
