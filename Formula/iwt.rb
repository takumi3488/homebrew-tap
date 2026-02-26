class Iwt < Formula
  desc "Interactive CLI for managing git worktrees"
  homepage "https://github.com/takumi3488/interactive-worktree"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.8/interactive-worktree-aarch64-apple-darwin.tar.xz"
      sha256 "8fb277670813ed47594511a82a30846f58f6551bb324e8e3ca54b24da9e90b0a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.8/interactive-worktree-x86_64-apple-darwin.tar.xz"
      sha256 "4369e6e0e740463eb8aa6096c3a96c409a4e7e1d0883620a18d3d0b57793c86c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/takumi3488/interactive-worktree/releases/download/v0.1.8/interactive-worktree-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "80550f900c1a5d3541c60d4347b692e331ea91396df288d18ded283ac13d53e9"
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
