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
    result = nil
    expect(@parser.get_key(' key :  value')).to eq(nil)
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

  it 'retrieves a different string' do
    expected = "I meant 'moderately,' not 'tediously,' above."
    expect(expected).to eq @parser.get_string("meta data", "correction text")
  end

  it 'retrieves a multiline string' do
    expected = "This is a tediously long description of the Art & Logic"
    expected += " programming test that you are taking. Tedious isn't the right word, but"
    expected += " it's the first word that comes to mind."

    expect(@parser.get_string("meta data", "description")).to eq expected
  end
end

describe 'test get numbers' do
  before(:each) do
    @parser = Parser.new('spec/testdata.txt')
    @parser.Parse
  end

  it 'retrieves an int' do
    expected = 205
    expect(@parser.get_int('header', 'accessed')).to eq expected
  end

  it 'retrieves a float' do
    expected = 4.5
    expect(@parser.get_float('header', 'budget')).to eq expected
  end

  it 'behaves well with nonexistent key name' do
    expected = nil
    expect(@parser.get_float('header', 'foo')).to eq expected
  end
end

require 'fileutils'
describe 'test setting values ' do
  before(:each) do
    FileUtils.cp('spec/testdata.txt', 'temp1.txt')
  end

  it 'sets a string in a file' do
    parser1 = Parser.new('temp1.txt')
    parser1.Parse()

    expected = 'all out of budget.'
    expect(parser1.get_string('trailer', 'budget')).to eq expected

    parser1.set_string('trailer', 'budget', 'replacement text')

    expected = 'replacement text'
    parser2 = Parser.new('temp1.txt')
    parser2.Parse()
    expect(parser2.get_string('trailer', 'budget')).to eq expected
  end

  after(:each) do
    FileUtils.rm('temp1.txt')
  end
end
