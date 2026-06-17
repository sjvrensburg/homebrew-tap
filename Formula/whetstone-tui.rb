class WhetstoneTui < Formula
  desc "Whetstone — a friction-first Quarto markdown editor for the terminal"
  homepage "https://sjvrensburg.github.io/whetstone/"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.1/whetstone-tui-aarch64-apple-darwin.tar.xz"
      sha256 "a98b55c3c16ddf01a97be73216e8e9f88cc5f224ba647603bbc27e4666760935"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.1/whetstone-tui-x86_64-apple-darwin.tar.xz"
      sha256 "2132880556abdac390e0452dba352c6351b6be0bfe9e9e8ac80e71bb76a76176"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.1/whetstone-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fa68d3f5f832963b510f93d108ca81f290c7ac39fb2782334d9b98744da4c273"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.1/whetstone-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fae372d2523befdb64da23b842dd8ba4349b1f3beb6c2723b1ecf8c052905203"
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
