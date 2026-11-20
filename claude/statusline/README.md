# Status line

Claude Code runs `render.sh`, which fills `template` with the session data Claude Code
sends on every redraw. Edit `template`; changes show on the next redraw, no restart.

| File | What it is |
|---|---|
| `template` | your status line: edit this |
| `render.sh` | entry point (what `statusLine` in `~/.claude/settings.json` runs) |
| `render.jq` | the template engine |
| `last-input.json` | the latest session data, rewritten on every render (for `--fields` / `--time`) |

```sh
bash ~/.claude/statusline/render.sh --fields   # every field Claude Code sends now, with values
bash ~/.claude/statusline/render.sh --time     # how long your template takes to render
```

## Template syntax

- One **segment** per line. Segments are joined by the separator.
- A segment is **left out** when any `{field}` in it is missing (e.g. no 5-hour limit
  reported), or when it renders to nothing visible.
- `# ...` lines are comments; blank lines are ignored; leading/trailing spaces are trimmed.
- `@separator " <dim>·</> "` sets the separator (quotes keep its spaces; colors allowed).

### Values: `{field|filter|filter:arg}`

`field` is a dot path into the session data (`model.display_name`,
`rate_limits.seven_day.resets_at`, `workspace.added_dirs.0`). Filters run left to right.

