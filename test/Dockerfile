# Dockerfile for testing package installation
# Note: Cannot test GUI/systemd, only package installation

FROM archlinux:latest

# Update system
RUN pacman -Syu --noconfirm

# Create test user
RUN useradd -m -G wheel -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install git
RUN pacman -S --noconfirm git

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy dotfiles
COPY --chown=testuser:testuser . /home/testuser/dotfiles

# Test package parsing (dry-run)
RUN cd /home/testuser/dotfiles && \
    echo "=== Testing package list parsing ===" && \
    for f in packages/*.pkg; do \
        echo "Checking $f..."; \
        grep -v '^#' "$f" | grep -v '^$' | cut -d'#' -f1 | tr -d ' ' | head -5; \
    done

# Verify stow structure
RUN echo "=== Verifying stow structure ===" && \
    ls -la /home/testuser/dotfiles/

CMD ["bash"]
