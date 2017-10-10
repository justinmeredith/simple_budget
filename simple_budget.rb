# This program calculates what someone/s make per month, per year,
# and what they can afford to pay monthly for a living space

# This clears the terminal screen
Gem.win_platform? ? (system "cls") : (system "clear")

$loop_count = 0

# - - - - - - - - - - - - - - - - - FUNCTIONS - - - - - - - - - - - - - - - - - - #

# This calculates a person's monthly income after tax
# An estimate of 10% tax is used
def monthly_income(hourly_pay, hours_worked)
  monthly_gross_income = hourly_pay * hours_worked * 4
  monthly_net_income = monthly_gross_income - (monthly_gross_income * 0.10)
  return monthly_net_income
end

# This calculates a person's yearly income
def annual_income(monthly_net_income)
  yearly_income = monthly_net_income * 12
  return yearly_income
end

def combined_incomes(monthly_net_income, yearly_income)
  # This will add up all the user's income
end

# This creates an array for each member that contains their name, monthly income,
# and annual income
def member_register(user)
  member = []

  print "\n\nName of budget member ##{user}: "
  member_name = $stdin.gets.chomp
  print "How much does #{member_name} make an hour? $"
  hourly_pay = $stdin.gets.chomp.to_i
  print "How many hours a week does #{member_name} work? "
  hours_worked = $stdin.gets.chomp.to_i

  monthly_net_income = monthly_income(hourly_pay, hours_worked)
  yearly_income = annual_income(monthly_net_income)

  member << member_name
  member << monthly_net_income
  member << yearly_income
  puts member

  return member
end

# This loops the function member_register for as many members as the user
# specifies
def member_register_loop(number_of_people)
  (1..number_of_people).each do |user|
    #members = []
    #members.push(member_register(user))
    #members[user] << (member_register(user))
    member = member_register(user)

    $loop_count = $loop_count + 1
    puts $loop_count

    return member
  end
end


# - - - - - - - - - - - - - - - USER INPUT - - - - - - - - - - - - - - - - - - - - #

print "How many people is this budget for? "
number_of_people = $stdin.gets.chomp.to_i

members = Array.new
members << member_register_loop(number_of_people)
puts members

# - - - - - - - - - - - - - - - CALCULATIONS - - - - - - - - - - - - - - - - - - - #

# These calculate what we can afford each month; i.e., our budget
#rent = combined_monthly * 0.3
#bills = combined_monthly * 0.2
#gas = combined_monthly * 0.2
#groceries = combined_monthly * 0.18
#monthly_leftovers = combined_monthly - (rent + bills + gas + groceries)



# - - - - - - - - - - - - - - - - - PRINTED MESSAGE - - - - - - - - - - - - - - - #

#budget_printed = """
#Justin makes $#{sprintf('%.2f', justins_monthly_net)} a month, and Brandi makes $#{sprintf('%.2f', brandis_monthly_net)} a month.
#Combined, this is $#{sprintf('%.2f', combined_monthly)}.
#Justin makes $#{sprintf('%.2f', justins_salary)} a year, and Brandi makes $#{sprintf('%.2f', brandis_salary)} a year.
#Combined, we make $#{sprintf('%.2f', combined_salary)} a year.

#Here is a break down of our monthly budget:
#  * You can afford a living expense of around $#{sprintf('%.2f', rent)}.
#  * You can afford around $#{sprintf('%.2f', bills)} in bills.
#  * You can afford around $#{sprintf('%.2f', gas)} in gas.
#  * You can afford around $#{sprintf('%.2f', groceries)} in groceries and food.

#This leaves you with roughly $#{sprintf('%.2f', monthly_leftovers)} left over for spending and saving.
#Keep in mind that these estimates are based on loose averages,
#and provide room for flexibility.
#Also remember that you should try to stay under budget so that
#you have more left over each month.
#{}"""

# This prints out that information
# I have decided to leave this part of the code out since it seems redundant to show it to the user
# and print it to a text file. I am not removing this line completely though in case I change my mind.
#puts "\n#{budget_printed}"



# - - - - - - - - - - - - - - - - - - FILE WRITING - - - - - - - - - - - - - - - - #

# This line allows the user to name their output budget file
#print "\n\nWhat would you like to name your budget? "
#output_file_name = $stdin.gets.chomp

# This ensures the file is a text file
#output_file_name = "#{output_file_name}.txt"

# This changes the directory to the budget folder
# It would be good for in the future to figure out how to have it autmatically place it in the correct year folder
# This method means each year I'll have to change this code manually
#Dir.chdir "/users/jmere/desktop/life/finances/monthly budgets/2017"
#output_file = open(output_file_name, 'w')

# This writes to the text file named by the user
#output_file.write(budget_printed)

#output_file.close
