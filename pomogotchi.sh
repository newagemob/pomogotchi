#!/bin/bash

# Initialize variables
total_time=0
total_work_time=0
total_break_time=0
work_sessions=0
breaks=0
working=false

# formatted countdown timer
display_timer() {
    local timer="$1" # Remaining time in seconds
    local max="$2"   # Maximum time in seconds

    local timer_minutes
    local timer_seconds

    # Calculate minutes and seconds
    timer_minutes=$(printf "%02d" $(($timer / 60)))
    timer_seconds=$(printf "%02d" $(($timer % 60)))

    # Display the formatted time countdown
    if [ "$working" = false ]; then
        echo -ne "\t break 🟢 : $timer_minutes:$timer_seconds / $(($max / 60)):$((max % 60)) \t session: $work_sessions, breaks: $total_break_time ⏰: $total_time \r"
    fi
    if [ "$working" = true ]; then
        echo -ne "\t work 🔵 : $timer_minutes:$timer_seconds / $(($max / 60)):$((max % 60)) \t session: $work_sessions, work: $total_work_time ⏰: $total_time \r"
    fi
}

play_start_notification() {
    local os=$(uname -s)

    # Check the operating system
    if [ "$os" == "Linux" ]; then
        # Linux: Use 'aplay' command
        if command -v aplay >/dev/null 2>&1; then
            # Play a notification sound
            aplay -q ./audio/startup_sound.mp3
        else
            echo "Notification sound can't be played. Install 'alsa-utils' package to enable sound playback."
        fi
    elif [ "$os" == "Darwin" ]; then
        # macOS: Use 'afplay' command
        if command -v afplay >/dev/null 2>&1; then
            # Play a notification sound
            afplay ./audio/startup_sound.mp3
        else
            echo "Notification sound can't be played. 'afplay' command is not available."
        fi
    else
        echo "Unsupported operating system: $os"
    fi
}

play_stop_notification() {
    local os=$(uname -s)

    # Check the operating system
    if [ "$os" == "Linux" ]; then
        # Linux: Use 'aplay' command
        if command -v aplay >/dev/null 2>&1; then
            # Play a notification sound
            aplay -q ./audio/crash_sound.mp3
        else
            echo "Notification sound can't be played. Install 'alsa-utils' package to enable sound playback."
        fi
    elif [ "$os" == "Darwin" ]; then
        # macOS: Use 'afplay' command
        if command -v afplay >/dev/null 2>&1; then
            # Play a notification sound
            afplay ./audio/crash_sound.mp3
        else
            echo "Notification sound can't be played. 'afplay' command is not available."
        fi
    else
        echo "Unsupported operating system: $os"
    fi
}

start_pomodoro() {
    local work_time="$1"  # Pomodoro work time in seconds
    local break_time="$2" # Break time in seconds

    local timer_start
    local timer_end

    # Loop for Pomodoro cycles
    while true; do
        ((work_sessions++))
        play_start_notification
        # Work time
        working=true
        timer_start=$(date +%s)
        timer_end=$((timer_start + work_time))
        display_timer "$work_time" "$work_time"
        while [ "$(date +%s)" -lt "$timer_end" ]; do
            display_timer "$(($timer_end - $(date +%s)))" "$work_time"
            sleep 1
        done

        ((total_time += work_time))
        ((total_work_time += work_time))
        play_stop_notification
        ((breaks++))
        # Break time
        working=false
        timer_start=$(date +%s)
        timer_end=$((timer_start + break_time))
        display_timer "$break_time" "$break_time"
        while [ "$(date +%s)" -lt "$timer_end" ]; do
            display_timer "$(($timer_end - $(date +%s)))" "$break_time"
            sleep 1
        done

        ((total_time += break_time))
        ((total_break_time += break_time))
    done
}

# Main script

work_duration=25*60 # Pomodoro work time in seconds (default: 25 minutes)
break_duration=5*60 # Break time in seconds (default: 5 minutes)

start_pomodoro "$work_duration" "$break_duration"
