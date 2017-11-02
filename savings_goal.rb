#Savings_Goal


# This helps the user set a savings goal.
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
