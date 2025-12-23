FROM ubuntu:22.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required dependencies
RUN apt-get update && apt-get install -y \
    g++ \
    make \
    libomp-dev \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy the project files into the container
COPY . /app

# Build the project
RUN make all

# Build the edgelist converter
RUN g++ -std=c++17 -O2 -o edgelist_to_cuttana edgelist_to_cuttana.cpp

# Create output directory for partitioned files
RUN mkdir -p partitioned_files

# Default command (example usage)
CMD ["./ogpart", "-d", "examples/emailEnron.txt", "-p", "4", "-subp", "256", "-b", "1.05", "-vb", "1"]
