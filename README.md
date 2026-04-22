# Kaioken Multistatus

A single-line statusline for [Claude Code](https://claude.ai/code) that shows everything you need at a glance.

```
🤖 Opus 4.6  📂 myproject  🌿 main  🧠 40%  ⚡ 60% ⏳ 3h22m  🔄 38% 📅 4d12h
```

## What it shows

| Emoji | Label | Description |
|-------|-------|-------------|
| 🤖 | Model | Active Claude model (Opus, Sonnet, Haiku) |
| 📂 | Project | Current working directory name |
| 🌿 | Branch | Current git branch |
| 🧠 | Context | Context window usage % |
| ⚡ | 5h Limit | 5-hour rolling rate limit usage % |
| ⏳ | Session Time | Time remaining until 5-hour rate limit resets |
| 🔄 | 7d Limit | 7-day rolling rate limit usage % |
| 📅 | Weekly Reset | Days and hours until 7-day rate limit resets |

Percentages are color-coded:
- **Green** — under 50% (you're good)
- **Yellow** — 50-79% (watch it)
- **Red** — 80%+ (slow down)

## Install

### Quick install

```bash
git clone https://github.com/codekaiOken/kaioken-ccmultistatusline.git
cd kaioken-ccmultistatusline
chmod +x install.sh
./install.sh
```

Restart Claude Code. Done.

### Manual install

1. Copy `kaioken-status.sh` to `~/.claude/`:

```bash
cp kaioken-status.sh ~/.claude/kaioken-status.sh
chmod +x ~/.claude/kaioken-status.sh
```

2. Add to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/kaioken-status.sh"
  }
}
```

3. Restart Claude Code.

## Requirements

- [Claude Code](https://claude.ai/code) CLI
- `jq` (for JSON parsing) — `brew install jq` on macOS
- `git` (for branch detection)

## Rate limits

The ⚡ 5h and 🔄 7d fields show usage percentages. The ⏳ and 📅 fields show time remaining until each window resets. These are available on Pro/Max plans. If you're on a plan without rate limit data, those fields simply won't appear.

## Customization

It's just a shell script — edit `kaioken-status.sh` to add/remove fields, change emojis, or tweak colors.

## License

MIT
