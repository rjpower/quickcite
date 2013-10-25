require "optparse"

Flags = Struct.new(:bibtex, :latex, :dryrun) do
  def initialize()
    @bibtex = nil
    @latex = nil
    @dryrun = false
  end

  def parse!
    optparse = OptionParser.new do|opts|
     opts.banner = "Usage: quickrite -b <bibtex file> latex1 latex2 ... "
  
     opts.on( "-b", "--bibtex FILE", "Extract/generate references to FILE" ) do|file|
       self.bibtex = file
     end
     
     opts.on("-n", "--dry-run", "Don't fetch or update bibtex." ) do|opt|
       self.dryrun = opt
     end
    end
    optparse.parse!
    
    self.latex = ARGV
  end
end

FLAGS = Flags.new