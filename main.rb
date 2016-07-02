$LOAD_PATH << '.'

require 'FPI.rb'

a = FPI::init 'input.txt'

power = -10

for power in [-3, -5, -8]
  puts "eps = " + (10**power).to_s
  puts "----------------------------------"
  puts "Fixed-point iteration"
  x = FPI::main_method a, 10**(power)
  puts
  print "answer >> "+ x.to_s
  puts
  r = FPI::errors a, x
  print "Errors >>" + r.to_s
  puts
  puts "----------------------------------"
  puts "Zeidel's method"

  x = FPI::zeidel_method a, 10**(power)
  puts
  print "answer" + x.to_s
  r = FPI::errors a, x
  puts
  print "Errors >>" + r.to_s
  puts
  puts "---------------------------------"
  puts "---------------------------------"
end
