#!/usr/bin/expect

# Set the log file path
set log_file_path "/path/to/your/log/file.log"

# Define options and their corresponding values
set options {
    {1 UnitedStates 111.111.111.111 USER1 PASSWORD1 22}
    {2 Netherland 222.222.222.222 USER2 PASSWORD2 2222}
    {3 Germany 333.333.333.333 USER3 PASSWORD3 3333}
    {4 Russia 444.444.444.444 USER4 PASSWORD4 4444}
}

# Function to log messages
proc log_message {message} {
    global log_file_path
    set timestamp [timestamp -format {%Y-%m-%d %H:%M:%S}]
    set log_entry "$timestamp: $message"
    puts $log_entry
    # Append the log entry to the log file
    set log_file [open $log_file_path a]
    puts $log_file $log_entry
    close $log_file
}

# Function to close the SSH connection
proc close_ssh_connection {ip_address port} {
    log_message "Closing SSH connection to $ip_address:$port"
    exec ssh -S /tmp/sshtunnel -O exit $ip_address -p $port
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

    # Wait for user input to close the SSH connection
    puts "Press Enter to close the SSH connection..."
    gets stdin
    close_ssh_connection $ip_address $port

    log_message "Script exited!"
    exit
}
