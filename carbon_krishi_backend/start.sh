# CarbonKrishi Backend - Start Script
#!/bin/bash

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run the backend server
echo "Starting CarbonKrishi Backend on port 8000..."
python -m uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload

