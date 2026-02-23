FROM ubuntu:22.04

LABEL org.opencontainers.image.source="https://github.com/macronex/rosetta_kic_mcp"
LABEL org.opencontainers.image.description="Rosetta KIC and GeneralizedKIC protocols for cyclic peptide modeling"

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.12 python3.12-venv python3-pip git wget \
    build-essential zlib1g-dev && \
    ln -sf /usr/bin/python3.12 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

# Core dependencies
RUN pip install --no-cache-dir \
    fastmcp loguru click pandas numpy tqdm biopython rdkit scipy

# Install PyRosetta (requires license - users must provide wheel or use conda)
# Option 1: Install from conda (if available in the build context)
# Option 2: Mount PyRosetta wheel at build time
# For now, we document the requirement
# RUN pip install --no-cache-dir pyrosetta

# Copy MCP server source
COPY --chmod=755 src/ src/

# Create writable directories for jobs/results
RUN mkdir -p /app/jobs /app/results && chmod 777 /app /app/jobs /app/results

CMD ["python", "src/server.py"]
