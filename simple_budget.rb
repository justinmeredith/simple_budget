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
# program. They are called 'chapters' and are merely for the sake of easing the
# process of reading the code.
# Comments that look like '# ~ ~ ~ ~ TEXT ~ ~ ~ ~ #' are used to further break
# up the chapters for easier reading. These are called 'subchapters'.


# This clears the terminal screen.
Gem.win_platform? ? (system "cls") : (system "clear")

# This variable is to be used later in the program for functions/code that will
# only run if there is a savings goal set.
is_there_a_savings_goal = false



# - - - - - - - - - - - - - - - - - FUNCTIONS - - - - - - - - - - - - - - - - - - #


# ~ ~ ~ ~ CALCULATIONS ~ ~ ~ ~ #

# This calculates a member's monthly income after tax.
# An estimate of 10% tax is used.
def monthly_income_func(hourly_pay, hours_worked)
  monthly_gross_income = hourly_pay * hours_worked * 4
  monthly_gross_income - (monthly_gross_income * 0.10)
end

# This calculates a member's annual income.
def annual_income_func(monthly_net_income)
  monthly_net_income * 12
end

# This calculates the combined monthly incomes of the members.
def combined_monthly_func(number_of_people, members)
  combined_monthly = 0
  if number_of_people > 1
    members.each do |user|
      # This adds the previous value of the "combined_monthly" variable to the
      # "monthly_net_income" element of each user's grouping in the array "members".
      combined_monthly += user[:monthly_income]
    end
  elsif
    # This allows for a single user to make a budget as well.
    combined_monthly += members[0][:monthly_income]
  end
  combined_monthly
end

# This calculates the combined annual incomes of the members.
def combined_annually_func(number_of_people, members)
  combined_annually = 0
  if number_of_people > 1
    members.each do |user|
      # This adds the previous value of the "combined_annually" variable to the
      # "annual_income" element of each user's hash in the array "members".
      combined_annually += user[:annual_income]
    end
  elsif
    # This allows for a single user to make a budget as well.
    combined_annually += members[0][:annual_income]
  end
  return combined_annually
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

# This groups the 'leftovers' element of each member's hash
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


# ~ ~ ~ ~ MEMBER REGISTRATION ~ ~ ~ ~ #

# This creates a hash for each member that contains their name, monthly income,
# and annual income.
def member_register_func(user)
  member = {}

  print "\n\nName of budget member ##{user}: "
  member_name = $stdin.gets.chomp
  print "How much does #{member_name} make an hour? $"
  hourly_pay = $stdin.gets.chomp.to_f
  print "How many hours a week does #{member_name} work? "
  hours_worked = $stdin.gets.chomp.to_f

  # This calculates the monthly net income.
  monthly_net_income = monthly_income_func(hourly_pay, hours_worked)
  # This calculates the annual income.
  annual_income = annual_income_func(monthly_net_income)

  # This adds each of the entered and calculated variables into a hash known as
  # "member". This hash is returned at the end of the function.
  member[:name] = member_name
  member[:monthly_income] = monthly_net_income
  member[:annual_income] = annual_income
  return member
end

# This loops the function "member_register_func" for as many members as the user
# specifies.
def member_register_loop_func(number_of_people)
  # This creates an empty array called "members".
  members = []
  (1..number_of_people).each do |user|
    # This runs the "member_register_func" function and stores the output hash
    # inside the variable "member".
    member = member_register_func(user)

    members.push(member)
  end
  members
end


# ~ ~ ~ ~ SAVINGS FEATURE ~ ~ ~ ~ #

# This helps the user(s) set and reach a savings goal
def savings_goal_func(members, number_of_people)
  # These lines register the name and amount of the goal and store it in a hash
  print "\nWhat would you like to name your goal (ex. New car, vacation, etc.)? "
  goal_name = $stdin.gets.chomp
  print "How much money do you need to save to reach this goal? $"
  goal_amount = $stdin.gets.chomp.to_f

  # This creates a hash that stores the name and amount of the goal
  savings_goal = {}
  savings_goal[:name] = goal_name
  savings_goal[:amount] = goal_amount

  # These lines determine if the goal is shared or individual and runs the
  # appropriate function
  if number_of_people == 1
    # This runs the individual_savings_goal_calculations_func and stores the answer
    # in savings_goal_message
    savings_goal_message = individual_savings_goal_calculations_func(members, number_of_people, savings_goal)
  elsif number_of_people > 1
    puts "\n  Is this a shared goal between members or an individual goal?"
    puts "    1) All members are working towards this goal."
    puts "    2) This goal belongs to one member of the budget."
    print "\n   > "
    user_answer = $stdin.gets.chomp.to_i

    if user_answer == 1
      savings_goal_message = group_savings_goal_calculations_func(members, savings_goal)
    elsif user_answer == 2
      savings_goal_message = individual_savings_goal_calculations_func(members, number_of_people, savings_goal)
    end
  end
  savings_goal_message
