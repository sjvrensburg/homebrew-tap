class WhetstoneTui < Formula
  desc "Whetstone — a friction-first Quarto markdown editor for the terminal"
  homepage "https://sjvrensburg.github.io/whetstone/"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.6/whetstone-tui-aarch64-apple-darwin.tar.xz"
      sha256 "e3be82871510e4101148f069451fac5d5f8ab7665d822f9286aa348948d508c4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.6/whetstone-tui-x86_64-apple-darwin.tar.xz"
      sha256 "6bba062e8c11421b44d8a93ef7c872ec8ed6aa6def3330977f124bb0ced44824"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.6/whetstone-tui-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "96ebc23e348d6c61f9a6bc59c2ca198bd0a53ef73b3bd606ae28f7a1d006d713"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sjvrensburg/whetstone/releases/download/v0.1.6/whetstone-tui-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f1ac0178546787b52839d0d45852722552301376a1b29b15a6105b2b28bc8776"
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
