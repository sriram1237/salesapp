
class Account
    attr_accessor :no, :fl,:person

    def initialize(no, fl)
        @no = no
        @fl = fl
       # puts "EF=====> :#{fl}"
      @person = Hash.new {|h,k| h[k]=[]}

  
#  @person = @fl.map { |rd|  @personrd[rd['val']]= rd['content'] }
   @fl.inject([]) {|o,d|  @person[d['val']] << d['content']
     
     }
        
      puts "Length :  #{@person}"
        
    end
end


