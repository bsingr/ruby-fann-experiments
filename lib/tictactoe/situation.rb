module TTT; end
class TTT::Situation
  attr_reader :p

  def initialize p
    raise ArgumentError, "Invalid permutation size 9 != #{p.size}" if p.size != 9
    @p = p
  end

  def valid?
    (minus_winning_strikes.size + plus_winning_strikes.size) <= 1
  end

  def winner
    if minus_winning_strikes.size == 1
      -1
    elsif plus_winning_strikes.size == 1
      1
    else
      0
    end
  end

  def strikes
    strikes = [p[0]+p[1]+p[2], # row 1
               p[3]+p[4]+p[5], # row 2
               p[6]+p[7]+p[8], # row 3
               p[0]+p[3]+p[6], # col 1
               p[1]+p[4]+p[7], # col 2
               p[2]+p[5]+p[8], # col 3
               p[0]+p[4]+p[8], # diag 1
               p[2]+p[4]+p[6]] # diag 2
  end

  def minus_winning_strikes
    strikes.find_all{|s| s == -3}
  end
  
  def plus_winning_strikes
    strikes.find_all{|s| s == 3}
  end

  def valid_permutation_with_winner winning_boost
    if valid?
      p.push winner*winning_boost
    else 
      # noop, too much winners
    end
  end
end
