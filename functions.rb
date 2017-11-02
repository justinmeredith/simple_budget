# Functions.rb

# This is contains all functions for simple_budget.rb


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
    puts "    a) All members are working towards this goal."
    puts "    b) This goal belongs to one member of the budget."
    print "\n   > "
    user_answer = $stdin.gets.chomp

    if user_answer == "a"
      savings_goal_message = group_savings_goal_calculations_func(members, savings_goal)
    elsif user_answer == "b"
      savings_goal_message = individual_savings_goal_calculations_func(members, number_of_people, savings_goal)
    end
  end
  savings_goal_message
end

# This creates a savings goal for a single member and stores it in a hash.
def individual_savings_goal_calculations_func(members, number_of_people, savings_goal)

  if number_of_people == 1
    savings_goal_owner = members[0][:name]
    savings_goal_message = savings_goal_decisions_func(savings_goal_owner, members[0][:leftovers], savings_goal)

  else
    user_number = 1
    puts "\n  Which budget member does this goal belong to?"

    # This loop prints each members name as an option the user can choose
    members.each do |user|
      puts "    #{user_number}) #{user[:name]}"
      user_number += 1
    end

    print "    > "
    user_member_answer = $stdin.gets.chomp.to_i
    user_member_answer -= 1
    savings_goal_owner = members[user_member_answer][:name]
    savings_goal_message = savings_goal_decisions_func(savings_goal_owner, members[user_member_answer][:leftovers], savings_goal)
  end
  savings_goal_message
end

# This creates a savings goal for the group of members
def group_savings_goal_calculations_func(members, savings_goal)
  savings_goal_owner = "Household"
  group_leftovers = leftovers_func(members)
  savings_goal_message = savings_goal_decisions_func(savings_goal_owner, group_leftovers, savings_goal)
end

# This runs all the different decision branches for a savings goal
def savings_goal_decisions_func(savings_goal_owner, leftovers, savings_goal)
  # These calculate various monthly amounts the user can save from their leftovers
  # automatically to present to the user as preset options for savings and time frames.
  preset_1 = [(leftovers * 0.45), (savings_goal[:amount] / (leftovers * 0.45))]
  preset_2 = [(leftovers * 0.55), (savings_goal[:amount] / (leftovers * 0.55))]
  preset_3 = [(leftovers * 0.75), (savings_goal[:amount] / (leftovers * 0.75))]

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
    savings_goal_message = savings_goal_message_func(preset_1, savings_goal, savings_goal_owner)

  elsif user_answer == "b"
    savings_goal_message = savings_goal_message_func(preset_2, savings_goal, savings_goal_owner)

  elsif user_answer == "c"
    savings_goal_message = savings_goal_message_func(preset_3, savings_goal, savings_goal_owner)

  elsif user_answer == "d"
    # This while loop is here so that if the user enters an amount to save
    # monthly greater than there leftovers, they can quickly be brought back to
    # this point.
    while true
      puts "\nYou have $#{sprintf('%.2f', leftovers)} left over each month, so don't try to save more than that each month."
      print "\nHow much would you like to save each month? $"
      monthly_savings = $stdin.gets.chomp.to_f

      if monthly_savings > leftovers
        puts "\nYou shouldn't set a monthly saving goal that is greater than the amount you have"
        puts "leftover at the end of each month. You can always save more than you set for"
        puts "your monthly goal, but you should keep the goal realistic."

      else
        savings_goal_calculations = [monthly_savings, savings_goal[:amount] / monthly_savings]
        savings_goal_message = savings_goal_message_func(savings_goal_calculations, savings_goal, savings_goal_owner)
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
def savings_goal_message_func(savings_goal_calculations, savings_goal, savings_goal_owner)
  savings_goal_message = <<~SAVINGSMESSAGE


  ~ SAVINGS GOAL ~
  #{savings_goal_owner}'s Goal
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