end

# This creates a savings goal for a single member and stores it in a hash.
def individual_savings_goal_calculations_func(members, number_of_people, savings_goal)
  if number_of_people == 1
    # These calculate various monthly amounts the user can save from their leftovers
    # automatically to present to the user as preset options for savings and time frames.
    preset_1 = [(members[0][:leftovers] * 0.45), (savings_goal[:amount] / (members[0][:leftovers] * 0.45))]
    preset_2 = [(members[0][:leftovers] * 0.55), (savings_goal[:amount] / (members[0][:leftovers] * 0.55))]
    preset_3 = [(members[0][:leftovers] * 0.75), (savings_goal[:amount] / (members[0][:leftovers] * 0.75))]

    # This presents the above calculations to the user and asks them to choose
    # one of the options.
    puts "\n  How much would you like to save each month?"
    puts "    a) Save $#{sprintf('%.2f', preset_1[0])} each month for #{sprintf('%.0f', preset_1[1])} months."
    puts "    b) Save $#{sprintf('%.2f', preset_2[0])} each month for #{sprintf('%.0f', preset_2[1])} months."
    puts "    c) Save $#{sprintf('%.2f', preset_3[0])} each month for #{sprintf('%.0f', preset_3[1])} months."
    puts "    d) Set your own monthly amount."
    print "\n   > "
    user_answer = $stdin.gets.chomp

    # These take the user's answer, perform the according function, and store the
    # printed savings message in a variable.
    if user_answer == "a"
      savings_goal_message = savings_goal_message_func(preset_1, savings_goal)

    elsif user_answer == "b"
      savings_goal_message = savings_goal_message_func(preset_2, savings_goal)

    elsif user_answer == "c"
      savings_goal_message = savings_goal_message_func(preset_3, savings_goal)

    elsif user_answer == "d"
      # This while loop is here so that if the user enters an amount to save
      # monthly greater than there leftovers, they can quickly be brought back to
      # this point.
      while true
        puts "\nYou have $#{sprintf('%.2f', members[0][:leftovers])} left over each month, so don't try to save more than that each month."
        print "\nHow much would you like to save each month? $"
        monthly_savings = $stdin.gets.chomp.to_f

        if monthly_savings > members[0][:leftovers]
          puts "\nYou shouldn't set a monthly saving goal that is greater than the amount you have"
          puts "leftover at the end of each month. You can always save more than you set for"
          puts "your monthly goal, but you should keep the goal realistic."

        else
          savings_goal_calculations = [monthly_savings, savings_goal[:amount] / monthly_savings]
          savings_goal_message = savings_goal_message_func(savings_goal_calculations, savings_goal)
          break
        end

      end
    end
  end
  savings_goal_message
end

# This creates a savings goal for the group of members and stores it in a hash
def group_savings_goal_calculations_func(members, savings_goal)
  group_leftovers = leftovers_func(members)
  # These calculate various monthly amounts the user can save from their leftovers
  # automatically to present to the user as preset options for savings and time frames.
  preset_1 = [(group_leftovers * 0.45), (savings_goal[:amount] / (group_leftovers * 0.45))]
  preset_2 = [(group_leftovers * 0.55), (savings_goal[:amount] / (group_leftovers * 0.55))]
  preset_3 = [(group_leftovers * 0.75), (savings_goal[:amount] / (group_leftovers * 0.75))]

  # This presents the above calculations to the user and asks them to choose
  # one of the options.
  puts "\n  How much would you like to save each month?"
  puts "    a) Save $#{sprintf('%.2f', preset_1[0])} each month for #{sprintf('%.0f', preset_1[1])} months."
  puts "    b) Save $#{sprintf('%.2f', preset_2[0])} each month for #{sprintf('%.0f', preset_2[1])} months."
  puts "    c) Save $#{sprintf('%.2f', preset_3[0])} each month for #{sprintf('%.0f', preset_3[1])} months."
  puts "    d) Set your own monthly amount."
  print "\n   > "
  user_answer = $stdin.gets.chomp

  # These take the user's answer, perform the according function, and store the
  # printed savings message in a variable.
  if user_answer == "a"
    savings_goal_message = savings_goal_message_func(preset_1, savings_goal)

  elsif user_answer == "b"
    savings_goal_message = savings_goal_message_func(preset_2, savings_goal)

  elsif user_answer == "c"
    savings_goal_message = savings_goal_message_func(preset_3, savings_goal)

  elsif user_answer == "d"
    # This while loop is here so that if the user enters an amount to save
    # monthly greater than there leftovers, they can quickly be brought back to
    # this point.
    while true
      puts "\nYou have $#{sprintf('%.2f', group_leftovers)} left over each month, so don't try to save more than that each month."
      print "\nHow much would you like to save each month? $"
      monthly_savings = $stdin.gets.chomp.to_f

      if monthly_savings > group_leftovers
        puts "\nYou shouldn't set a monthly saving goal that is greater than the amount you have"
        puts "leftover at the end of each month. You can always save more than you set for"
        puts "your monthly goal, but you should keep the goal realistic."

      else
        savings_goal_calculations = [monthly_savings, savings_goal[:amount] / monthly_savings]
        savings_goal_message = savings_goal_message_func(savings_goal_calculations, savings_goal)
        break
      end
    end
  end
  savings_goal_message
