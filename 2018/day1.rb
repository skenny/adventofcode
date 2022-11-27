#!/usr/bin/ruby

content = File.read("2018/day1input.txt").split("\n")

frequency = 0
content.each do |val|
    frequency += val.to_i
end
puts frequency

frequency = 0
frequency_counts = { 0 => true }
found = false
while !found do 
    content.each do |val|
        frequency += val.to_i
        if frequency_counts[frequency]
            puts frequency
            found = true
            break;
        end
        frequency_counts[frequency] = true
    end    
end
