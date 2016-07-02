module FPI

  def self.init path
    myfile = File.new(path)
    matrix = []
    while (!(line = myfile.gets).nil?)
      temp = line.split
      temp.map! { |x| x = x.to_f }
      matrix << temp
    end
    return matrix
  end


  def self.gauss_main_method a
    n = a.length - 1

    for i in 0..n
      (n+1).downto(i) do |j|
        a[i][j] = a[i][j] / a[i][i]
      end

      for k in (i+1)..n
        (n+1).downto(i) do |j|
          a[k][j] = a[k][j] - (a[k][i] * a[i][j])
        end
      end
    end

    puts 'Матрица после прямого хода >>'
    print_matrix a

    x = Array.new(n + 1,0)
    x[n] = a[n][n+1]

    (n-1).downto(0) do |i|
      k = n+1
      for j in i..(n-1)
        a[i][k] = a[i][k] - a[i][j+1] * x[j+1]
        x[i] = a[i][k]
      end
    end
    return x
  end

  def self.main_method a, eps #По Гавриловой
    n = a.length - 1 #init
    alpha = []
    beta = Array.new(n+1)
    (n+1).times { alpha << Array.new(n + 1, 0)}

    for i in 0..n
      for j in 0..n
        alpha[i][j] = -a[i][j] / a[i][i]
      end
    end
    for i in 0..n
      alpha[i][i] = 0
      beta[i] = a[i][n + 1] / a[i][i]
    end

    nalpha = 0

    for i in 0..n
      s = 0;
      for j in 0..n do
        s = s + alpha[i][j].abs
      end
      if nalpha < s then nalpha = s end
    end

    x = Array.new(n+1)
    x1 = Array.new(n+1)

    puts "alpha norm = #{nalpha}"
    if nalpha < 1
      for i in 0..n
        x[i] = beta[i]
        x1[i] = 0
      end

      k=0

      begin
        for i in 0..n
          s = 0
          for j in 0..n
            s += alpha[i][j] * x[j]
          end
          x1[i] = s + beta[i]
        end
        max = (x1[0]-x[0]).abs
        for i in 1..n
          if (x1[i] - x[i]).abs > max then max = (x1[i] - x[i]).abs end
        end
        for i in 0..n
          x[i] = x1[i]
        end
        k += 1
      end while max > (1 - nalpha) * eps / nalpha
    else
      p "Матрица не сходящаяся"
      return
    end
    p "Ответ найден за #{k} итераций"
    return x
  end

  def self.zeidel_method a, eps
    n = a.length - 1 #init
    alpha = []
    beta = Array.new(n+1)
    (n+1).times { alpha << Array.new(n + 1, 0)}

    for i in 0..n
      for j in 0..n
        alpha[i][j] = -a[i][j] / a[i][i]
      end
    end
    for i in 0..n
      alpha[i][i] = 0
      beta[i] = a[i][n + 1] / a[i][i]
    end

    nalpha = 0

    for i in 0..n
      s = 0;
      for j in 0..n do
        s = s + alpha[i][j].abs
      end
      if nalpha < s then nalpha = s end
    end

    x = Array.new(n+1)
    x1 = Array.new(n+1)
    
    puts "alpha norm = #{nalpha}"
    if nalpha <1
      for i in 0..n
        x[i] = beta[i]
        x1[i] = 0
      end
      #calc mu
      #

      mu = 0
      
      for i in 0..n
        summ = alpha[i].inject {|memo, item| memo += item.abs}
        summ2 = 0
        for j in 0..i-1
          summ += a[i][j].abs
        end
        mutemp = summ / (1 - summ2)
        if (mutemp >  mu && mutemp <= nalpha) then mu = mutemp end
      end
      

      k=0
      s = Array.new(n+1)
      begin
        for i in 0..n
          s[i] = 0
          for j in 0..(i-1) 
            s[i] += alpha[i][j] * x1[j]
          end
          for j in i..n
            s[i] += alpha[i][j] * x[j]
          end
          x1[i] = s[i] + beta[i]
        end
        max = (x1[0]-x[0]).abs
        for i in 1..n
          if (x1[i] - x[i]).abs > max then max = (x1[i] - x[i]).abs end
        end
        for i in 0..n
          x[i] = x1[i]
        end
        k += 1
      end while max > eps * (1 - mu) / mu
    else
      p "Матрица не сходится"
      return
    end
    p "Решение найдено за #{k} итераций"
    return x
  end

  def self.errors a, x
    n = a.length - 1
    r = Array.new(n+1)
    for i in 0..n
      s = 0
      for j in 0..n
        s += a[i][j] * x[j]
      end
      r[i] = s
    end

    for i in 0..n
      r[i] = (a[i][n+1] - r[i]).abs
    end

    return r
  end

  def self.print_matrix a
    a.each do |arr|
      arr.each_with_index do |x, index|
        print "#{format("%.6f", x)} "
        if index == arr.length - 2
          print ' | '
        end
      end
      puts
    end
    puts
  end
end