| Filter | Does | Example → output |
|---|---|---|
| `round` | nearest whole number | `{context_window.used_percentage\|round}` → `16` |
| `fixed:N` | N decimals | `{cost.total_cost_usd\|fixed:3}` → `5.437` |
| `money` | dollars, 2 decimals | `{cost.total_cost_usd\|money}` → `$5.44` |
| `percent` | 0–1 ratio → whole percent | `{prompt_cache.hit_ratio\|percent}%` → `96%` |
| `tokens` | compact count | `{context_window.total_input_tokens\|tokens}` → `161k`, `1M` |
| `duration` | milliseconds → time | `{cost.total_duration_ms\|duration}` → `<1m`, `14m`, `1h 05m`, `3d 4h` |
| `until` | epoch seconds → time left | `{rate_limits.five_hour.resets_at\|until}` → `2h 13m` |
| `ago` | epoch seconds → time since | `{prompt_cache.last_miss_at\|ago}` → `1h 06m` |
| `date:FMT` | epoch seconds → local time ([strftime](https://man7.org/linux/man-pages/man3/strftime.3.html)) | `{rate_limits.seven_day.resets_at\|date:%a %-I:%M%p}` → `Wed 4:00PM` |
| `yesno:A:B` | true → A, false → B (B may be empty) | `{fast_mode\|yesno:⚡:}` |
| `default:TEXT` | use TEXT when the field is missing (keeps the segment) | `{git.branch\|default:no repo}` |
| `prefix:TEXT` / `suffix:TEXT` | add TEXT only when the value isn't empty | `{git.markers\|prefix: }` |
| `upper` / `lower` | change case | `{effort.level\|upper}` → `HIGH` |
| `basename` | last part of a path | `{workspace.current_dir\|basename}` → `herdr-app` |

An unknown filter shows `‹bad filter: name›` in the status line. A broken template shows
`statusline: template error` with the command to see why.

### Colors: `<...>` tags

| Tag | Color |
|---|---|
| `<red>` `<green>` `<yellow>` `<blue>` `<magenta>` `<cyan>` `<white>` `<gray>` `<black>` | basic terminal colors |
| `<bold>` `<dim>` `<italic>` `<underline>` | styles |
| `<110>` | 256-color palette number (0–255) |
| `<#ff8800>` | true color |
| `<bg:236>` `<bg:#1e1e2e>` `<bg:blue>` | background |
| `<bold #ff8800 bg:236>` | several at once, space-separated |
| `<heat:FIELD:50:80>` | green below 50, yellow from 50, red from 80, by FIELD's value |
| `<heat:FIELD:80:50>` | reversed (low is bad): red at 50 or below, yellow at 80 or below, else green |
| `</>` | reset everything |

Each segment resets at its end, so a color never bleeds into the next one. Anything in
`<...>` that isn't a valid tag is printed as is.

## Fields

From Claude Code 2.1.325 on this machine; run `render.sh --fields` for the current list.
Cost is per render. Everything from the session data comes from one `jq` parse, so a
field costs about **0.1 ms**, whatever it is. Only `git.*` runs an extra command.

### Session data (≈0.1 ms each)

| Field | Example | What it is |
|---|---|---|
| `model.display_name` | `Opus 5.5` | model name |
| `model.id` | `claude-opus-5-5` | model ID |
| `effort.level` | `high` | reasoning effort |
| `thinking.enabled` | `true` | extended thinking on |
| `fast_mode` | `false` | fast mode on |
| `output_style.name` | `default` | output style |
| `vim.mode` | `INSERT` | vim mode of the prompt (vim editing only) |
| `session_name` | `Herdr-app AGENTS.md` | session title |
| `session_id` | `4985bfbc-…` | session ID |
| `prompt_id` | `21ec1640-…` | current prompt's ID |
| `version` | `2.1.325` | Claude Code version |
| `cwd` | `/Users/scott/.config/herdr-app` | current folder |
| `workspace.current_dir` | `/Users/scott/.config/herdr-app` | current folder |
| `workspace.project_dir` | `/Users/scott` | folder the session started in |
| `workspace.added_dirs.0` | `/path` | extra folders added with /add-dir (`.0`, `.1`, …) |
| `transcript_path` | `~/.claude/projects/…jsonl` | the session's transcript file |
| `scratchpad_dir` | `/private/tmp/claude-501/…` | the session's scratch folder |
| `cost.total_cost_usd` | `5.437191` | session cost, USD |
| `cost.total_duration_ms` | `45092179` | time since the session started |
| `cost.total_api_duration_ms` | `557714` | time spent waiting on the model |
| `cost.total_lines_added` | `240` | lines added |
| `cost.total_lines_removed` | `21` | lines removed |
| `context_window.used_percentage` | `16` | context used, % (missing before the first reply) |
| `context_window.remaining_percentage` | `84` | context left, % |
| `context_window.context_window_size` | `1000000` | context window size, tokens |
| `context_window.total_input_tokens` | `161496` | input tokens in context |
| `context_window.total_output_tokens` | `253` | output tokens of the last reply |
| `context_window.current_usage.input_tokens` | `2` | last request: uncached input |
| `context_window.current_usage.output_tokens` | `253` | last request: output |
| `context_window.current_usage.cache_read_input_tokens` | `160744` | last request: read from cache |
| `context_window.current_usage.cache_creation_input_tokens` | `750` | last request: written to cache |
| `exceeds_200k_tokens` | `false` | context over 200k tokens |
| `rate_limits.seven_day.used_percentage` | `1` | weekly usage limit used, % |
| `rate_limits.seven_day.resets_at` | `1795035600` | when it resets (epoch seconds) |
| `rate_limits.five_hour.used_percentage` | | 5-hour limit used, % (only when reported) |
| `rate_limits.five_hour.resets_at` | | when it resets (only when reported) |
| `prompt_cache.warm` | `true` | the prompt cache is warm |
| `prompt_cache.hit_ratio` | `0.955` | cache hit ratio, 0–1 |
| `prompt_cache.ttl` | `1h` | cache lifetime |
| `prompt_cache.expires_at` | `1794752321` | when the cache goes cold (epoch seconds) |
| `prompt_cache.requests` | `67` | requests this session |
| `prompt_cache.misses` | `2` | cache misses |
| `prompt_cache.last_miss_at` | `1794748441` | last miss (epoch seconds) |
| `prompt_cache.last_miss_cause.causes.0` | `ttl_expired_1h` | why it missed |
| `prompt_cache.cache_write_tokens` | `362098` | tokens written to cache |
| `prompt_cache.recache_tokens_if_cold` | `161496` | tokens to rebuild if it goes cold |

### Extra fields

| Field | Cost | What it is |
|---|---|---|
| `now` | ≈0.1 ms | current time, for `date:` (e.g. `{now\|date:%H:%M}`) |
| `git.branch` | **+7 ms or more** for all `git.*` together | branch, or short commit when detached |
| `git.markers` | (shared) | `*` unstaged, `+` staged, `%` untracked, like `__git_ps1` |
| `git.staged` `git.unstaged` `git.untracked` | (shared) | file counts |
| `git.ahead` `git.behind` | (shared) | commits ahead/behind upstream |

Git runs once (`git status --porcelain=v2 --branch`) only if the template uses a `git.*`
field, and only gives fields inside a repo. Its cost grows with the repo: ~7 ms in a small
one, much more in a huge monorepo.

## What a render costs (measured on this Mac)

| Template | Per render |
|---|---|
| fixed cost: bash + jq start, saving `last-input.json` | ~15 ms |
| the default template (11 fields) | ~16 ms |
| ~130 fields | ~24 ms |
| default + git, small repo | ~24 ms |

Rules of thumb: session-data fields and filters are nearly free; anything that runs a
program costs that program's run time on every redraw. Check with `render.sh --time`.
