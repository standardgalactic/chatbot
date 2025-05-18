#!/bin/bash

# Configuration
MODEL="granite3.2:8b"
NUM_TURNS=5
MAIN_DIR=$(pwd)
OUTPUT_DIR="$MAIN_DIR/bot_conversation_outputs"
SUMMARY_FILE="$OUTPUT_DIR/conversation_summary.txt"
PROGRESS_FILE="$MAIN_DIR/progress.log"
STARTER_PROMPT_FILE="$MAIN_DIR/starter_prompt.txt"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Bot configurations
declare -A BOTS=(
    ["AnalystBot"]="You are AnalystBot, a logical and data-driven AI. Provide precise, fact-based responses with a focus on clarity and reasoning."
    ["CreativeBot"]="You are CreativeBot, an imaginative and expressive AI. Offer creative ideas and storytelling elements in your responses."
    ["SkepticBot"]="You are SkepticBot, a critical and questioning AI. Challenge ideas and ask probing questions to deepen the discussion."
)

# Create directories and files
ensure_directories() {
    mkdir -p "$OUTPUT_DIR"
    for bot in "${!BOTS[@]}"; do
        mkdir -p "$OUTPUT_DIR/$bot"
    done
    touch "$SUMMARY_FILE"
    touch "$PROGRESS_FILE"
}

# Log messages
log_progress() {
    echo "$(date): $1" >> "$PROGRESS_FILE"
}

# Save bot output
save_bot_output() {
    local bot=$1
    local turn=$2
    local response=$3
    local output_file="$OUTPUT_DIR/$bot/turn_${turn}_${TIMESTAMP}.txt"
    {
        echo "Bot: $bot"
        echo "Turn: $turn"
        echo "Timestamp: $TIMESTAMP"
        echo ""
        echo "$response"
    } | tee "$output_file"
    log_progress "Saved output for $bot, turn $turn to $output_file"
}

# Append to summary
append_to_summary() {
    local turn=$1
    local bot=$2
    local response=$3
    {
        echo "Turn $turn - $bot:"
        echo "$response"
        echo ""
    } | tee -a "$SUMMARY_FILE"
}

# Read starter prompt from file or use default
get_starter_prompt() {
    if [ -f "$STARTER_PROMPT_FILE" ] && [ -s "$STARTER_PROMPT_FILE" ]; then
        log_progress "Reading starter prompt from $STARTER_PROMPT_FILE"
        cat "$STARTER_PROMPT_FILE"
    else
        log_progress "No valid starter prompt file found; using default prompt"
        echo "Let's discuss the future of AI in education. How can AI transform learning experiences?"
    fi
}

# Simulate conversation
simulate_conversation() {
    log_progress "Script started"
    log_progress "Summaries will be saved to $SUMMARY_FILE"

    # Append conversation header (no overwrite)
    {
        echo ""
        echo "========================================"
        echo "Conversation Summary - $TIMESTAMP"
        echo "Topic: Initiated from starter prompt"
        echo ""
    } | tee -a "$SUMMARY_FILE"

    # Read initial prompt
    current_prompt=$(get_starter_prompt)
    echo "Initial Prompt: $current_prompt"

    for ((turn=1; turn<=NUM_TURNS; turn++)); do
        for bot in "${!BOTS[@]}"; do
            log_progress "Processing $bot, turn $turn"

            # Create temporary file for prompt
            temp_prompt=$(mktemp)
            {
                echo "[System]: ${BOTS[$bot]}"
                echo "[Control]: thinking"
                echo "[Human]: $current_prompt"
            } > "$temp_prompt"

            # Generate response
            response=$(ollama run "$MODEL" < "$temp_prompt" 2>/dev/null)
            if [ $? -ne 0 ]; then
                response="Error generating response for $bot"
                log_progress "$response"
            fi

            # Output, save, and summarize
            echo "Response from $bot (Turn $turn):"
            echo "$response"
            save_bot_output "$bot" "$turn" "$response"
            append_to_summary "$turn" "$bot" "$response"

            # Update prompt
            current_prompt="$current_prompt\n$bot said: $response\nWhat are your thoughts?"

            # Cleanup
            rm -f "$temp_prompt"
            sleep 1
        done
    done

    log_progress "Script completed"
}

# Main execution
ensure_directories
simulate_conversation

echo "Conversation completed. Outputs in $OUTPUT_DIR and summary in $SUMMARY_FILE"
