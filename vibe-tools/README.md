# Vibe Tools

Configuration and setup for Vibe Tools environment.

## Setup

1. Copy the example environment file:
   ```bash
   cp vibe-tools.env.symlink.example vibe-tools.env.symlink
   ```

2. Edit `vibe-tools.env.symlink` and add your API keys (see below for how to obtain them)

## API Keys

### Required Keys

#### Perplexity API Key
- **Website**: https://www.perplexity.ai/settings/api
- **Steps**:
  1. Create an account at Perplexity.ai
  2. Navigate to Settings → API
  3. Generate a new API key
  4. Copy the key to `PERPLEXITY_API_KEY`

#### Gemini API Key
- **Website**: https://aistudio.google.com/app/apikey
- **Steps**:
  1. Go to Google AI Studio
  2. Sign in with your Google account
  3. Click "Get API key" → "Create API key"
  4. Copy the key to `GEMINI_API_KEY`

### Optional Keys

#### OpenAI API Key (for Stagehand)
- **Website**: https://platform.openai.com/api-keys
- **Steps**:
  1. Create an account at OpenAI
  2. Navigate to API keys section
  3. Create a new secret key
  4. Copy the key to `OPENAI_API_KEY`

#### Anthropic API Key (for Stagehand and MCP)
- **Website**: https://console.anthropic.com/settings/keys
- **Steps**:
  1. Create an account at Anthropic Console
  2. Go to Settings → API Keys
  3. Create a new key
  4. Copy the key to `ANTHROPIC_API_KEY`

#### OpenRouter API Key (for MCP)
- **Website**: https://openrouter.ai/keys
- **Steps**:
  1. Create an account at OpenRouter
  2. Navigate to the Keys section
  3. Generate a new API key
  4. Copy the key to `OPENROUTER_API_KEY`

#### xAI API Key (for Grok models)
- **Website**: https://console.x.ai/
- **Steps**:
  1. Create an account at xAI Console
  2. Navigate to API Keys section
  3. Generate a new API key
  4. Copy the key to `XAI_API_KEY`

#### GitHub Token (for enhanced GitHub access)
- **Website**: https://github.com/settings/tokens
- **Steps**:
  1. Go to GitHub Settings → Developer settings → Personal access tokens
  2. Click "Generate new token (classic)"
  3. Select appropriate scopes (typically `repo`, `read:org`)
  4. Generate token and copy to `GITHUB_TOKEN`

## Testing vibe-tools

After setting up your API keys, test vibe-tools functionality with these commands:

### Basic Commands

#### Web Search Test
```bash
# Test web search functionality
vibe-tools web "What are the key features of Node.js?"

# Check API documentation
vibe-tools web "How to implement REST API in Express.js?"
```

#### Direct Model Query Test
```bash
# Test with OpenAI (if configured)
vibe-tools ask "What is the capital of France?" --provider openai --model gpt-4

# Test with Anthropic (if configured)
vibe-tools ask "Explain the concept of recursion" --provider anthropic --model claude-3-5-sonnet-20241022

# Test with Gemini
vibe-tools youtube "https://www.youtube.com/watch?v=yu_uZvb0T4o" --type=summary
```

#### Repository Analysis Test
```bash
# Analyze current project structure
vibe-tools repo "Explain the overall architecture of this project"

# Get help with specific code patterns
vibe-tools repo "Show me examples of error handling in this codebase"

# Analyze specific directory
vibe-tools repo "Explain the code structure" --subdir=src
```

#### Documentation Generation Test
```bash
# Generate documentation for current project
vibe-tools doc --save-to=docs/API.md --hint="Focus on the API endpoints and their usage"

# Document with architectural focus
vibe-tools doc --save-to=docs/ARCHITECTURE.md --hint="Focus on system architecture"
```

#### GitHub Integration Test (if GitHub token configured)
```bash
# List recent PRs from a popular repository
vibe-tools github pr --from-github facebook/react

# Check issues in a repository
vibe-tools github issue --from-github microsoft/vscode
```

#### Browser Automation Test
```bash
# Open a webpage and get HTML content
vibe-tools browser open "https://example.com" --html

# Take a screenshot of a webpage
vibe-tools browser open "https://example.com" --screenshot=test.png

# AI-powered page observation
vibe-tools browser observe "What can I do on this page?" --url "https://github.com"
```

### Expected Results

- **Successful**: Commands return relevant, formatted responses
- **API Key Issues**: Error messages about authentication or invalid keys
- **Rate Limits**: Messages about usage limits being exceeded
- **Network Issues**: Connection timeout or network-related errors

### Troubleshooting Commands

If commands fail, check your configuration:

```bash
# Verify environment variables are loaded
echo "Perplexity: ${PERPLEXITY_API_KEY:0:10}..."
echo "Gemini: ${GEMINI_API_KEY:0:10}..."
echo "OpenAI: ${OPENAI_API_KEY:0:10}..."

# Check vibe-tools installation
vibe-tools --version

# Test with verbose output for debugging
vibe-tools ask "Hello" --provider gemini --model gemini-1.5-flash
```

## Notes

- Keep your API keys secure and never commit them to version control
- Some services offer free tiers with usage limits
- Check each service's pricing and usage policies before use
- The optional keys enhance functionality but are not required for basic operation 