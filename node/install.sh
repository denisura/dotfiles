#!/usr/bin/env bash
#
# Install Node CLI packages from Nodefile

set -e

# Check if yarn is available
if ! command -v yarn >/dev/null 2>&1; then
  echo "yarn is not installed. Please install yarn first."
  exit 1
fi

# Get the dotfiles directory (parent of node directory)
DOTFILES_ROOT=$(dirname "$(dirname "$0")")
NODEFILE="$DOTFILES_ROOT/Nodefile"

# Check if Nodefile exists
if [[ ! -f "$NODEFILE" ]]; then
  echo "Nodefile not found at $NODEFILE"
  exit 1
fi

echo "› Installing Node CLI packages from Nodefile using yarn"

# Read Nodefile and install packages
playwright_installed=false
while IFS= read -r line || [[ -n "$line" ]]; do
  # Skip empty lines and comments
  if [[ -z "$line" ]] || [[ "$line" =~ ^[[:space:]]*# ]]; then
    continue
  fi
  
  # Remove leading/trailing whitespace
  package=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  
  # Skip if package is empty after trimming
  if [[ -z "$package" ]]; then
    continue
  fi
  
  # Check if this is playwright or @playwright/test
  if [[ "$package" == "playwright" ]] || [[ "$package" == "@playwright/test" ]]; then
    playwright_installed=true
  fi
  
  # Check if package is already installed globally
  if yarn global list --depth=0 2>/dev/null | grep -q "^info \"$package@"; then
    echo "✓ $package is already installed"
  else
    echo "Installing $package..."
    yarn global add "$package"
  fi
done < "$NODEFILE"

echo "✓ Node CLI packages installation complete"

# Handle Playwright browser installation if Playwright was installed
if [[ "$playwright_installed" == "true" ]]; then
  echo "› Setting up Playwright browsers"
  
  # Create the MS cache directory if it doesn't exist
  PLAYWRIGHT_CACHE_DIR="$HOME/Library/Caches/ms-playwright"
  mkdir -p "$PLAYWRIGHT_CACHE_DIR"
  
  # Install browsers to the MS cache location (where vibe-tools expects them)
  echo "Installing Playwright browsers..."
  if PLAYWRIGHT_BROWSERS_PATH="$PLAYWRIGHT_CACHE_DIR" playwright install --with-deps >/dev/null 2>&1; then
    echo "✓ Playwright browsers installed successfully"
    
    # Handle potential version mismatches by creating symlinks
    # This helps with tools like vibe-tools that might expect specific versions
    cd "$PLAYWRIGHT_CACHE_DIR"
    
    # Find all chromium_headless_shell directories and create symlinks for common version numbers
    for dir in chromium_headless_shell-*; do
      if [[ -d "$dir" ]]; then
        current_version=$(echo "$dir" | sed 's/chromium_headless_shell-//')
        
        # Create symlinks for common version numbers that tools might expect
        for expected_version in 1169 1170 1171 1172 1173 1174 1175 1176 1177 1178; do
          expected_dir="chromium_headless_shell-$expected_version"
          if [[ ! -e "$expected_dir" ]] && [[ "$expected_version" != "$current_version" ]]; then
            ln -sf "$dir" "$expected_dir"
            echo "✓ Created compatibility symlink: $expected_dir -> $dir"
          fi
        done
        break # Only need to process the first (and likely only) version
      fi
    done
    
    echo "✓ Playwright browser setup complete"
  else
    echo "⚠ Warning: Failed to install Playwright browsers automatically"
    echo "  You may need to run 'playwright install' manually if you encounter browser issues"
  fi
fi
