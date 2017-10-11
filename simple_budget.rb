# This program calculates what someone/s make per month, per year,
# and what they can afford to pay monthly for a living space

# All function names end with "_func" to distinguish them from variables.
# "member" refers to a single individual involved in the budget. Each member
# is stored as a nested array inside of the array "members"
# "members" refers to the group of individuals as a whole. They are stored
# in an array called "members".
# "user" in the context of code is a variable used to reference a nested member,
# i.e. "user = 1" would be referencing the second member of the budget.
# "user" in the context of comments and meta is referring to the person
# actually running the program.
# Comments that look like "# - - - - - - TEXT - - - - - - - #" are used to
# separate the different groupings of code blocks withing the
# program. They are merely for the sake of easing the process
# of reading the code.


# This clears the terminal screen
Gem.win_platform? ? (system "cls") : (system "clear")



# - - - - - - - - - - - - - - - - - FUNCTIONS - - - - - - - - - - - - - - - - - - #

# This calculates a member's monthly income after tax
# An estimate of 10% tax is used
def monthly_income_func(hourly_pay, hours_worked)
  monthly_gross_income = hourly_pay * hours_worked * 4
  monthly_net_income = monthly_gross_income - (monthly_gross_income * 0.10)
  return monthly_net_income
end

# This calculates a member's annual income
def annual_income_func(monthly_net_income)
  annual_income = monthly_net_income * 12
  return annual_income
end

# This calculates the combined monthly incomes of the members
def combined_monthly_func(number_of_people, members)
  combined_monthly = 0
  if number_of_people > 1
    (0...number_of_people).each do |user|
      # This adds the previous value of the "combined_monthly" variable to the
      # "monthly_net_income" element of each user's grouping in the array "members"
      combined_monthly += members[user][1]
    end
  end
  return combined_monthly
end

# This calculates the combined annual incomes of the members
def combined_annual_func(number_of_people, members)
  combined_annual = 0
  if number_of_people > 1
    (0...number_of_people).each do |user|
      # This adds the previous value of the "combined_annual" variable to the
      # "annual_income" element of each user's grouping in the array "members"s
      combined_annual += members[user][2]
    end
  end
  return combined_annual
end

# This creates an array for each member that contains their name, monthly income,
# and annual income
def member_register_func(user)
  member = []

  print "\n\nName of budget member ##{user}: "
  member_name = $stdin.gets.chomp
  print "How much does #{member_name} make an hour? $"
  hourly_pay = $stdin.gets.chomp.to_i
  print "How many hours a week does #{member_name} work? "
  hours_worked = $stdin.gets.chomp.to_i

  # This calculates the monthly net income
  monthly_net_income = monthly_income_func(hourly_pay, hours_worked)
  # This calculates the annual income
  annual_income = annual_income_func(monthly_net_income)

  # This adds each of the entered and calculated variables into an array known as
  # "member". This array is returned at the end of the function
  member << member_name
  member << monthly_net_income
  member << annual_income

  # The function outputs the "member" array
  return member
end

# This loops the function "member_register_func" for as many members as the user
# specifies
def member_register_loop_func(number_of_people)
  # This creates an empty array called "members"
  members = []
  (1..number_of_people).each do |user|
    # This runs the "member_register_func" function and stores the output array
    # inside the variable "member"
    member = member_register_func(user)

    members << member
  end
  # This returns the array "members" at the end of the function
  return members
end

# This prints each member's individual income at the start of the budget message
def individual_incomes_message_func(number_of_people, members)
  individual_incomes = []
  (0...number_of_people).each do |user|
    message =  "\n#{members[user][0]} makes $#{sprintf('%.2f', members[user][1])} per month, and $#{sprintf('%.2f', members[user][2])} per year."

    individual_incomes << message
  end
  return individual_incomes
end

# This writes all of the calculations and member information to a text file
def write_to_output_file_func(number_of_people, individual_incomes, output_budget_text_file, budget_message)
  (0...number_of_people).each do |user|
    output_budget_text_file.write(individual_incomes[user])
  end
  output_budget_text_file.write(budget_message)
end






# - - - - - - - - - - - - - - - RUNNING THE PROGRAM - - - - - - - - - - - - - - - #

print "How many people is this budget for? "
number_of_people = $stdin.gets.chomp.to_i

# This runs the function "member_register_loop_func" for the amount of people the
# user specifies above and stores the output in the variable "members"
members = member_register_loop_func(number_of_people)

# This combines the users' monthly incomes and stores it in the variable
# "combined_monthly"
combined_monthly = combined_monthly_func(number_of_people, members)

# This combines the users' annual incomes and stores them in the variable
# "combined_annual"
combined_annual = combined_annual_func(number_of_people, members)



# - - - - - - - - - - - - - - - CALCULATIONS - - - - - - - - - - - - - - - - - - #

# These lines calculate the various categories of the budget. They are
# self explanatory. The percentages are averages based on research and
# budget advising that can be found on the internet. These can be easily
# tweaked without ramifications on the program's ability to run. While each
# category skews towards a more conservative spending allowance,
# the "monthly_leftovers" variable shows the user their unallocated income,
# which can be dispersed through the other categories should the user desire.

living = combined_monthly * 0.3
bills = combined_monthly * 0.2
gas = combined_monthly * 0.2
groceries = combined_monthly * 0.18
leftover = combined_monthly - (living + bills + gas + groceries)



# - - - - - - - - - - - - - - - - - PRINTED MESSAGE - - - - - - - - - - - - - - - #

individual_incomes = individual_incomes_message_func(number_of_people, members)

budget_message = """

Combined, you make $#{sprintf('%.2f', combined_monthly)} per month, and $#{sprintf('%.2f', combined_annual)} per year.

Here is a break down of your monthly budget:
  * You can afford a living expense of $#{sprintf('%.2f', living)}.
  * You can afford $#{sprintf('%.2f', bills)} in bills.
  * You can afford $#{sprintf('%.2f', gas)} in gas.
  * You can afford $#{sprintf('%.2f', groceries)} in groceries and food.

This leaves you with roughly $#{sprintf('%.2f', leftover)} left over
for spending and saving.
Keep in mind that these estimates are based on averages,
and provide room for flexibility.
Also remember to try and stay under budget so that
you have more left over each month.
"""



# - - - - - - - - - - - - - - - - - - FILE WRITING - - - - - - - - - - - - - - - #

# This line allows the user to name their output budget file
print "\n\nWhat would you like to name your budget? "
output_file_name = $stdin.gets.chomp

# This ensures the file is a text file
output_file_name = "#{output_file_name}.txt"

# This creates the file with the name provided by the user and opens it in write
# mode.
output_budget_text_file = open(output_file_name, 'w')

# This writes to the text file named by the user
write_to_output_file_func(number_of_people, individual_incomes, output_budget_text_file, budget_message)

# This closes the file
output_budget_text_file.close

puts "\n\n\nYour budget can be found in the same folder as this program: \n\n#{Dir.pwd}\n\n\n\n"

puts "Thank you for using Simple Budget!\n\n"