end


# ~ ~ ~ ~ OUTPUT FILE ~ ~ ~ ~ #

# This prints each member's individual income at the start of the budget message.
def individual_incomes_message_func(members)
  individual_incomes = []
  members.each do |user|
    message =  "\n#{user[:name]} makes $#{sprintf('%.2f', user[:monthly_income])} per month, and $#{sprintf('%.2f', user[:annual_income])} per year."

    individual_incomes << message
  end
  individual_incomes
end

# This creates a message containing the savings goal (if there is one) to be written
# to the output file later
def savings_goal_message_func(savings_goal_calculations, savings_goal)
  savings_goal_message = <<~SAVINGSMESSAGE


  ~ SAVINGS GOAL ~
  If you save $#{sprintf('%.2f', savings_goal_calculations[0])} each month,
  you will reach your #{savings_goal[:name]} goal in #{sprintf('%.0f', savings_goal_calculations[1])} months.
  Stick to it! You'll be glad you did.
  SAVINGSMESSAGE
end

# This writes all of the calculations and member information to a text file.
def write_to_output_file_func(output_file_name, number_of_people, individual_incomes, output_budget_text_file, budget_message, savings_goal_message, is_there_a_savings_goal)
  output_budget_text_file.write("~ ~ ~ #{output_file_name} ~ ~ ~\n\n\n")
  output_budget_text_file.write("~ INCOME ~")
  (0..number_of_people).each do |user|
    output_budget_text_file.write(individual_incomes[user])
  end
  output_budget_text_file.write(budget_message)
  # This makes sure that the program will not try to write a savings goal message if there
  # isn't one.
  if is_there_a_savings_goal == true
    output_budget_text_file.write(savings_goal_message)
  end
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

print "\n\nWould you like to set a savings goal (yes/no)? "
# If the user answers yes, savings goal function runs and returns the
# savings_goal_message from the savings goal message function.
user_answer = $stdin.gets.chomp
if user_answer == "yes" || user_answer == "y"
  savings_goal_message = savings_goal_func(members, number_of_people)
  is_there_a_savings_goal = true
end



# - - - - - - - - - - - - - - - - - PRINTED MESSAGE - - - - - - - - - - - - - - - #

individual_incomes = individual_incomes_message_func(members)

budget_message = <<~BUDGETMESSAGE

Combined, this household makes $#{sprintf('%.2f', combined_monthly)} per month, and $#{sprintf('%.2f', combined_annually)} per year.


~ BUDGET ~
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
BUDGETMESSAGE



# - - - - - - - - - - - - - - - - - - FILE WRITING - - - - - - - - - - - - - - - #

# This line allows the user to name their output budget file
print "\n\nWhat would you like to name your budget? "
output_file_name = $stdin.gets.chomp

# This ensures the file is a text file
output_file_name_extended = "#{output_file_name}.txt"

# This creates the file with the name provided by the user and opens it in write
# mode.
output_budget_text_file = open(output_file_name_extended, 'w')

# This writes to the text file named by the user
write_to_output_file_func(output_file_name, number_of_people, individual_incomes, output_budget_text_file, budget_message, savings_goal_message, is_there_a_savings_goal)

# This closes the file
output_budget_text_file.close

puts "\n\n\nYour budget can be found in the same folder as this program: \n\n#{Dir.pwd}\n\n\n\n"

puts "Thank you for using Simple Budget!\n\n"
