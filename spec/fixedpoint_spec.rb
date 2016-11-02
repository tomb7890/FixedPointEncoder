require_relative '../fixedpoint.rb'

describe 'fixed point tests' do
  before(:each) do
    value = -2.50
    @fp = FixedPoint.new(value)
  end

  it 'finds the binary fractional portion as 0x00004000' do
    expected = 0x00004000
    actual = @fp.fractional_portion_binary(@fp.fraction_portion)
    expect(actual).to eq(expected)
  end

  it 'finds the integer portion as 2' do
    expect(@fp.integer_portion).to eq 2
  end

  it 'finds the integer fraction portion of ' do
    expect(@fp.fraction_portion).to eq 0.5
    expected = 0x80014000
    actual = @fp.int
    expect(actual).to eq(expected)
  end
end

describe 'more fixed point tests' do

  it 'transforms 3.14 into 0x000191eb' do
    value = 3.14
    fp = FixedPoint.new(value)
    expected = 0x000191eb
    actual = fp.int
    expect(actual).to eq(expected)
  end

  it 'it transforms 100.99 into 0x00327eb8' do
    value = 100.99
    expected = 0x00327eb8
    fp = FixedPoint.new(value)
    actual = fp.int
    expect(actual).to eq(expected)
  end

  it 'does string conversion' do
    #     * Idiomatic conversion to string (as <<optional sign>><<integer
    # passport_root>>.<<fractional part>>) For example, an instance of your Fixed
    # Point class initialized from an encoded value of 0x80008000 would be
    # converted to the string "-1.0".

    value = 0x80008000
    fp = FixedPoint.new(value)
    expected = '-1.00'
    actual = fp.to_s
    expect(actual).to eq(expected)

    value = 0x00010000
    expected = 2.00
    fp = FixedPoint.new(value)
    actual = fp.to_f
    expect(actual).to eq(expected)

    # value = -2.25;
    # fp = FixedPoint.new(value)
    # expected = 0x80012000
    # actual = fpto_s
    # expect(actual).to eq(expected)

    value = 0x00327eb8
    fp = FixedPoint.new(value)
    expected = '100.99'
    actual = fp.to_s
    expect(actual).to eq(expected)

    value = 0x000191eb
    fp = FixedPoint.new(value)
    expected = '3.14'
    actual = fp.to_s
    expect(actual).to eq(expected)
  end
end
