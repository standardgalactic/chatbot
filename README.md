# Chatbot: Automatic Dialog Simulator

## Overview
The `chatbot` repository contains a Bash script that simulates a conversation among three AI bots—AnalystBot, CreativeBot, and SkepticBot—using IBM's Granite model. The script generates dynamic, multi-turn dialogues based on a user-specified topic, saves each bot's responses to dedicated folders, compiles a central summary, and displays all outputs in the terminal.

## Functionality
- **Conversation Simulation**: Three bots with distinct personalities (logical, creative, critical) engage in a dialogue over multiple turns.
- **Input**: Reads a starter prompt from `starter_prompt.txt` in the current directory or uses a default prompt (e.g., discussing AI in education).
- **Output**:
  - Individual bot responses saved to `./bot_conversation_outputs/{AnalystBot,CreativeBot,SkepticBot}/turn_*.txt`.
  - Central summary compiled in `./bot_conversation_outputs/conversation_summary.txt`.
  - Progress logged to `./progress.log`.
  - All outputs displayed in the terminal using `tee`.
- **Model**: Leverages the `granite3.2:8b` model via Ollama, utilizing its thinking capability for enhanced response quality.

## Use of IBM Granite Model
The script employs IBM's Granite model (`granite3.2:8b`), a decoder-only foundation model with 8 billion parameters, optimized for tasks like natural language processing and code generation. Trained on diverse datasets, including Internet content, academic publications, code, and legal/financial documents, Granite delivers coherent, context-aware responses. Released under the Apache 2.0 license, it is integrated via Ollama for local execution of the conversation simulation.

## Usage
1. **Prerequisites**:
   - Install [Ollama](https://ollama.ai/) and pull the Granite model: `ollama pull granite3.2:8b`.
   - Ensure Bash and write permissions in the current directory.
2. **Setup**:
   - (Optional) Create `starter_prompt.txt` with a conversation topic.
   - Save the script as `chat.sh` and make it executable: `chmod +x chat.sh`.
3. **Run**:
   ```bash
   ./chat.sh
   ```
4. **Outputs**:
   - Bot responses and summary in `./bot_conversation_outputs/`.
   - Logs in `./progress.log`.

## License
This project is licensed under the MIT License.
