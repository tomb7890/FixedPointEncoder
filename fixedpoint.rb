#
#
class FixedPoint
  attr_accessor :integer_portion, :fraction_portion

  FRACTION_BITS = 15
  INTEGER_BITS = 16

  def int
    shifted_integer_portion = (@integer_portion << FRACTION_BITS)
    @result = shifted_integer_portion | fractional_portion_binary(@fraction_portion)
    if @input < 0
      @result = set_the_high_bit(@result.to_i)
    end
    @result
  end

  def fn(n,x)
    mask = 1 << FRACTION_BITS + n
    if (@result & mask) != 0
      x += 2**n
    end
    x
  end

  def to_f
    x = 0.0
    (1...INTEGER_BITS).each do |n|
      x =  fn(n,x)
    end
    (0...FRACTION_BITS).each do |n|
      x = fn(-n,x)
    end
    x = -x if test_the_high_bit(@result)
    x
  end

  def to_s
    x = to_f
    '%2.2f' % x
  end

  def test_the_high_bit(x)
    (x & 0x80000000) != 0
  end

  def set_the_high_bit(x)
    (2**31) | x
  end

  def fractional_portion_binary(x)
    output = 0
    (1..FRACTION_BITS).each do |n|
      if nth_digit_value(n) <= x
        output = set_nth_digit(output, n)
        x -= nth_digit_value(n)
      end
    end
    output
  end

  private

  def initialize(a)
    if a.class == Float
      @input = a
      b = a.divmod 1
      @integer_portion = a.to_i.abs
      @fraction_portion = b[1]
    elsif a.class == Fixnum
      @result = a
    end
  end

  def nth_digit_value(n)
    exp = -n
    (2**exp)
  end

  def set_nth_digit(output, n)
    output |= 1 << (FRACTION_BITS - n)
  end
end
