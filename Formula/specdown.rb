class Specdown < Formula
  desc "Use your markdown documentation as tests"
  homepage "https://github.com/specdown/specdown"
  url "https://github.com/specdown/specdown/archive/v0.55.7.tar.gz"
  sha256 "d96b02eceda07b9b7007eb6bebed6d8e391dcbf894c4f24ae5170f7cf4181175"

  bottle do
    root_url "https://github.com/specdown/homebrew-repo/releases/download/specdown-0.55.7"
    sha256 cellar: :any_skip_relocation, catalina:     "c523ac343b7e62afd43dbfefd881aae55cd98b9b23e08d382f92a80c6e16863c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0a9a7a8c199722ed819e2a7a7194921b3ac656e9dd9384269964cc0ca0f28f6a"
  end

  depends_on "rust" => :build

  resource("testdata") do
    url "https://raw.githubusercontent.com/specdown/specdown/v0.55.7/README.md"
    sha256 "a9f658b79fbcb4b13f85cca439cd6e55a2d43a4ad47a05578c28e9c7f88bb8c0"
  end

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "bash")
    (bash_completion/"specdown").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "zsh")
    (zsh_completion/"_specdown").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/specdown", "completion", "fish")
    (fish_completion/"specdown.fish").write output
  end

  test do
    system "#{bin}/specdown", "-h"
    system "#{bin}/specdown", "-V"

    resource("testdata").stage do
      assert_match "5 functions run (5 succeeded / 0 failed)", shell_output("#{bin}/specdown run README.md")
    end
  end
end
