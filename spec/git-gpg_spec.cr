require "yaml"
require "./spec_helper"

describe GitGPG do
  git_gpg = "#{__DIR__}/../bin/git-gpg"

  it "responds to .main" do
    GitGPG.responds_to?(:main).should be_true
  end
  it "responds to .version" do
    GitGPG.responds_to?(:version).should be_true
  end
  it "responds to .verbosity" do
    GitGPG.responds_to?(:verbosity).should be_true
  end

  context "version" do
    shard = begin
      shard_yml = "#{__DIR__}/../shard.yml"
      YAML.parse(File.read(shard_yml))
    end

    it "is returned by .version" do
      GitGPG.version.should eq(shard["version"])
    end
    it "is shown by -v" do
      `#{git_gpg} -v`.strip.should eq(shard["version"])
      $?.success?.should be_true
    end
    it "is shown by using --version" do
      `#{git_gpg} --version`.strip.should eq(shard["version"])
      $?.success?.should be_true
    end
  end

  context "help" do
    it "is shown by -?" do
      `#{git_gpg} -?`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
    it "is shown by --help" do
      `#{git_gpg} --help`.should start_with("Usage: git-gpg ")
      $?.success?.should be_true
    end
  end

  context ".verbosity" do
    it "defaults to NORMAL" do
      GitGPG.verbosity.should eq(GitGPG::Verbosity::Normal)
    end
  end

  context "with invalid option" do
    option = "--invalid-option"
    it "shows error message" do
      `#{git_gpg} #{option} 2>&1 >/dev/null`.should start_with("ERROR: ")
      $?.success?.should be_false
    end
    it "shows help message" do
      `#{git_gpg} #{option} 2>/dev/null`.should start_with("\nUsage: git-gpg ")
      $?.success?.should be_false
    end
  end

  context "with invalid option in quiet mode" do
    option = "--invalid-option --quiet"
    it "shows error message" do
      `#{git_gpg} #{option} 2>&1 >/dev/null`.should start_with("ERROR: ")
      $?.success?.should be_false
    end
    it "does not show help" do
      `#{git_gpg} #{option} 2>/dev/null`.should be_empty
      $?.success?.should be_false
    end
  end
end
