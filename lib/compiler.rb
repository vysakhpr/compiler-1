require_relative "compiler/version"
require_relative "compiler/symbol_tables"
require_relative "compiler/scanner"
require_relative "compiler/parser"
require_relative "compiler/semantic_analyzer"
require_relative "compiler/intermediate_code"

module Compiler
  if ARGV[0].nil?
    puts "File not Specified";
    exit;
  end
  unless ARGV[0].end_with?(".c")
    puts "Incompatible File";
    exit;
  end

  #---------------------------------------------LEXICAL-ANALYSIS-------------------------------------------
  
  mode = "r";
  file = File.open("#{ARGV[0]}", mode);
  words= file.read;
  file.close;
  words=words.split("\n")
  tokens=scanner(words)
  #p token
  #p $NUM
  #p $ID
  #---------------------------------------------SYNTACTIC-ANALYSIS-----------------------------------------
  
  tokens=tokens.split("\n").join(" ");
  tokens=tokens+" "
  productions=parser(tokens);
  #puts productions
  #tree=parse_tree(productions);

  #---------------------------------------------SEMANTIC-ANALYSIS-------------------------------------------
  semantic(productions)
  #----------------------------------------INTERMEDIATE-CODE-GENERATION-------------------------------------
  intermediate_code=intergen(productions)
  puts intermediate_code
  #---------------------------------------------CODE OPTIMIZATION-------------------------------------------

  #----------------------------------------------CODE GENERATION--------------------------------------------
  

end
