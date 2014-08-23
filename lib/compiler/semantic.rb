
def semantic(production)
	number=$NUM.dup
	literal=$LIT.dup
	identifier=$ID.dup
	#element_repeated=identifier.select{|element| identifier.count(element) >1 }.uniq
	#element_uniq=identifier.select { |element| identifier.count(element)==1}		
    #identifier=element_repeated+element_uniq
    #print identifier
    
    action_table=[{:production=>"NAME-> main ",:action=>"c=0;
    													
    	                                                 name='main';
    	 												 ids_lexeme=Array.new;
    	 												 ids_lexeme1=Array.new;
    	 												 datatype_stack=Array.new;"},
                {:production=>"FNAME-> NAME ( ) ",:action=>"fname=name+'()';"},
                {:production=>"DATATYPE-> char ",:action=>"datatype='char';"},
                {:production=>"DATATYPE-> void ",:action=>"datatype='void';"},
                {:production=>"DATATYPE-> int ",:action=>"datatype='int';"},
                {:production=>"IDS-> id ", :action=>"ids_object=identifier.shift;
                	                                 ids_object.inc_count; 

                	                                 if datatype
                	                                  ids_type=datatype;
                	                                 else
                	                               	  c=c+1;
                	                                 end
                	                                  ids_lexeme.push(ids_object.lex_value);
                	                                  "},
                {:production=>"IDS-> ID , IDS ",:action=>"ids_object=datatype_stack.pop();
                						
                  	                                 if datatype
                	                                    ids_type=datatype;
                	                                 else
                	                                	c=c+1;
                	                                 end
                	                                 ids_lexeme.push(ids_object.lex_value);"},
                {:production=>"STMT-> DATATYPE IDS ",:action=>"
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
                	                                         "},
                {:production=>"ID-> id ",:action=>"id_object=identifier.shift;
                	                               id_object.inc_count;
                	                               
                	                               datatype_stack.push(id_object); 
                                                   "},
                 {:production=>"FACTOR-> num ",:action=>"num_object=number.shift;
                 	                                     fact_type=num_object.type_value;
                 	                                     fact_value=num_object.value;
                 	                                     fact_line=num_object.line_value;
                 	                                    "},

                 {:production=>"FACTOR-> id ",:action=>"ids_object=identifier.shift;
                 	                                     ids_object.inc_count;
                                                   
                 	                                    fact_type=ids_object.type_value;
                 	                                    fact_value=ids_object.lex_value;
                 	                                    fact_line=ids_object.line_value;
                 	                                    "},
                 {:production=>"TERM-> FACTOR ",:action=>"term_type=fact_type;
                 	                                      term_value=fact_value;
                 	                                      term_line=fact_line;"},
                 {:production=>"EXPR-> TERM ",:action=>"expr_type=term_type;
                 	                                    expr_value=term_value;
                 	                                    expr_line=term_line;"},
                 {:production=>"EXPR-> EXPR + TERM ",:action=>" if expr_type!=term_type && expr_type !=''&&term_type!=''
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
                 	                                        	 end"},
                 {:production=>"EXPR-> EXPR - TERM ",:action=>" if expr_type!=term_type
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
                 	                                        	  print ' not declered ';
                 	                                        	  print line(term_value,identifier);
                 	                                        	  print  ' \n';
                 	                                        	end
                 	                                           "},
                 {:production=>"STMT-> ID = EXPR ",:action=>"id_object=datatype_stack.pop;
                 											 id_type=id_object.type_value;
                                                   			 id_lexeme=id_object.lex_value;
                                                             id_line=id_object.line_value;
                 											 if id_type!=expr_type && id_type!=''&& expr_type!=''
                 	                                            print 'ERROR: type missmatch on line ';
                 	                                            
                 	                                            print line(id_lexeme,identifier);
                 	                                            print '\n';
                   	                                          
                   	                                          elsif id_type==''
                 	                                        	print 'ERROR: ';
                 	                                        	print ' not declered on line';
                 	                                        	print line(id_lexeme,identifier);
                 	                                        	  print  ' \n';
                 	                                           
                 	                                         elsif  expr_type==''
                 	                                         	print 'ERROR: ';
                 	                                        	print expr_value;
                 	                                        	print ' not declered ';
                 	                                        	print line(expr_value,identifier);
                 	                                        	  print  ' \n';
                 	                                        end"},
                 {:production=>"STMT-> printf ( string , IDS ) ",:action=>" string=literal.shift;
                 	                                                       count_ids=(string.lit_value).scan(/%[dfcu]/).count;
                 	                                                       if count_ids!=c
                 	                                                       	 print 'ERROR:parameter number missmatched on line ';
                 	                                                       	 print  string.line_value;
                 	                                                       	 print  'for printf(...)'
                 	                                                       	 print '\n';
                 	                                                       	end
                 	                                                       "},]
         b=binding
         for x in production
           if e=action_table.find{|e| e[:production]==x}
               b.eval(e[:action])
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