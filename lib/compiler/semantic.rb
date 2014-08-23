def semantic(production)
    number=$NUM.dup
    literal=$LIT.dup
    identifier=$ID.dup
    for x in production
        case x
        when "NAME-> main "
            c=0;
            inter_code=Array.new;                                                   
            name='main';
            ids_lexeme=Array.new;
            ids_lexeme1=Array.new;
           datatype_stack=Array.new;
            temp_count=0;
        when "FNAME-> NAME ( ) "
            fname=name+'()';
        when "DATATYPE-> char "
            datatype='char';
        when "DATATYPE-> void "
            datatype='void';
        when "DATATYPE-> int "
            datatype='int';
        when "IDS-> id "
            ids_object=identifier.shift;
            ids_object.inc_count; 
            if datatype
                ids_type=datatype;
            else
                c=c+1;
            end
            ids_lexeme.push(ids_object.lex_value);
        when "IDS-> ID , IDS "
            ids_object=datatype_stack.pop();                                        
            if datatype
                ids_type=datatype;
            else
                c=c+1;
            end
            ids_lexeme.push(ids_object.lex_value);
        when "STMT-> DATATYPE IDS "
            for lx  in ids_lexeme
             if !ids_lexeme1.include?(lx)
               if h=$ID.find_all{|h| h.lex_value==lx}
                  for i in h
                    i.type_assign(datatype);
                  end
               end
             else
                 if h=identifier.find_all{|h| h.lex_value==lx}
                  for i in h
                    i.type_assign(datatype);
                  end
                 end
                print 'ERROR:double decleration on line ';
                print line(lx,identifier);
                print '\n';
             end
            end
            ids_lexeme1=ids_lexeme1+ids_lexeme;
            ids_lexeme=[];
            datatype=nil;
            when "ID-> id "
            id_object=identifier.shift;
            id_object.inc_count;                                                   
            datatype_stack.push(id_object);
        when "FACTOR-> num "
            num_object=number.shift;
            fact_type=num_object.type_value;
            fact_value=num_object.value;
            fact_line=num_object.line_value;
        when "FACTOR-> id "
            ids_object=identifier.shift;
            ids_object.inc_count;                                                   
            fact_type=ids_object.type_value;
            fact_value=ids_object.lex_value;
            fact_line=ids_object.line_value;
        when "TERM-> FACTOR "
            term_type=fact_type;
            term_value=fact_value;
            term_line=fact_line;
        when "EXPR-> TERM "
            expr_type=term_type;
            expr_value=term_value;
            expr_line=term_line;
        when "EXPR-> EXPR + TERM "
            if expr_type!=term_type && expr_type !=''&&term_type!=''
             print 'ERROR:type missmatch on line ';
             print line(expr_value,identifier);
             print '\n';
            end
            if expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declered on line ';
                print line(expr_value,identifier);
                print ' \n';
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declered on line ';
                print line(term_value,identifier);
                print ' \n';
            end
            inter_code<< "_t#{temp_count}=#{expr_value}+#{term_value}";
            expr_value="_t#{temp_count}";
            temp_count=temp_count+1;
        when "EXPR-> EXPR - TERM "
            if expr_type!=term_type && expr_type !=''&&term_type!=''
             print 'ERROR:type missmatch on line ';
             print line(expr_value,identifier);
             print '\n';
            end
            if expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declered on line ';
                print line(expr_value,identifier);
                print ' \n';
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declared on line ';
                print line(term_value,identifier);
                print ' \n';
            end
            inter_code<< "_t#{temp_count}=#{expr_value}-#{term_value}";
            expr_value="_t#{temp_count}";
            temp_count=temp_count+1;
        when "STMT-> ID = EXPR "
            id_object=datatype_stack.pop;
            id_type=id_object.type_value;
            id_lexeme=id_object.lex_value;
            id_line=id_object.line_value;
            if id_type!=expr_type && id_type!=''&& expr_type!=''
                print 'ERROR: type mismatch on line ';
                print line(id_lexeme,identifier);
                print '\n';
            elsif id_type==''
                print 'ERROR: ';
                print ' not declared on line';
                print line(id_lexeme,identifier);
                print  ' \n';
            elsif  expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declared ';
                print line(expr_value,identifier);
                print  ' \n';
            end
            inter_code<< "#{id_lexeme}=_t#{temp_count-1}";
            temp_count=0;
        when "STMT-> printf ( string , IDS ) "
            string=literal.shift;
            count_ids=(string.lit_value).scan(/%[dfcu]/).count;
            if count_ids!=c
                 print 'ERROR:parameter number mismatched on line ';
                 print  string.line_value;
                 print  'for printf(...)'
                 print '\n';
            end
        end
    end
    return inter_code    
end
def line(lexeme,identifier)
    if k=$ID.find{|k| k.lex_value==lexeme}
    	cntr=k.counter_value;
    	lines=k.line_value;
        line_array=lines.split('/');
    end
    	return line_array[cntr-1];
end