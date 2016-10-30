class Parser

  attr_accessor :filename

  def initialize(f)
    @filename = f
  end

  def GetKey(line)
    key = nil
    splitted = line.split(':')
    if splitted.size > 1
      key = splitted[0].rstrip
      # return empty string if bad key (doesn't start in column zero)
      if key[0] == ' '
        key = ''
      end
    end
    key
  end

  def GetValue(line)
    value = nil
    splitted = line.split(':')
    if splitted.size > 1
      value = splitted[1].strip
    end
  end

  def SectionName(line)
    rc = ''
    splitted = line.split(/[\[\]]/)
    if  splitted.size > 1
      rc = splitted[1].strip
    end
    rc
  end

  def get_key_val_pairs(secbody)
    lines = secbody.split(/[\n]+/)
    stuff = {}
    lines.each do | line |
      if line
        v = GetValue(line)
        k = GetKey(line)
        if k && stuff.has_key?(k)
          return :kErrorDuplicateKey
        else
          stuff[k] = v
        end
      end
    end
  end

  def Parse
    rc = 'foo'
    stuff = File.read(@filename)
    elements = stuff.split(/\[(.*)\]/)
    sections = {}
    until elements.empty?
      secbody = elements.shift
      secname = elements.shift
      if sections.has_key?(secname)
        return :kErrorDuplicateSection
      else
        pairs = get_key_val_pairs(secbody)
        if pairs == :kErrorDuplicateKey
          return :kErrorDuplicateKey
        end
        sections[secname] = pairs
      end
    end
    rc
  end

  def SetInt(a,b,c)
    return 0
  end

  def GetInt(a,b)
    0
  end

  def NumSections()
    0
  end
end
