class Identifier
  @lexeme=""
  @type=""
  @line=""
  def initialize(lexeme,line)
    @lexeme=lexeme
    @line="#{line}/"
  end
  def pos(line)
    @line=@line+line.to_s+"/"
  end
end
class Number
  @value=nil
  @type=""
  @line=nil
  def initialize(value,line)
    @value=value
    @line=line
  end
end
class Literal
  @value=nil
  @line=nil
  def initialize(value,line)
    @value=value
    @line=line
  end
end
def scanner(words,file)
  $ID=[];
  $NUM=[];
  $LIT=[];
  
  #p words
  #Scanning Phase-----------------------------------------------------------------------------------------------------------------------------------------
  
  lexem_id={};
  words.map! do|word|
    if word.include?("\"")
      i=0
      f=0
      temp=[]
      i=0;
      while i<word.length
        if f==0
          unless (word[i] == " ")and(word[i+1]==" ")
            temp<<word[i]
          end
          if word[i]=="\""
            f=1
          end
        else
          temp<<word[i]
          if word[i]=="\""
            unless word[i-1]=="\\"
              f=0
            end
          end
        end
        i=i+1
      end
      word=temp.join()
    else
      word=word.gsub(/[\s]+/," ")
    end 
  end

  #p words
  line=1  
 #LexicalAnazysis Phase-----------------------------------------------------------------------------------------------------------------------------------  
  for word in words
    i=0
    while i<word.length
      peek=word[i]
      unless peek == " "
  #<!---------------- Check for digit ---------------------------!>      

        if !(peek=~/^[0-9]$/).nil?
          v=0
          begin
            v=v*10 + peek.to_i
            i=i+1
            peek=word[i]
          end while !(peek=~/^[0-9]$/).nil?
          ob=Number.new(v,line)
          #file.puts "token <num,#{ob}>"
          file.puts "num"
          $NUM<<ob
          next
        end
  #<!---------------- Check for Identifier/Keyword ------------------------------!> 

        if !(peek=~/^[A-Za-z]$/).nil?
          b=""
          begin
            b=b+peek
            i=i+1
            peek=word[i]
          end while !(peek=~/^[A-Za-z0-9]$/).nil? 
            keyword=["int","float","char","double","long","short","signed","unsigned","void","main","printf"];
          if keyword.include?(b)
            #file.puts "token <#{b}>"
            file.puts "#{b}"
          else
            if lexem_id[b].nil?
              ob=Identifier.new(b,line)
              lexem_id[b]=ob
            else
              ob=lexem_id[b]
              ob.pos(line)
             end 
            $ID<<ob
            #file.puts "token <id,#{ob}>"
            file.puts "id"
          end
          next
        end
  #<!---------------- Check for Operator ------------------------------------!>

        if !(peek =~ /^[()+-;.=,\*\/\[\]{}%]$/).nil?
          #file.puts "token <#{peek}>"
          file.puts "#{peek}"
        end
        
  #<!---------------- String Literal -------------------------------------------!>

        if peek == "\""
          b=""
          while(1)
            b=b+peek
            i=i+1
            peek=word[i]
            if peek =="\""
              unless word[i-1]=="\\"
                b=b+peek
                break
              end
            end
          end
          ob=Literal.new(b,line)
          #file.puts "token <lit,#{ob}>"
          file.puts "string"
          $LIT<<ob
          i=i+1
          next
        end

      end
      i=i+1
    end
    line=line+1
  end
end