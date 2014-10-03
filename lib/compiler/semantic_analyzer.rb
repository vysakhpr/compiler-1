def type_infer(type1,type2)
    type=type1
    infer_table=["%d","%f"]
    unless type1==type2
        if type1=="%c" or type2=="%c"
            return -1
        end
        if infer_table.index(type2)>infer_table.index(type1)
            type=type2
        end
    end
    return type
end

def semantic(production)
    number=$NUM.dup
    literal=$LIT.dup
    identifier=$ID.dup
    c=0
    ob_stack=Array.new
    for x in production
        case x
        when "NAME-> main "
            c=0;                                                  
            name='main';
            ids_lexeme=Array.new;
            ids_lexeme1=Array.new;
           datatype_stack=Array.new;
           datatype_stack_dup=Array.new;
            temp_count=0;
        when "FNAME-> NAME ( ) "
            fname=name+'()';
        when "DATATYPE-> char "
            datatype='%c';
        when "DATATYPE-> void "
            datatype='void';
        when "DATATYPE-> int "
            datatype='%d';
        when "DATATYPE-> float "
            datatype='%f';    
        when "IDS-> id "
            ids_object=identifier.shift;
            ids_object.inc_count; 
            datatype_stack_dup.push(ids_object);
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
                print 'ERROR:double declaration on line ';
                print line(lx,identifier);
                print "\n";
             end
            end
            ids_lexeme1=ids_lexeme1+ids_lexeme;
            ids_lexeme=[];
            datatype=nil;
            c=0
        when "ID-> id "
            id_object=identifier.shift;
            id_object.inc_count;                                                   
            datatype_stack.push(id_object);
            datatype_stack_dup.push(id_object);
        when "FACTOR-> num "
            num_object=number.shift;
            ob_stack.push(num_object)
            #fact_type=num_object.type_value;
            #fact_value=num_object.value;
            #fact_line=num_object.line_value;
        when "FACTOR-> id "
            ids_object=identifier.shift;
            ids_object.inc_count; 
            ob_stack.push(ids_object)                                                  
            #fact_type=ids_object.type_value;
            #fact_value=ids_object.lex_value;
            #fact_line=ids_object.line_value;
        when "TERM-> FACTOR "
            #term_type=fact_type;
            #term_value=fact_value;
            #term_line=fact_line;
        when "TERM-> TERM * FACTOR "
            e=0
            t1=ob_stack.pop
            t0=ob_stack.pop
            term_type=t0.type_value
            fact_type=t1.type_value
            if t0.is_id?
                term_value=t0.lex_value
            else
                term_value=t0.value
            end
            if t1.is_id?
                fact_value=t1.lex_value
            else
                fact_value=t1.value
            end
            if fact_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declared on line ';
                print line(fact_value,identifier);
                print "\n";
                e=1;
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declared on line ';
                print line(term_value,identifier);
                print "\n";
                e=1;
            end
            if x=$ID.find{ |x| x.lex_value==fact_value }
                if x.value.nil?
                    print "ERROR:Variable #{fact_value} not initialized on line "
                    print line(fact_value,identifier);
                    print "\n"
                    e=1
                end
            end
            if x=$ID.find{ |x| x.lex_value==term_value }
                if x.value.nil?
                    print "ERROR:Variable #{term_value} not initialized on line "
                    print line(term_value,identifier);
                    print "\n"
                    e=1
                end
            end
            t=type_infer(term_type,fact_type)
            if t==-1
                e=1
                print "ERROR:cannot convert character to integer on line "
                print line(term_value,identifier);
                print "\n";
            else
                term_type=t
            end
            if e==1
                exit
            end
            if fact_value&&term_value
                if t1.is_id?
                    f=t1.value
                else
                    f=fact_value
                end
                if t0.is_id?
                    t=t0.value
                else
                    t=term_value
                end
                #puts "HaHa"
                #p e
                #p t
                term_value=t*f
            end
            t0=Identifier.new(nil,nil)
            t0.temp_init(term_type,term_value)
            #p expr_type
            #p t0
            ob_stack.push(t0)
        when "TERM-> TERM / FACTOR "
            e=0
            t1=ob_stack.pop
            t0=ob_stack.pop
            term_type=t0.type_value
            fact_type=t1.type_value
            if t0.is_id?
                term_value=t0.lex_value
            else
                term_value=t0.value
            end
            if t1.is_id?
                fact_value=t1.lex_value
            else
                fact_value=t1.value
            end
            if fact_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declared on line ';
                print line(fact_value,identifier);
                print "\n";
                e=1;
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declared on line ';
                print line(term_value,identifier);
                print "\n";
                e=1;
            end
            if x=$ID.find{ |x| x.lex_value==fact_value }
                if x.value.nil?
                    print "ERROR:Variable #{fact_value} not initialized on line "
                    print line(fact_value,identifier);
                    print "\n"
                    e=1
                end
            end
            if x=$ID.find{ |x| x.lex_value==term_value }
                if x.value.nil?
                    print "ERROR:Variable #{term_value} not initialized on line "
                    print line(expr_value,identifier);
                    print "\n"
                    e=1
                end
            end
            t=type_infer(term_type,fact_type)
            if t==-1
                print "ERROR:cannot convert character to integer on line "
                print line(term_value,identifier);
                print "\n";
                e=1
            else
                term_type=t
            end
            if e==1
                exit
            end
            if fact_value&&term_value
                if t1.is_id?
                    f=t1.value
                else
                    f=fact_value
                end
                if t0.is_id?
                    t=t0.value
                else
                    t=term_value
                end
                #puts "HaHa"
                #p e
                #p t
                term_value=t/f
            end
            t0=Identifier.new(nil,nil)
            t0.temp_init(term_type,term_value)
            #p expr_type
            #p t0
            ob_stack.push(t0)
        when "EXPR-> TERM "
            #expr_type=term_type;
            #expr_value=term_value;
            #expr_line=term_line;
        when "EXPR-> EXPR + TERM "
            e=0
            t1=ob_stack.pop
            t0=ob_stack.pop
            #p t0
            expr_type=t0.type_value
            if t0.is_id?
                expr_value=t0.lex_value
            else
                expr_value=t0.value
            end
            term_type=t1.type_value
            if t1.is_id?
                term_value=t1.lex_value
            else
                term_value=t1.value
            end
            if expr_type!=term_type && expr_type !=''&&term_type!=''
             print 'ERROR:type mismatch on line ';
             print line(expr_value,identifier);
             print "\n";
            end
            if x=$ID.find{ |x| x.lex_value==expr_value }
                if x.value.nil?
                    print "ERROR:Variable #{expr_value} not initialized on line "
                    print line(expr_value,identifier);
                    print "\n"
                    e=1
                end
            end 
            if x=$ID.find{ |x| x.lex_value==term_value }
                if x.value.nil?
                    print "ERROR:Variable #{term_value} not initialized on line "
                    print line(expr_value,identifier);
                    print "\n"
                    e=1
                end
            end
            if expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declared on line ';
                print line(expr_value,identifier);
                print "\n";
                e=1;
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declared on line ';
                print line(term_value,identifier);
                print "\n";
                e=1;
            end
            if e==1
                exit
            end
            if expr_value&&term_value
                if t1.is_id?
                    t=t1.value
                else
                    t=expr_value
                end
                if t0.is_id?
                    e=t0.value
                else
                    e=expr_value
                end
                #puts "HaHa"
                #p e
                #p t
                expr_value=e+t
            end

            t0=Identifier.new(nil,nil)
            t0.temp_init(expr_type,expr_value)
            #p expr_type
            #p t0
            ob_stack.push(t0)
        when "EXPR-> EXPR - TERM "
            e=0;
            t1=ob_stack.pop
            t0=ob_stack.pop
            expr_type=t0.type_value
            if t0.is_id?
                expr_value=t0.lex_value
            else
                expr_value=t0.value
            end
            term_type=t1.type_value
            if t1.is_id?
                term_value=t1.lex_value
            else
                term_value=t1.value
            end
            if expr_type!=term_type && expr_type !=''&&term_type!=''
             print 'ERROR:type mismatch on line ';
             print line(term_value,identifier);
             print "\n";
            end
            if x=$ID.find{ |x| x.lex_value==expr_value }
                if x.value.nil?
                    print "ERROR:Variable #{expr_value} not initialized on line "
                    print line(expr_value,identifier);
                    print "\n"
                    e=1
                end
            end
            if x=$ID.find{ |x| x.lex_value==term_value }
                if x.value.nil?
                    print "ERROR:Variable #{term_value} not initialized on line "
                    print line(term_value,identifier);
                    print "\n"
                    e=1
                end
            end
            if expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declered on line ';
                print line(expr_value,identifier);
                print "\n";
                e=1;
            end
            if term_type==''
                print 'ERROR: ';
                print term_value;
                print ' not declared on line ';
                print line(term_value,identifier);
                print "\n";
                e=1;
            end
            if e==1
                exit
            end
            if expr_value&&term_value
                if t1.is_id?
                    t=t1.value
                else
                    t=expr_value
                end
                if t0.is_id?
                    e=t0.value
                else
                    e=expr_value
                end
                expr_value=e+t
            end

            t0=Identifier.new(nil,nil)
            t0.temp_init(expr_type,expr_value)

            ob_stack.push(t0)
        when "STMT-> ID = EXPR "
            id_object=datatype_stack.pop;
            id_type=id_object.type_value;
            id_lexeme=id_object.lex_value;
            id_line=id_object.line_value;
            t0=ob_stack.pop
            #p t0
            expr_type=t0.type_value
            #p expr_type
            expr_value=t0.value
            if id_type!=expr_type && id_type!=''&& expr_type!=''
                print 'ERROR: type mismatch on line ';
                print line(id_lexeme,identifier);
                print "\n";
            elsif id_type==''
                print 'ERROR: ';
                print id_lexeme
                print ' not declared on line ';
                print line(id_lexeme,identifier);
                print  "\n";
            elsif  expr_type==''
                print 'ERROR: ';
                print expr_value;
                print ' not declared on line ';
                print line(expr_value,identifier);
                print "\n";
            end
            id_object.value_assign(expr_value)
            c=0

        when "FACTOR-> ( EXPR ) "

        when "STMT-> printf ( string , IDS ) "
            string=literal.pop;
            #puts string.lit_value
            count_ids=(string.lit_value).scan(/[%][dfcu]/).count;
            #puts c
            #puts count_ids
            prnt_object=Array.new;
            if count_ids!=c
                print 'ERROR:parameter number mismatched on line ';
                print  string.line_value;
                print  'for printf(...)'
                print "\n";
            else
                i=0;
                while i<count_ids
                  prnt_object[i]=datatype_stack_dup.pop;
                  i=i+1;
                end
                
                new_string=(string.lit_value).scan(/%[dfuc]/);
                for i in new_string
                   new_prnt_object=prnt_object.pop;
                   if new_prnt_object.type_value!=i
                       print 'ERROR:type mismatch in printf() for lexeme:';
                       print new_prnt_object.lex_value;
                       print "\n";
                   end 
                end
            end
        c=0
        end
    end    
end
def line(lexeme,identifier)
    if k=$ID.find{|k| k.lex_value==lexeme}
    	cntr=k.counter_value;
    	lines=k.line_value;
        line_array=lines.split('/');
    end
    	return line_array[cntr-1];
end