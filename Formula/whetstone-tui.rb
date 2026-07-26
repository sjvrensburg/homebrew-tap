class WhetstoneTui < Formula
  desc "Whetstone — a friction-first Quarto markdown editor for the terminal"
  homepage "https://sjvrensburg.github.io/whetstone/"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.4/whetstone-tui-aarch64-apple-darwin.tar.xz"
      sha256 "915bf5de14ab131cd8e4811f5dfbc57e3381bdc8e3d2d07950a59e2f8984758c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.4/whetstone-tui-x86_64-apple-darwin.tar.xz"
      sha256 "859b8569683e32c13c15d49f48ab8c7eb3eb0018bc792a5c88b62d3d2b4e830e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.4/whetstone-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6664e212ec62198b0f3c39b35211f68943a703e9bec56d941c1517bdb226e5a1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.4/whetstone-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "62f91a80a6908a91dc5eab49c8833068367720d6e12867418a2d949cde0e418d"
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
