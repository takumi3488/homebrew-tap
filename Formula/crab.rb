class Crab < Formula
  desc "CLI binary for SmartCrab workflow orchestration engine"
  homepage "https://github.com/takumi3488/smartcrab"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/takumi3488/smartcrab/releases/download/v0.1.3/smartcrab-cli-aarch64-apple-darwin.tar.xz"
      sha256 "788969d63f61db0e9b133847f017d2b706435db04f61728cae8a6b30f417f363"
    end
    if Hardware::CPU.intel?
      url "https://github.com/takumi3488/smartcrab/releases/download/v0.1.3/smartcrab-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ac7eda09936377dbbd7b8858b8b0276e8daed607986171f3baf2b3dcc7ed0a19"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/takumi3488/smartcrab/releases/download/v0.1.3/smartcrab-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "42f6f7e28a2459d7dfbca12ab698cfe24e55e3ab1e9dda5e977e6c328cb9c6ff"
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "crab" if OS.mac? && Hardware::CPU.arm?
    bin.install "crab" if OS.mac? && Hardware::CPU.intel?
    bin.install "crab" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
