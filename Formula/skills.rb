class Skills < Formula
  desc "CLI for installing and managing agent skills (SKILL.md collections) across local development tooling"
  homepage "https://github.com/smartcrabai/skills"
  version "0.1.5"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/skills/releases/download/v0.1.5/skills-aarch64-apple-darwin.tar.xz"
    sha256 "c6c4f8f6c940fef1b43367baa09c4288b14ec7497a5f05277a3db67eb52356c0"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.5/skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d3eef32adbc6a8f887f128f59f4a5810e32cd54e9aeedeb80826a08e546e3b0f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.5/skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b4aa27cc672025bf8db97eccf278da17c72d459be4e70bbc3b697f961a571c6e"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "skills" if OS.mac? && Hardware::CPU.arm?
    bin.install "skills" if OS.linux? && Hardware::CPU.arm?
    bin.install "skills" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
