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
  end

  it 'parses spaces inside a key ' do
    expect(@parser.get_key('key with spaces in it:  value')).to eq('key with spaces in it')
  end

  it 'does parsing of section names ' do
    p = Parser.new('testdata.txt')
    expected = 'Section demonstration'

    expect(@parser.SectionName('[Section demonstration]')).to eq(expected)
    expect(@parser.SectionName('[   Section demonstration]')).to eq(expected)
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
end

describe 'parsing strings' do

  before(:each) do
    @parser = Parser.new('spec/dupekeys.txt')
  end

  it 'checks for duplicate key' do
    expect(@parser.Parse()).to eq(:kErrorDuplicateKey)
  end
end

describe 'duplicate sections' do
  before(:each) do
    @parser = Parser.new('spec/dupesecs.txt')
  end

  it 'finds duplicate sections' do
    expect(@parser.Parse()).to eq(:kErrorDuplicateSection)
  end
end


describe 'parsing strings' do
  before(:each) do
    # @parser = Parser.new('keyvals.txt')
    @parser = Parser.new('spec/bogus.txt')
  end

  it 'detects bad files' do
    expect(@parser.Parse()).to eq(:kErrorCantOpenFile)
  end
end

describe 'foo ' do
  before(:each) do
    @parser = Parser.new('spec/testdata.txt')
  end

  it 'opens a valid file' do
    p = Parser.new('spec/testdata.txt')
    expect(@parser.Parse()).to eq(:kErrorSuccess )
  end

end

describe 'no sections ' do
  before(:each) do
    @parser = Parser.new ('spec/nosec.txt')
  end

  it 'ensures file starts with section' do
    expect(@parser.Parse).to eq(:kErrorDoesntStartWithSection)
  end
end

describe 'test get string' do

  before(:each) do
    @parser = Parser.new('spec/testdata.txt')
    @parser.Parse
  end

  it 'counts correctly the number of sections' do
    expect(@parser.num_sections).to eq 3
  end

  it 'retrieves string' do
    expected = 'all out of budget.'
    expect(expected).to eq @parser.get_string('trailer', 'budget')
  end
end
