class Iwt < Formula
  desc "Interactive CLI for managing git worktrees"
  homepage "https://github.com/smartcrabai/interactive-worktree"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/interactive-worktree/releases/download/v0.1.9/interactive-worktree-aarch64-apple-darwin.tar.xz"
      sha256 "ea17767f0193ab6829421c260b60c514bad369d68148fdfa64150fb0ac73e75d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/interactive-worktree/releases/download/v0.1.9/interactive-worktree-x86_64-apple-darwin.tar.xz"
      sha256 "c62c882495f290499c4f595a4da5d8faf635edbd6bbe071ec614da0438e76342"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/smartcrabai/interactive-worktree/releases/download/v0.1.9/interactive-worktree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a880aba0b1d4ac3ec78674131af5c399dc337ce7c74a1d5b3826a2354529be10"
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
