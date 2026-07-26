class WhetstoneTui < Formula
  desc "Whetstone — a friction-first Quarto markdown editor for the terminal"
  homepage "https://sjvrensburg.github.io/whetstone/"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.5/whetstone-tui-aarch64-apple-darwin.tar.xz"
      sha256 "98c4be7febb496db2f69b588087225b341482619d8658b55127a7f65f6827aed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.5/whetstone-tui-x86_64-apple-darwin.tar.xz"
      sha256 "6a5ec1c31edc08c5d9ea4bab5dc413bad805112e49c310fe2741692fbb2102cc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.5/whetstone-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7022c0841d152cf0e370171276b67005f9fe3911d0b6787c312897fbcae7cd30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.5/whetstone-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e397473997dff07f7815815eda6f6f561676714b04b2d6b09591f792c2565f92"
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
