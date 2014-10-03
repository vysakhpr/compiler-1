class Identifier
  @lexeme=""
  @type=""
  @line=""
  @counter=0
  @value=nil
  def initialize(lexeme,line)
    @lexeme=lexeme
    @line="#{line}/"
    @type=""
    @counter=0;
  end
  def temp_init(type,value) 
    @lexeme=nil
    @type=type
    @line=nil
    @value=value
  end
  def pos(line)
    @line=@line+line.to_s+"/"
  end
  def lex_value
    @lexeme
  end
  def type_assign(type)
    @type=type
  end
  def type_value
    @type
  end
  def inc_count
    @counter=@counter+1
  end
  def line_value
    @line
  end
  def counter_value
    @counter
  end
  def value_assign(value)
    @value=value
  end
  def value
    @value
  end
  def is_id?
    true
  end
  def is_number?
    false
  end
end

class Number
  @value=nil
  @type=""
  @line=nil
  def initialize(value,type,line)
    @value=value
    @type=type
    @line=line
  end
  def num_value
    @value
  end
  def type_value
    @type
  end
  def line_value 
    @line
  end
  def value
    @value
  end
  def is_number?
    true
  end
  def is_id?
    false
  end
end

class Literal
  @value=nil
  @line=nil
  def initialize(value,line)
    @value=value
    @line=line
  end
  def lit_value
    @value
  end
  def line_value
    @line
  end
end



$ID=[];
$NUM=[];
$LIT=[];
$PRINTBUFF=[];