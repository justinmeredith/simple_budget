# This program calculates what someone/s make per month, per year,
# and what they can afford to pay monthly for a living space

# All function names end with "_func" to distinguish them from variables.
# "member" refers to a single individual involved in the budget. Each member
# is stored as a nested hash inside of the array "members"
# "members" refers to the group of individuals as a whole. They are stored
# in an array called "members".
# "user" in the context of code is a variable used to reference a nested member,
# i.e. "user = 1" would be referencing the second member of the budget.
# "user" in the context of comments and meta is referring to the person
# actually running the program.
# Comments that look like "# - - - - - - TEXT - - - - - - - #" are used to
# separate the different groupings of code blocks within the
# program. They are merely for the sake of easing the process
# of reading the code.


# This clears the terminal screen
Gem.win_platform? ? (system "cls") : (system "clear")



# - - - - - - - - - - - - - - - - - FUNCTIONS - - - - - - - - - - - - - - - - - - #

# This calculates a member's monthly income after tax
# An estimate of 10% tax is used
def monthly_income_func(hourly_pay, hours_worked)
  monthly_gross_income = hourly_pay * hours_worked * 4
  monthly_gross_income - (monthly_gross_income * 0.10)
end

# This calculates a member's annual income
def annual_income_func(monthly_net_income)
  monthly_net_income * 12
end

# This calculates the combined monthly incomes of the members
def combined_monthly_func(number_of_people, members)
  combined_monthly = 0
  if number_of_people > 1
    members.each do |user|
      # This adds the previous value of the "combined_monthly" variable to the
      # "monthly_net_income" element of each user's grouping in the array "members"
      combined_monthly += user[:monthly_income]
    end
  elsif
    # This allows for a single user to make a budget as well.
    combined_monthly += members[0][:monthly_income]
  end
  combined_monthly
end

# This calculates the combined annual incomes of the members
def combined_annually_func(number_of_people, members)
  combined_annually = 0
  if number_of_people > 1
    members.each do |user|
      # This adds the previous value of the "combined_annually" variable to the
      # "annual_income" element of each user's hash in the array "members"
      combined_annually += user[:annual_income]
    end
  elsif
    # This allows for a single user to make a budget as well.
    combined_annually += members[0][:annual_income]
  end
  return combined_annually
end

# This creates a hash for each member that contains their name, monthly income,
# and annual income
def member_register_func(user)
  member = {}

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

  # This adds each of the entered and calculated variables into a hash known as
  # "member". This hash is returned at the end of the function
  member[:name] = member_name
  member[:monthly_income] = monthly_net_income
  member[:annual_income] = annual_income
  return member
end

# This loops the function "member_register_func" for as many members as the user
# specifies
def member_register_loop_func(number_of_people)
  # This creates an empty array called "members"
  members = []
  (1..number_of_people).each do |user|
    # This runs the "member_register_func" function and stores the output hash
    # inside the variable "member"
    member = member_register_func(user)

    members.push(member)
  end
  members
end

# This prints each member's individual income at the start of the budget message
def individual_incomes_message_func(members)
  individual_incomes = []
  members.each do |user|
    message =  "\n#{user[:name]} makes $#{sprintf('%.2f', user[:monthly_income])} per month, and $#{sprintf('%.2f', user[:annual_income])} per year."

    individual_incomes << message
  end
  individual_incomes
end

# This writes all of the calculations and member information to a text file
def write_to_output_file_func(number_of_people, individual_incomes, output_budget_text_file, budget_message)
  (0...number_of_people).each do |user|
    output_budget_text_file.write(individual_incomes[user])
  end
  output_budget_text_file.write(budget_message)
end

# This helps the user(s) set and reach a savings goal
def savings_goal_func
  # This is the code
end

# This determines each individual member's monthly leftovers and adds it to their
# hash
def individual_leftovers_func(members)
  members.each do |user|
    # This runs the budget_categories_func on each member using their personal monthly_income
    budget_categories = budget_categories_func(user[:monthly_income])
    # This subtracts all the combined categories of a member's budget from their monthly income
    leftovers = user[:monthly_income] - (budget_categories[:living] + budget_categories[:bills] + budget_categories[:gas] + budget_categories[:groceries])
    # This stores the variable 'leftovers' in a new hash element for each user
    user[:leftovers] = leftovers
  end
end

# This groups the leftovers element of each member's hash
def leftovers_func(members)
  leftovers = 0
  members.each do |user|
    leftovers += user[:leftovers]
  end
  leftovers
end

# This takes in a monthly income and calculates the amounts allotted to each
# category of the budget
def budget_categories_func(monthly_income)

  # These lines calculate the various categories of the budget. They are
  # self explanatory. The percentages are averages based on research and
  # budget advising that can be found on the internet. These can be easily
  # tweaked without ramifications on the program's ability to run. While each
  # category skews towards a more conservative spending allowance,
  # the "monthly_leftovers" variable shows the user their unallocated income,
  # which can be dispersed through the other categories should the user desire.
  living = monthly_income * 0.3
  bills = monthly_income * 0.2
  gas = monthly_income * 0.2
  groceries = monthly_income * 0.18

  # This creates a hash containing the calculated categories
  budget_categories = {}
  budget_categories[:living] = living
  budget_categories[:bills] = bills
  budget_categories[:gas] = gas
  budget_categories[:groceries] = groceries

  # This returns a hash containing the calculated categories
  return budget_categories
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
# "combined_annually"
combined_annually = combined_annually_func(number_of_people, members)

# This calculates the different categories of the budget for the members as a whole
budget_categories = budget_categories_func(combined_monthly)

# This calculates each individual member's monthly leftovers
individual_leftovers_func(members)

# This calculates the group's leftovers as a whole and stores them in a variable to be
# used in the output message
group_leftovers = leftovers_func(members)



# - - - - - - - - - - - - - - - - - PRINTED MESSAGE - - - - - - - - - - - - - - - #

individual_incomes = individual_incomes_message_func(members)

budget_message = <<MSG

Combined, this household makes $#{sprintf('%.2f', combined_monthly)} per month, and $#{sprintf('%.2f', combined_annually)} per year.

Here is a break down of your monthly budget:
  * You can afford a living expense of $#{sprintf('%.2f', budget_categories[:living])}.
  * You can afford $#{sprintf('%.2f', budget_categories[:bills])} in bills.
  * You can afford $#{sprintf('%.2f', budget_categories[:gas])} in gas.
  * You can afford $#{sprintf('%.2f', budget_categories[:groceries])} in groceries and food.

This leaves roughly $#{sprintf('%.2f', group_leftovers)} left over
for spending and saving.
Keep in mind that these estimates are based on averages,
and provide room for flexibility.
Also remember to try and stay under budget so that
you have more left over each month.
MSG



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
