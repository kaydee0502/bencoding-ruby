require 'json'

class Bencoding
  class Encoder
  end

  class Decoder < Bencoding
    def initialize(path = nil)
      raise "Path can't be blank" if path.nil?

      @file = File.read(path)
      # example = "d1:ai123e3:badd1:c6:deepak2:aed1:yi69e1:xli23e6:kaydeed1:v1:ueeeee"
      # example_hash = {
      #   "a":123,
      #   "bad": {
      #     "c": "deepak",
      #     "ae": {
      #       "y": 69,
      #       "x": [23, "kaydee", {"v": "u"}]
      #     }
      #   }
      # }
      @initiaters = {d: method(:form_dic), i: method(:form_int), l: method(:form_list)}
    end

    def decode
      @res = parse[0]
    end

    def to_json(file_name)
      File.write("#{file_name}.json", JSON.dump(@res))
    end

    def parse(slice = @file, iter = 0)
      p "in parse"
      if @initiaters.include? slice[iter].to_sym
        @stack.append(iter)
        res, iter = @initiaters[slice[iter].to_sym].(slice, iter+1)
      elsif slice[iter].is_integer?
        res, iter = form_str(slice, iter)
      end
      p res, iter
      [res, iter]
    end

    private

    def form_int(slice = @file, iter)
      int_str = ""
      while iter < slice.length && slice[iter] != "e"
        int_str += slice[iter]
        iter += 1
      end
      iter += 1
      [int_str.to_i, iter]
    end
    
    def form_dic(slice = @file, iter)
      dic = {}
      while iter < slice.length && slice[iter] != "e"
        key, iter = form_str(slice, iter)
        dic[key], iter = parse(slice, iter)
      end
      iter+= 1
      [dic, iter]
    end

    def form_list(slice = @file, iter)
      list = []
      while iter < slice.length && slice[iter] != "e"
        elem, iter = parse(slice, iter)
        list << elem
      end
      iter+= 1
      [list, iter]
    end

    def form_str(slice = @file, iter)
      int_str = ""

      while iter < slice.length && slice[iter] != ":"
        int_str += slice[iter]
        iter += 1
      end
      iter += 1
      range = int_str.to_i
      ender = iter+range

      [slice[iter...ender].force_encoding("ISO-8859-1").encode("UTF-8"), ender]
    end
  end
end

# additional string helper
class String
  def is_integer?
    self.to_i.to_s == self
  end
end

a = Bencoding::Decoder.new("../debian-11.5.0-amd64-DVD-1.iso.torrent")
a.decode
a.to_json("result")