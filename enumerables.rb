# frozen_string_literal: true

module Enumerable

  # custom enumerable#each method

  def my_each
    i = 0
    until i == self.size
      if self.is_a?(Hash)
        yield self.keys[i], self.values[i]
      else
        yield self[i]
      end
      i += 1
    end
    self
  end

  # custom enumerable#each_with_index method
  def my_each_with_index
    index = 0 
    if self.is_a?(Hash)
      self.my_each do |i|
        yield self.keys[i], self.values[i], index
        index += 1
      end
    else
      self.my_each do |i| 
        yield i, index
        index += 1
      end
    end 
    self
  end

  # custom enumerable#select method
  def my_select
    arr = []
    if self.is_a?(Hash)
      self.each do |i|
        match = yield i
        arr << i if match == true
      end
    else
      self.each do |i|
        match = yield i
        arr << i if match == true
      end
    end
    arr
  end

  # custom enumerable#all?
  def my_all?(arg = nil)
    match = true
    if arg && !self.is_a?(Hash)
      self.each do |i|
        match = arg == i
        return false if match == false
      end
    elsif arg == nil && self.is_a?(Hash) && !block_given?
      return true
    elsif self.is_a?(Hash)
      match = false
      return match
    else
      self.each do |i|
        match = yield i
        return false if match == false
      end
    end
    match
  end

  # custom enumerable#any?
  def my_any?
    self.my_each do |i|
      match = yield i
      if match == true
        return true
      end
    end
    false
  end
 
 # custom enumerable#none?
  def my_none?
    self.my_each do |i|
      match = yield i
      if match == true
        return false
      end
    end
    true
  end

 # custom enumerable#count

  def my_count(arg = nil)
    counter = 0
    if block_given?
      self.my_each do |i|
        match = yield i
        counter += 1 if match == true
      end
      counter
    elsif arg
      self.my_each do |i|
        if i == arg
          counter += 1
        end
      end
      counter
    else
      self.my_each do |i|
        counter += 1
      end
      counter
    end
  end

  def my_map(arg = nil)
    arr = [] 
    if arg
      self.my_each do |i|
        arr << arg.call(i)
      end
      arr
    elsif block_given?
      self.my_each do |i|
        arr << yield(i)
      end
    else
      to_enum(:my_map)
    end
    arr
  end

  def my_reduce
    counter = 0
    acc = self[0] 
    val = counter + 1
    len = self.length - 1

    until counter == len
      acc = yield acc, self[val] 
      counter += 1
      val = counter + 1
    end
    acc
  end

end

# MY ARRAY
arr = [1,2,3,4,5]

# MY HASH
hsh = {
  name: 'Mark',
  age: 30,
  occupation: 'Programmer'
}

puts '...my_each VS each...ARRAY'

arr.my_each { |i| p i + 1 }
arr.each { |i| p i + 1 }

puts "\n...my_each VS each...HASH"

hsh.my_each { |key, val| puts "key: #{key}, val: #{val}" }
hsh.each { |key, val| puts "key: #{key}, val: #{val}" } 

puts 
puts '...my_each_with_index vs each_with_index...'

[1, 2, 3].my_each_with_index do |i, idx|
  p "#{i} and index is #{idx}"
end

[1, 2, 3].each_with_index do |i, idx|
  p "#{i} and index is #{idx}"
end

puts
puts '...my_select vs select...'

p ['hi', 'no', 'yes', 'no'].my_select { |i| i == 'no'  }
p ['hi', 'no', 'yes', 'no'].select { |i| i == 'no'  }

puts
puts '...my_all? with arg'
p ['no', 'no', 'no', 'no'].my_all?('no')

puts
puts '...my_all? vs all?...FALSE'

p ['xno', 'no', 'no', 'xxxo'].my_all? { |i| i == 'no'  }
p ['xno', 'no', 'no', 'xxxo'].all? { |i| i == 'no'  }

puts 
puts '...my_all? vs all?...TRUE'

p ['no', 'no', 'no', 'no'].my_all? { |i| i == 'no'  }
p ['no', 'no', 'no', 'no'].my_all? { |i| i == 'no'  }

puts
puts 'This is my_any?'

p ['xno', 'no', 'no', 'xxxo'].my_any? { |i| i == 'no'  }

puts
puts 'This is my_none'

p [1, 2, 3].my_none? { |i| i > 10 }

puts
puts 'This is my_count'

p [1,2,3,4,5,6].my_count { |i| i == 5 }

puts
puts 'This is my_map'

p [1,2,3,4].my_map { |i| i * i }

puts
puts 'This is my map with a proc'

blockx = Proc.new { |i| i <= 2 }

p [1,2,3,4].my_map(blockx) { |i| i ** 2 }

puts
puts 'This is my_reduce'

p [1,2,3,4].my_reduce { |acc, val| acc * val } 
