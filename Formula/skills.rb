class Skills < Formula
  desc "CLI for installing and managing agent skills (SKILL.md collections) across local development tooling"
  homepage "https://github.com/smartcrabai/skills"
  version "0.1.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/smartcrabai/skills/releases/download/v0.1.2/skills-aarch64-apple-darwin.tar.xz"
    sha256 "c0a5e175d71d9d7e28534ae2d91e254d18914b1415ac6e8957ca6e96a52d5b1f"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.2/skills-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dbacff3e8acbdf57384bf2162c78be797edfaa7d9d2d900d3f26ce87f53db349"
    end
    if Hardware::CPU.intel?
      url "https://github.com/smartcrabai/skills/releases/download/v0.1.2/skills-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "05ac6fce1ffc727eeffc5834bcf66592e8810a52029d531ae0d7a25a3d077c6a"
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
