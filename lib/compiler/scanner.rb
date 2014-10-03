def scanner(words)
  token=""
  delim=0                                                                 #
  paran=0 
  e=0  
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
 #LexicalAnalysis Phase-----------------------------------------------------------------------------------------------------------------------------------  
  for word in words
    i=0
    while i<word.length
      peek=word[i]
      unless peek == " " or peek == "\t"  
  #<!---------------- Check for digit ---------------------------!>      

        if !(peek=~/^[0-9]$/).nil?
          v=0
          begin
            v=v*10 + peek.to_i
            i=i+1
            peek=word[i]
          end while !(peek=~/^[0-9]$/).nil?
          if peek == '.'                                                            #
            x=v
            d=10
            while(1)
              i=i+1
              peek=word[i]
              if (peek=~/^[0-9]$/).nil?
                break
              end
              x=x+(peek.to_f/d);
              d=d*10
            end
            ob=Number.new(x,"%f",line)
          else
            ob=Number.new(v,"%d",line)          
          end
          token=token+"num\n"
          $NUM<<ob
          next
        #end
  #<!---------------- Check for Identifier/Keyword ------------------------------!> 

        elsif !(peek=~/^[A-Za-z]$/).nil?
          b=""
          begin
            b=b+peek
            i=i+1
            peek=word[i]
          end while !(peek=~/^[A-Za-z0-9]$/).nil? 
            keyword=["int","float","char","double","long","short","signed","unsigned","void","main","printf"];
          if keyword.include?(b)
            #indent=b          
            token=token+"#{b}\n"
          else
            if lexem_id[b].nil?
              ob=Identifier.new(b,line)
              lexem_id[b]=ob
            else
              ob=lexem_id[b]
              ob.pos(line)
             end 
            $ID<<ob
            token=token+"id\n"
          end
          next
        #end
  #<!---------------- Check for Operator ------------------------------------!>

        elsif !(peek =~ /^[()+-;.=,\*\/\[\]{}%]$/).nil?
          if peek=="{"                                                    #
            delim=delim+1
          elsif peek=="}"
            delim=delim-1
          elsif peek=="("
            paran=paran+1
          elsif peek==")"
            paran=paran-1
          end
          token=token+"#{peek}\n"
        #end
        
  #<!---------------- String Literal -------------------------------------------!>

        elsif peek == "\""
          m=word.count "\""                                            #
          n=word.scan(/\\\"/).count                                    #
          if (m-n)%2 !=0                                               #
            puts "Lexical Error:Line number #{line}: expected \" "     #
            e=1                                                       # 
          end                                                          #
          b=""
          while(e!=1)
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
          token=token+"string\n"
          $LIT<<ob
          i=i+1
          next
        #end
  #<!----------------Panic Mode ------------------------------------------------!>

        else
          i=i+1
        end  


      end
      i=i+1
    end
    line=line+1
  end
  if delim != 0                                                                         #
    puts "Lexical Error: Line number #{line} :Unmatched Delimiters" ;
    e=1
  end
  if paran != 0
    puts "Lexical Error: Line number #{line} :Unmatched Paranthesis" ;
    e=1
  end
  if e==1
    exit
  end
  return token
end