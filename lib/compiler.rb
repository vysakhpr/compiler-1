require_relative "compiler/version"
require_relative "compiler/scanner"
require_relative "compiler/parser"
require_relative "compiler/semantic"

module Compiler
  if ARGV[0].nil?
    puts "File not Specified";
    exit;
  end
  unless ARGV[0].end_with?(".c")
    puts "Incompatible File";
    exit;
  end

  #---------------------------------------------LEXICAL ANALYSIS-------------------------------------------
  
  mode = "r";
  file = File.open("#{ARGV[0]}", mode);
  words= file.read;
  file.close;
  file = File.open("out.lex","w");
  words=words.split("\n")
  scanner(words,file)
  file.close;
  #p $NUM
  #p $ID
  #---------------------------------------------SYNTACTIC ANALYSIS-----------------------------------------
  
  file = File.open("out.lex","r");
  words= file.read;  
  file.close;
  words=words.split("\n").join(" ");
  words=words+" "
  productions=parser(words);
  #puts productions
  #tree=parse_tree(productions);
  

  #---------------------------------------------SEMANTIC ANALYSIS-------------------------------------------
  semantic(productions)
  


end
