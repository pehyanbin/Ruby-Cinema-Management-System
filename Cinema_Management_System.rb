class Info 
  attr_accessor :name, :age, :gender, :session, :row, :column
  
  def initialize(name, age, gender, session, row, column)
      @name = name 
      @age = age 
      @gender = gender
      @session = session
      @row = row
      @column = column 
  end 
end 







class Seat 
  attr_accessor :session, :row, :column
  
  def initialize(session, row, column)
      @session = session 
      @row = row 
      @column = column
  end 
end 







def get_input(session, movie_names)
  puts "Name : "
  name = gets.chomp.to_s()
  
  puts "Age : "
  age = gets.chomp.to_i()
  
  puts "Gender : "
  gender = gets.chomp.to_s() 

  movie_name_lists(session, movie_names)

  puts "Session : "
  session = gets.chomp.to_i()
  
  puts "Row : "
  row = gets.chomp.to_i()
  
  puts "Column : "
  column = gets.chomp.to_i()
  
  info = Info.new(name, age, gender, session, row, column) 
  
  return info 
end 







def seat(seats, info, seatConfig)
  
  session = info.session
  row = info.row 
  column = info.column 
  
  
  if (session <= seatConfig.session && session > 0 && row <= seatConfig.row && row > 0 && column <= seatConfig.column && column > 0)
      row_confirm = -99
      column_confirm = -99 
      session_confirm = -99
      
      if (seats[session][row][column]!=1) 
          seats[session][row][column] = 1 
          puts "============================================="
          puts "Confirm locking seat"
          session_confirm = session 
          row_confirm = row 
          column_confirm = column
      else 
          puts "============================================="
          puts "Seat is booked. Please choose another seat. "
      end 
  else 
      puts "\n\n!!!!! Invalid : Out of Range !!!!!"
      puts "Enter within range : 1- #{seatConfig.session} for session, 1 - #{seatConfig.row} for row and 1 - #{seatConfig.column} for column. "
  end  
  
  seat = Seat.new(session_confirm, row_confirm, column_confirm)
  
  return seat 
  
  
  
end  






def print_output(info, seat, movie_names)
  if (seat.session == -99)
    puts "Name : #{info.name}"
    puts "Age : #{info.age}"
    puts "Gender : #{info.gender}"

    puts "Session : #{seat.session} => #{movie_names[seat.session]}"

    puts "Seat : #{seat.row}, #{seat.column}"
  end 
end 









def seat_config()
  puts "Seat configuration settings \n======================================================"

  puts "Session : "
  session = gets.chomp.to_i

  puts "Row : "
  row = gets.chomp.to_i

  puts "Column : "
  column = gets.chomp.to_i

  seat_config = Seat.new(session, row, column)

  return seat_config

  
end 










def movie_lists_config(sessions, movie_names)
  i = 1
  
  while (i <= sessions)
    puts "Movie name for session #{i} : "
    movie_names[i] = gets.chomp

    i += 1
  end 
end 







def movie_name_lists(sessions, movie_names)
  i = 1

  puts "Movies \n=============================="

  while (i <= sessions)
    puts "(#{i})  " + movie_names[i] 
    i += 1
  end 

  puts "\n\n"
end 









def show_seat_config(seats, seatConfig, movie_names)
  puts "\n\nSeats configurations \n========================================================="

  s = 1 

  while (s <= seatConfig.session)
    puts "\n[ Session #{s} : #{movie_names[s]}]"

    i = 1

    while (i <= seatConfig.row)
      j = 1 
      while(j <= seatConfig.column)
        print seats[s][i][j].to_s() + "     "
        j += 1
      end 

      puts ""
      i += 1
    end

    puts "\n========================================================="
    s += 1
  end 

  puts "\n\n"
end 









def initialize_seat_config(seats, seatConfig)

  s = 1 

  while (s <= seatConfig.session)
    i = 1 

    seats[s] = Array.new(seatConfig.row)

    while (i <= seatConfig.row) 
      j = 1
      seats[s][i] = Array.new(seatConfig.column)
      while (j <= seatConfig.column)
        seats[s][i][j] = 0  
        
        j += 1 
      end 

      i += 1
    end

    s += 1
  end 
end 







def seat_booking_part(seats, seatConfig, session, movie_names)
  while true 
    data = get_input(session, movie_names)
    seat = seat(seats, data, seatConfig)
    print_output(data, seat, movie_names)

    puts "\n\n\n\n"

    print_receipt(data, seat, movie_names)
    
    puts "\n\n\n\n"

    puts "Exit Booking"

    break if (break_mechanism()) 

  end 
end 






def configure_seats(seats, seatConfig, movie_names)

  if (seatConfig.session.nil? && seatConfig.row.nil? && seatConfig.column.nil?)
    seat_config()
    movie_lists_config(seatConfig.session, movie_names)
  end 

  initialize_seat_config(seats, seatConfig)

  show_seat_config(seats, seatConfig, movie_names)
end 







module Operation 
  CONFIG, BOOKING, SHOW_CONFIG = *1..3
end 






def break_mechanism()
  puts "Do you want to EXIT ? ( 1 = Exit; any number = Continue)"
  continue = gets.chomp.to_i

  continue == 1
end 







def operation_choice(seats, seatConfig, session, movie_names)
  puts "Choose operation : \n(1) CHANGE CONFIG\n(2) BOOKING\n(3) SHOW SEAT CONFIG"
  operation = gets.chomp.to_i

  case operation 
    when Operation::CONFIG
      configure_seats(seats, seatConfig, movie_names)

    when Operation::BOOKING 
      seat_booking_part(seats, seatConfig, session, movie_names)

    when Operation::SHOW_CONFIG
      show_seat_config(seats, seatConfig, movie_names) 

    else 
      puts "!!! Invalid input !!!"
  end 
end 










def print_receipt(info, seat, movie_names)
  puts "Print receipt ? ( 1 for print receipt, any number to decline )"

  receipt = gets.chomp.to_i()

  if (receipt == 1)
    myfile = File.new("receipt.txt", "w")

    myfile.puts "===================== Receipt ====================="
    myfile.puts "Name : #{info.name}"
    myfile.puts "Age : #{info.age}"
    myfile.puts "Gender : #{info.gender}"
    myfile.puts ""

    session = seat.session 
    myfile.puts "Session : #{session} => #{movie_names[session]}"

    myfile.puts ""
    
    myfile.puts "Seat : [ #{seat.row} , #{seat.column} ]"
  
    myfile.close()

    puts "\n\n\nReceipt printed, please take your receipt before performing a new booking. "
  end
end 









def main() 
  puts "|----------------------------------------------------------------------------------------------------------|"
  puts "|======================================= Cinema Management Software =======================================|"
  puts "|----------------------------------------------------------------------------------------------------------|\n\n\n\n"

  puts "Starting up ..... "

  puts "Startup config preparing ..... \n\n\n"

  seatConfig = seat_config() 

  seats = Array.new(seatConfig.session)

  movie_names = Array.new(seatConfig.session, movie_names)
  
  configure_seats(seats, seatConfig, movie_names) 

  movie_lists_config(seatConfig.session, movie_names)
  show_seat_config(seats, seatConfig, movie_names)

  while (true)
    operation_choice(seats, seatConfig, seatConfig.session, movie_names)
    
    puts "Exit Software "
    break if (break_mechanism()) 
  end 

  puts "Thank you for using Yan Bin's Cinema Mangement System. "
end 






main()