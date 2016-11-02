require_relative '../parser.rb'

describe 'parsing strings' do
  before(:each) do
    @parser = Parser.new('keyvals.txt')
  end

  it 'does the nominal case' do
    string = 'key:value'
    expect(@parser.get_key(string)).to eq('key')
    expect('value').to eq(@parser.get_value(string))
  end

  it 'parses spaces before the colon' do
    sample2 = 'key :value'
    expect('key').to eq(@parser.get_key(sample2))
    expect('value').to eq(@parser.get_value(sample2))
  end

  it 'parses spaces after the colon' do
    sample3 = 'key :  value'
    expect('key').to eq(@parser.get_key(sample3))
    expect('value').to eq(@parser.get_value(sample3))
  end

  it 'requires keys to start in column zero' do
    badkey = ''
    expect(@parser.get_key(' key :  value')).to eq(badkey)
    expect(badkey).to eq(@parser.get_key('   key :  value'))
  end

  it 'parses spaces inside a key ' do
    spaceykey = 'spacey key'
    expect(@parser.get_key('spacey key :  value')).to eq(spaceykey)

    k = 'k'
    v = 'v'
    minimal = 'k:v'
    expect(@parser.get_key('k : v  ')).to eq(k)
    expect(@parser.get_key('k: v  ')).to eq(k)
    expect(@parser.get_key('k :v ')).to eq(k)
  end

  it 'does parsing of section names ' do
    p = Parser.new('testdata.txt')
    expected = 'Section demonstration'

    expect(@parser.SectionName('[Section demonstration]')).to eq(expected)
    expect(@parser.SectionName('[   Section demonstration]')).to eq(expected) # current
    expect(@parser.SectionName('[ Section demonstration     ]')).to eq(expected)

    boundaryCond1 = ''
    expect(@parser.SectionName('[]')).to eq(boundaryCond1)
    expect(@parser.SectionName(' []')).to eq(boundaryCond1)
    expect(@parser.SectionName('[] ')).to eq(boundaryCond1)

    boundaryCond2 = 'a'
    expect(@parser.SectionName('[a]')).to eq(boundaryCond2)
    expect(@parser.SectionName('[a] ')).to eq(boundaryCond2)
    expect(@parser.SectionName('[ a] ')).to eq(boundaryCond2)
    expect(@parser.SectionName('[ a ] ')).to eq(boundaryCond2)
    expect(@parser.SectionName('[ a  ]')).to eq(boundaryCond2)

  end

  it 'checks for duplicate key' do
    p = Parser.new('spec/dupekeys.txt')
    expect(@parser.Parse()).to eq(:kErrorDuplicateKey)
    expect(0).to eq(@parser.NumSections())
  end

  it 'finds duplicate sections' do
    p = Parser.new('spec/dupesecs.txt')

    expect(@parser.Parse()).to eq(:kErrorDuplicateSection)
    expect(@parser.NumSections).to eq (0)

    #  even though invalid, can we cause any trouble
    @parser.SetInt("header", "accessed", 0)
    expect(@parser.GetInt("header", "accessed")).to eq(0)
  end

  it 'detects bad files' do
    p = Parser.new('spec/bogus.txt')
    expect(@parser.Parse()).to eq(:kErrorCantOpenFile)
  end

  it 'opens a valid file' do
    p = Parser.new('spec/testdata.txt')
    expect(@parser.Parse()).to eq(:kErrorSuccess )
  end

  it 'ensures file starts with section' do
    p = Parser.new('spec/nosec.txt')
    expect(@parser.Parse).to eq(:kErrorDoesntStartWithSection)
  end
end
