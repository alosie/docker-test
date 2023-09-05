#!/bin/bash

# Check if Java is available
if command -v java >/dev/null 2>&1; then
    echo "Java is installed."
    java -version
else
    echo "Java is not installed."
fi
