#!/usr/bin/expect

# Define options and their corresponding values
set options {
    {1 UnitedStates 111.111.111.111 USER1 PASSWORD1 22}
    {2 Netherland 222.222.222.222 USER2 PASSWORD2 2222}
    {3 Germany 333.333.333.333 USER3 PASSWORD3 3333}
    {4 Russia 444.444.444.444 USER4 PASSWORD4 4444}
}

# Prompt the user to choose an option
puts "Please select an option:"
foreach option $options {
    set option_num [lindex $option 0]
    set country [lindex $option 1]
    set port [lindex $option 5]
    puts "$option_num. $country / [lindex $option 2]:$port"
}
set option [gets stdin]

# Find the selected option and extract values
set selected_option {}
foreach opt $options {
    if {[lindex $opt 0] == $option} {
        set selected_option $opt
        break
    }
}

# Check if a valid option was selected
if {$selected_option eq {}} {
    set valid_options [lmap opt $options { lindex $opt 0 }]
    set valid_options_str [join $valid_options ", "]
    puts "Invalid option. Please choose one of the following options: $valid_options_str."
    exit 1
}

# Extract option details
lassign $selected_option option_num country ip_address username password port

# Run the SSH command based on the user's choice
spawn ssh -f -N -M -S /tmp/sshtunnel -D 1088 -p $port $username@$ip_address

# Enter the password using expect
expect {
    "password:" {
        send "$password\r"
        exp_continue
    }
    "Enter passphrase" {
        send "$password\r"
        exp_continue
    }
    eof {
        puts "SSH connection closed"
    }
}
