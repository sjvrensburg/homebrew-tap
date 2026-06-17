class WhetstoneTui < Formula
  desc "Whetstone — a friction-first Quarto markdown editor for the terminal"
  homepage "https://sjvrensburg.github.io/whetstone/"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.0/whetstone-tui-aarch64-apple-darwin.tar.xz"
      sha256 "632398c27fd39c5b8047a48c3573d74c8b64569ddf68d4081b097fa042a7206e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.0/whetstone-tui-x86_64-apple-darwin.tar.xz"
      sha256 "a53e913121debe238fb5876365446d5b67e2622b92006591d2344f7c38536a6a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.0/whetstone-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8f3fa496098c1407e4bf1bd5cee913a41943157a32762354572d2c04581e8df0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.0/whetstone-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "68fef54a92d3c43befd1a066c9c0bd6fc19fae8a67194aca50dca698f15e3305"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
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
    bin.install "whetstone-tui" if OS.mac? && Hardware::CPU.arm?
    bin.install "whetstone-tui" if OS.mac? && Hardware::CPU.intel?
    bin.install "whetstone-tui" if OS.linux? && Hardware::CPU.arm?
    bin.install "whetstone-tui" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
