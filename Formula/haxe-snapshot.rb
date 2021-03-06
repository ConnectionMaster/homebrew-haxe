class HaxeSnapshot < Formula
  desc "Multi-platform programming language"
  homepage "http://haxe.org"
  url "https://github.com/HaxeFoundation/haxe.git", :revision => "52fa932adae06421378e2d32aaf693acfb97f9d1"
  version "3.3.0+1SNAPSHOT20160401124437+52fa932"

  head "https://github.com/HaxeFoundation/haxe.git", :branch => "development"

  conflicts_with "haxe", :because => "Differing versions of the same formula."

  depends_on "ocaml" => :build
  depends_on "camlp4" => :build
  depends_on "neko"

  def install
    # Build requires targets to be built in specific order
    ENV.deparallelize
    system "make", "OCAMLOPT=ocamlopt.opt", "ADD_REVISION=1"
    bin.mkpath
    system "make", "install", "INSTALL_BIN_DIR=#{bin}", "INSTALL_LIB_DIR=#{lib}/haxe"

    # Replace the absolute symlink by a relative one,
    # such that binary package created by homebrew will work in non-/usr/local locations.
    rm bin/"haxe"
    bin.install_symlink lib/"haxe/haxe"
  end

  def caveats; <<-EOS.undent
    Add the following line to your .bashrc or equivalent:
      export HAXE_STD_PATH="#{HOMEBREW_PREFIX}/lib/haxe/std"
    EOS
  end

  test do
    ENV["HAXE_STD_PATH"] = "#{HOMEBREW_PREFIX}/lib/haxe/std"
    system "#{bin}/haxe", "-v", "Std"
  end
end
