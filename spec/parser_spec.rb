require_relative '../parser.rb'

describe 'parser tests' do
  it 'does the first test' do

    p = Parser.new('testdata.txt')

    key = 'key'
    value = 'value'

    sample1 = 'key:value'

    expect(p.GetKey(sample1)).to eq(key)
    expect(value).to eq(p.GetValue(sample1))

    sample2 = 'key :value'
    expect(key).to eq(p.GetKey(sample2))
    expect(value).to eq(p.GetValue(sample2))

    sample3 = 'key :  value'
    expect(key).to eq(p.GetKey( sample3 ))
    expect(value).to eq(p.GetValue( sample3 ))

    # Each key must begin in column zero.
    badkey = ''
    expect(p.GetKey(' key :  value')).to eq(badkey)
    expect(badkey).to eq(p.GetKey('   key :  value'))

    spaceykey = 'spacey key'
    expect(p.GetKey('spacey key :  value')).to eq(spaceykey)

    k = 'k'
    v = 'v'
    minimal = 'k:v'
    expect(p.GetKey('k : v  ')).to eq(k)
    expect(p.GetKey('k: v  ')).to eq(k)
    expect(p.GetKey('k :v ')).to eq(k)
  end

  it 'does parsing of section names ' do
    p = Parser.new('testdata.txt')
    expected = 'Section demonstration'

    expect(p.SectionName('[Section demonstration]')).to eq(expected)
    expect(p.SectionName('[   Section demonstration]')).to eq(expected) # current
    expect(p.SectionName('[ Section demonstration     ]')).to eq(expected)

    boundaryCond1 = ''
    expect(p.SectionName('[]')).to eq(boundaryCond1)
    expect(p.SectionName(' []')).to eq(boundaryCond1)
    expect(p.SectionName('[] ')).to eq(boundaryCond1)

    boundaryCond2 = 'a'
    expect(p.SectionName('[a]')).to eq(boundaryCond2)
    expect(p.SectionName('[a] ')).to eq(boundaryCond2)
    expect(p.SectionName('[ a] ')).to eq(boundaryCond2)
    expect(p.SectionName('[ a ] ')).to eq(boundaryCond2)
    expect(p.SectionName('[ a  ]')).to eq(boundaryCond2)

  end

  it 'checks for duplicate key' do
    p = Parser.new('spec/dupekeys.txt')
    expect(p.Parse()).to eq(:kErrorDuplicateKey)
    expect(0).to eq(p.NumSections())
  end

  it 'finds duplicate sections' do
    p = Parser.new('spec/dupesecs.txt')

    expect(p.Parse()).to eq(:kErrorDuplicateSection)
    expect(p.NumSections).to eq (0)

    #  even though invalid, can we cause any trouble
    p.SetInt("header", "accessed", 0)
    expect(p.GetInt("header", "accessed")).to eq(0)
  end

  it 'detects bad files' do
    p = Parser.new('spec/bogus.txt')
    expect(p.Parse()).to eq(:kErrorCantOpenFile)
  end

  it 'opens a valid file ' do
    p = Parser.new('spec/testdata.txt')
    expect(p.Parse()).to eq(:kErrorSuccess )
  end

end
