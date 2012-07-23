#!/usr/bin/env ruby

require "quickcite"

require "test/unit"

class TestMain < Test::Unit::TestCase
  def test_simple()
  texfile = open("/tmp/test.tex", "w")
  texfile.write <<-END
  This is a test latex file.
I like to cite \\cite{PowerPiccolo}
And \\cite{MapreduceDean}
ANd \\citet{FooBar}
END
  texfile.close

  bibfile = open("/tmp/test.bib", "w")
  bibfile.write("")
  bibfile.close
  
  QuickCite::run(["/tmp/test.tex"], "/tmp/test.bib")
  
  puts("Result: ")
  puts(File.read("/tmp/test.bib"))
  end
end 

class TestCiteToQuery < Test::Unit::TestCase
  def test_simple()
    assert_equal(
      ["Russell", "Power", "Piccolo"],
        QuickCite::cite_to_query("RussellPowerPiccolo"))
    assert_equal(
      ["Piccolo", "2010"],
        QuickCite::cite_to_query("Piccolo2010"))
  end
end
