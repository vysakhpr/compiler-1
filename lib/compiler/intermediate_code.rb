def printbuffer(production)
    literal=$LIT.dup
    for x in production
        if x.include? " string "
            l=literal.shift
            if x.include? " printf "
                $PRINTBUFF<<l
            end
        end
    end
end

def intergen(production)
	number=$NUM.dup
    identifier=$ID.dup
    inter_code=Array.new
    temp=Array.new
    print_var=Array.new
    #fact_value=Array.new
    #term_value=Array.new
    #expr_value=Array.new
    printbuffer(production)
    temp_count=0
	for x in production
        case x
        when "NAME-> main "
            temp_count=0;
        when "FNAME-> NAME ( ) "
            
        when "DATATYPE-> char "
            
        when "DATATYPE-> void "
            
        when "DATATYPE-> int "

        when "DATATYPE-> float " 
            
        when "IDS-> id "
            id_object=identifier.shift
            print_var.push(id_object)
        when "IDS-> ID , IDS "
            
        when "STMT-> DATATYPE IDS "
            print_var=[]
        when "ID-> id "
        	id_object=identifier.shift
            print_var.push(id_object)
        when "FACTOR-> num "
            num_object=number.shift
            inter_code<< "_t#{temp_count}=#{num_object.value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
            #fact_value.push(num_object.value)
        when "FACTOR-> id "
            ids_object=identifier.shift;
            inter_code<< "_t#{temp_count}=#{ids_object.lex_value}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
            #fact_value.push(ids_object.lex_value);
        when "TERM-> FACTOR "
            #term_value.push(fact_value.pop)
        when "EXPR-> TERM "
            #expr_value.push(term_value.pop)
        when "EXPR-> EXPR + TERM "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}+#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "EXPR-> EXPR - TERM "           
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}-#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "TERM-> TERM / FACTOR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}*#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "TERM-> TERM * FACTOR "
            t1=temp.pop
            t0=temp.pop
            inter_code<< "_t#{temp_count}=#{t0}/#{t1}";
            temp.push("_t#{temp_count}");
            temp_count=temp_count+1;
        when "FACTOR-> ( EXPR ) "
        	fact_value.push(expr_value.pop)
        when "STMT-> ID = EXPR "
        	id_lexeme=id_object.lex_value
            inter_code<< "#{id_lexeme}=#{temp.pop}";
            temp_count=0;
            print_var=[]
        when "STMT-> printf ( string , IDS ) "
            string=$PRINTBUFF.shift.lit_value
            string_array=string.split(/%[dcfu]/)
            format=string.scan(/%[dcfu]/)
            length=string_array.length
            inter_code<<"_printString_ #{string_array[0]}\""
            for i in  (1..length-1)
                object=print_var.shift
                case format.pop
                when "%d"
                    inter_code<<"_printInteger_ #{object.value}" if object.is_number?
                    inter_code<<"_printInteger_ #{object.lex_value}" if object.is_id?
                when "%f"
                    inter_code<<"_printFloat_ #{object.value}" if object.is_number?
                    inter_code<<"_printFloat_ #{object.lex_value}" if object.is_id?
                when "%c"
                    inter_code<<"_printChar_ #{object.value}" if object.is_number?
                    inter_code<<"_printChar_ #{object.lex_value}" if object.is_id?
                end
                inter_code<<"_printString_ \"#{string_array[i]}\"" if i!=length-1
                inter_code<<"_printString_ \"#{string_array[i]}" if i==length-1
            end
        when "STMT-> printf ( string ) "
            inter_code<<"_printString_ #{$PRINTBUFF.shift.lit_value}"
        end
    end 
    return inter_code   
end
