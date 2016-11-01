class DuplicateKeyException < Exception
end

class DuplicateSectionException < Exception
end

class DoesntStartWithSection < Exception
end

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

  def process_line(line,stuff)
    if line
      v = GetValue(line)
      k = GetKey(line)
      if k && stuff.has_key?(k)
        raise DuplicateKeyException
      end
      stuff[k] = v
    end
  end

  def get_key_val_pairs(secbody)
    lines = secbody.split(/[\n]+/)
    stuff = {}
    lines.each do |line|
      process_line(line, stuff)
    end
  end

  def sectons_from_chunks(chunks, sections)
    until chunks.empty?
      secbody = chunks.shift
      secname = chunks.shift
      if sections.has_key?(secname)
        fail DuplicateSectionException
      else
        pairs = get_key_val_pairs(secbody)
        sections[secname] = pairs
      end
    end
  end

  def Parse
    stuff = File.read(@filename)
    chunks = stuff.split(/\[(.*)\]/)
    sections = {}
    sectons_from_chunks(chunks, sections)
  rescue DuplicateKeyException
    return :kErrorDuplicateKey
  rescue DuplicateSectionException
    return :kErrorDuplicateSection
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
