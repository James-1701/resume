# Build the resume PDF and PNG
build:
    pnpm node scripts/build-resume.js

# Install dependencies
install:
    pnpm install

# Clean build output
clean:
    rm -rf dist
