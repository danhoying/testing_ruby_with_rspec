# ENUMERABLE METHODS

# A rebuild of the methods from the Enumerable Module in Ruby.

module Enumerable

  def my_each
    return self.to_enum unless block_given?
    for i in self
      yield i
    end
  end

  def my_each_with_index
    return self.to_enum unless block_given?
    index = 0
    for i in self
      yield i, index
      index += 1
    end
  end

  def my_select
    return self.to_enum unless block_given?
    selected = []
    self.my_each {|i| selected << i if yield(i)}
    selected
  end

  def my_all?
    if block_given?
      self.my_each do |i|
        unless yield(i)
          return false
        end
      end
      return true
    else # This only runs if no block is given.
      self.my_each do |i|
        if i == false || i == nil
          return false
        end
      end
      return true # Only if no items are false or nil.
    end
  end

  def my_any?
    if block_given?
      self.my_each do |i|
        if yield(i)
          return true
        end
      end
      return false
    else # This only runs if no block is given.
      self.my_each do |i|
        if i != false && i != nil
          return true
        end
      end
      return false # Only if all items are nil or false.
    end
  end

  def my_none?
    if block_given?
      self.my_each do |i|
        if yield(i)
          return false
        end
      end
      return true
    else # This only runs if no block is given.
      self.my_each do |i|
        if i != false && i != nil
          return false
        end
      end
      return true # Only if none of the items is true.
    end
  end

  def my_count(number = (number_not_passed = true; 0))
    count = 0
    if block_given? 
      self.my_each do |i|
        if yield(i)
          count += 1
        end
      end
      count # Returns number of items yielding a true value.
    else
      self.my_each do |i|
        if i == number
          count += 1
        end
      end
      if number == 0
        return self.length # If no arguments are given, returns total number of items.
      else
        return count # Returns number of items equal to the given argument.
      end
    end 
  end

  def my_map
    new_array = []
    return self.to_enum unless block_given?
      self.my_each {|i| new_array << yield(i)}
      new_array
  end

  def my_inject(args=nil)
    if block_given?
      if args.nil?
        result = self[0]
        for i in self[1..(self.size)] do
          result = yield(result, i)
        end
      else
        result = args
        for i in self[0..(self.size)] do
          result = yield(result, i)
        end
      end
    end
    return result
  end

  # Test your #my_inject by creating a method called #multiply_els which 
  # multiplies all the elements of the array together by using #my_inject, 
  # e.g. multiply_els([2,4,5]) #=> 40

  def multiply_els
    self.my_inject{|product, n| product * n}
  end

  # Modify your #my_map method to take a proc instead.

  def my_map2(proc)
    new_array = []
      self.my_each {|i| new_array << proc.call(i)}
      new_array
  end

  # Modify your #my_map method to take either a proc or a block, executing the 
  # block only if both are supplied (in which case it would execute both 
  # the block AND the proc).

  def my_map3(proc=nil)
    new_array = []
    if proc and block_given?
      self.my_each {|i| new_array << yield(proc.call(i))}
    elsif proc
      self.my_each {|i| new_array << proc.call(i)}
    end
    new_array
  end
end

array = [4,3,78,2,0,2]
proc = Proc.new {|i| i * 2}
# EX: p array.my_map3(proc) {|i| i - 2} => [6, 4, 154, 2, -2, 2]

