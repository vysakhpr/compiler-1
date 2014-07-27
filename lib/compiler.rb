require_relative "compiler/version"
require_relative "compiler/scanner"
require_relative "compiler/parser"

module Compiler
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

  #---------------------------------------------SYNTACTIC ANALYSIS-----------------------------------------
  
  file = File.open("out.lex","r");
  words= file.read;  
  file.close;
  words=words.split("\n").join(" ");
  words=words+" "
  parser(words);

  #---------------------------------------------SEMANTIC ANALYSIS-------------------------------------------

  


end
