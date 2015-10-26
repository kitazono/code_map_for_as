require "gviz"
require './cl.tab.rb'
require "./rpg_line"

$gv = Gviz.new

def read_file(directory_name)

  Dir.open(directory_name) {|dir|
    Dir.chdir(directory_name)

    dir.each {|file|
      next if file == "." || file == ".." || file == ".DS_Store"
      open(file) {|f|
        yield f
      }
    }
  }
end

class InterPreter

  def initialize(file_name)
    @file_name = file_name
    begin
      tree = nil
      File.open(@file_name) {|file| tree = ClParser.new.parse(file, @file_name)}
    rescue Racc::ParseError, Errno::ENOENT
      $stderr.puts "#{$0}: #{$!}"
      exit 1
    end
  end
end

def analysis_cl(directory_name)

  read_file(directory_name) do |f|
    p f.path
    InterPreter.new(f.path)
  end

end

def analysis_rpg(directory_name)

  read_file(directory_name) do |f|
    while line = f.gets
      l = RpgLine.new(line)
      if l.specificationType == "C" && !(l.isComment) && l.operation == "CALL"
        puts "#{f.path.gsub(".txt", "")} -> #{l.factor2.gsub("'", "")}"
        $gv.add  f.path.gsub(".txt", "") => l.factor2.gsub("'", "").strip
      end
    end
  end
end

analysis_cl(ARGV[0])
analysis_rpg(ARGV[1])

$gv.save :sample, :png
