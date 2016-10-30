require_relative '../fixedpoint.rb'

def parsefile(p, filename)
  page = File.open(filename, 'rb').read
  p.parse(page)
end

def fmt thing
  "0x#{thing.to_s(16)}"
end

describe 'fixed point tests' do
  it 'does the first test' do
    value = -2.50
    fp = FixedPoint.new(value)
    expected = 0x00004000
    actual = fp.fractional_portion_binary(fp.fraction_portion)
    expect(actual).to eq(expected), "foo! expected #{fmt(expected)} actual #{fmt(actual)}"
    expect(fp.integer_portion).to eq 2
    expect(fp.fraction_portion).to eq 0.5
    expected = 0x80014000
    actual = fp.int
    expect(actual).to eq(expected), "foo! expected #{fmt(expected)} actual #{fmt(actual)}"
  end

  it 'does another test' do
    value = 3.14
    fp = FixedPoint.new(value)
    expected = 0x000191eb
    actual = fp.int
    expect(actual).to eq(expected), "foo! expected #{fmt(expected)} actual #{fmt(actual)}"
  end

  it 'does yet a third test ' do
    value = 100.99
    expected = 0x00327eb8
    fp = FixedPoint.new(value)
    actual = fp.int
    expect(actual).to eq(expected), "foo! expected #{fmt(expected)} actual #{fmt(actual)}"
  end

  it 'does string conversion' do
    #     * Idiomatic conversion to string (as <<optional sign>><<integer
    # passport_root>>.<<fractional part>>) For example, an instance of your Fixed
    # Point class initialized from an encoded value of 0x80008000 would be
    # converted to the string "-1.0".

    value = 0x80008000
    fp = FixedPoint.new(value)
    expected = "-1.00"
    actual = fp.to_s
    expect(actual).to eq(expected)

    value = 0x00010000
    expected = 2.00;
    fp = FixedPoint.new(value)
    actual = fp.to_f
    expect(actual).to eq(expected)

    # value = -2.25;
    # fp = FixedPoint.new(value)
    # expected = 0x80012000
    # actual = fp.to_s
    # expect(actual).to eq(expected)

    value = 0x00327eb8
    fp = FixedPoint.new(value)
    expected = "100.99"
    actual = fp.to_s
    expect(actual).to eq(expected)

    value = 0x000191eb
    fp = FixedPoint.new(value)
    expected = "3.14"
    actual = fp.to_s
    expect(actual).to eq(expected)
  end
end
