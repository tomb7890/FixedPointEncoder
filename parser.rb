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
    @sections = {}
  end

  def num_sections
    @sections.keys.size
  end

  def get_key(line)
    key = nil
    splitted = line.split(':')
    if splitted.size > 1
      key = splitted[0].rstrip
      # return empty string if bad key (doesn't start in column zero)
      if key[0] == ' '
        key = nil
      end
    end
    key
  end

  def get_value(line)
    value = nil
    splitted = line.split(':')
    if splitted.size > 1
      value = splitted[1].strip
    end
    value
  end

  def SectionName(line)
    rc = ''
    splitted = line.split(/[\[\]]/)
    if  splitted.size > 1
      rc = splitted[1].strip
    end
    rc
  end

  def process_line(line,hash)
    if line
      v = get_value(line)
      k = get_key(line)
      store_key_and_value_into_hash(k,v,hash)
    end
  end

  def store_key_and_value_into_hash(k,v,hash)
    raise DuplicateKeyException if k and hash.key? k
    hash[k] = v
  end

  def find_and_join_continuation_lines(secbody)
    secbody.gsub!(/\r\n\s/, ' ')
    secbody
  end

  def get_key_val_pairs(secbody)
    find_and_join_continuation_lines(secbody)
    lines = secbody.split(/[\n]+/)
    hash = {}
    lines.each do |line|
      process_line(line, hash)
    end
    hash
  end

  def sectons_from_chunks(chunks)
    fail DoesntStartWithSection if chunks.size <= 1
    chunks.shift # discard initial empty chunk
    until chunks.empty?
      secname = chunks.shift.strip
      secbody = chunks.shift
      fail DuplicateSectionException if @sections.key?(secname)
      pairs = get_key_val_pairs(secbody)
      @sections[secname] = pairs
    end
  end

  def Parse
    text = File.read(@filename)
    chunks = text.split(/\[(.*)\]/)

    sectons_from_chunks(chunks)
    return :kErrorSuccess
  rescue DuplicateKeyException
    return :kErrorDuplicateKey
  rescue DoesntStartWithSection
    return :kErrorDoesntStartWithSection
  rescue DuplicateSectionException
    return :kErrorDuplicateSection
  rescue Errno::ENOENT
    return :kErrorCantOpenFile
  end

  def SetInt(a,b,c)
    return 0
  end

  def GetInt(a,b)
    0
  end

  def get_string(section, name)
    s = @sections[section]
    value = s[name]
  end

end
