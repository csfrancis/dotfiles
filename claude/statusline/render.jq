# Fills the status line template ($tpl) from Claude Code's session JSON (the input).
# $gitraw is `git status --porcelain=v2 --branch` output, or "" when the template
# uses no git fields or the folder isn't a repo. See README.md for the syntax.

. as $root

| def strip: sub("^\\s+"; "") | sub("\\s+$"; "");
  def lpad($n): if length >= $n then . else ("0" + .) | lpad($n) end;
  def num: if type == "number" then . elif type == "string" then (tonumber? // null) else null end;

  # --- git, parsed once from porcelain v2 -------------------------------------
  def gitinfo:
    if $gitraw == "" then null else
      ($gitraw | split("\n")) as $l
      | ($l | map(select(startswith("# branch.head "))) | first // "" | .[14:]) as $head
      | ($l | map(select(startswith("# branch.oid "))) | first // "" | .[13:20]) as $oid
      | ($l | map(select(startswith("# branch.ab "))) | first // "" | .[12:] | split(" ")) as $ab
      | ($l | map(select(test("^[12u] "))) | map(.[2:4])) as $xy
      | { branch: (if $head == "(detached)" then $oid else $head end),
          ahead: (($ab[0] // "+0") | ltrimstr("+") | tonumber),
          behind: (($ab[1] // "-0") | ltrimstr("-") | tonumber),
          staged: ($xy | map(select(.[0:1] != ".")) | length),
          unstaged: ($xy | map(select(.[1:2] != ".")) | length),
          untracked: ($l | map(select(startswith("? "))) | length) }
      | .markers = ((if .unstaged > 0 then "*" else "" end)
                  + (if .staged > 0 then "+" else "" end)
                  + (if .untracked > 0 then "%" else "" end))
    end;
  (gitinfo) as $git

  # --- field lookup -------------------------------------------------------------
  | def lookup($p):
      if $p == "now" then now
      elif ($p | startswith("git.")) then (if $git == null then null else $git[$p[4:]] end)
      else (try ($root | getpath($p | split(".") | map(tonumber? // .))) catch null)
      end;

  # --- filters ------------------------------------------------------------------
  def fixed($n):
    (pow(10; $n)) as $f | (. * $f | round) as $v
    | if $n == 0 then ($v | tostring)
      else (($v / $f | floor | tostring) + "." + (($v % $f) | tostring | lpad($n))) end;
  def dur:  # milliseconds -> "<1m", "14m", "1h 05m", "3d 4h"
    (. / 60000 | floor) as $m
    | if $m < 1 then "<1m"
      elif $m < 60 then "\($m)m"
      elif $m < 1440 then "\($m / 60 | floor)h \($m % 60 | tostring | lpad(2))m"
      else "\($m / 1440 | floor)d \(($m % 1440) / 60 | floor)h" end;
  def tokens:
    if . >= 999500 then ((. / 1e6 * 10 | round) / 10 | tostring) + "M"
    elif . >= 1000 then (. / 1000 | round | tostring) + "k"
    else (round | tostring) end;
  def numeric(f): (num) as $n | if $n == null then . else ($n | f) end;

  def apply($f):
    ($f | index(":")) as $i
    | (if $i then $f[:$i] else $f end | strip) as $name
    | (if $i then $f[$i + 1:] else "" end) as $arg
    | if $name == "default" then (if . == null then $arg else . end)
      elif . == null then null
      elif $name == "round" then numeric(round)
      elif $name == "fixed" then numeric(fixed($arg | tonumber))
      elif $name == "money" then numeric("$" + fixed(2))
      elif $name == "percent" then numeric(. * 100 | round)
      elif $name == "duration" then numeric(dur)
      elif $name == "until" then numeric(. - now | if . <= 0 then "0m" else . * 1000 | dur end)
      elif $name == "ago" then numeric(now - . | if . <= 0 then "<1m" else . * 1000 | dur end)
      elif $name == "date" then numeric(floor | strflocaltime($arg))
      elif $name == "tokens" then numeric(tokens)
      elif $name == "upper" then (tostring | ascii_upcase)
      elif $name == "lower" then (tostring | ascii_downcase)
      elif $name == "basename" then (tostring | split("/") | last)
      elif $name == "yesno" then ($arg | split(":")) as $a | (if . then $a[0] // "yes" else $a[1] // "" end)
      elif $name == "prefix" then (tostring | if . == "" then . else $arg + . end)
      elif $name == "suffix" then (tostring | if . == "" then . else . + $arg end)
      else "‹bad filter: \($name)›" end;

  def tostr: if . == null then null elif type == "string" then . else tojson end;
  def placeholder($ph):
    ($ph | split("|")) as $parts
    | reduce $parts[1:][] as $f (lookup($parts[0] | strip); apply($f)) | tostr;

  # --- colors -------------------------------------------------------------------
  def named: { reset: 0, bold: 1, dim: 2, italic: 3, underline: 4, black: 30, red: 31,
               green: 32, yellow: 33, blue: 34, magenta: 35, cyan: 36, white: 37, gray: 90, grey: 90 };
  def hex: explode | map(if . >= 97 then . - 87 elif . >= 65 then . - 55 else . - 48 end) | .[0] * 16 + .[1];
  def sgr:  # one tag word -> SGR parameter string, or null if it isn't one
    (if startswith("bg:") then [48, .[3:]] else [38, .] end) as [$base, $c]
    | if named[$c] != null then
        (named[$c]) as $n | if $base == 48 and $n >= 30 then "\($n + 10)" else "\($n)" end
      elif ($c | test("^[0-9]{1,3}$")) then "\($base);5;\($c)"
      elif ($c | test("^#[0-9a-fA-F]{6}$")) then "\($base);2;\($c[1:3] | hex);\($c[3:5] | hex);\($c[5:7] | hex)"
      else null end;
  def tag($t):
    if $t == "/" then "\u001b[0m"
    elif ($t | startswith("heat:")) then
      ($t | split(":")) as $a
      | (lookup($a[1] // "") | num) as $v
      | (($a[2] // "50") | tonumber) as $lo | (($a[3] // "80") | tonumber) as $hi
      | if $v == null then ""
        elif $lo <= $hi then (if $v >= $hi then "\u001b[31m" elif $v >= $lo then "\u001b[33m" else "\u001b[32m" end)
        else (if $v <= $hi then "\u001b[31m" elif $v <= $lo then "\u001b[33m" else "\u001b[32m" end) end
    else ($t | split(" ") | map(select(. != "") | sgr)) as $codes
      | if ($codes | length) > 0 and ($codes | all(. != null)) then "\u001b[\($codes | join(";"))m" else null end
    end;
  def colorize: gsub("<(?<t>[^<>]*)>"; tag(.t) // "<\(.t)>");

  # --- segments -----------------------------------------------------------------
  def segment($s):
    [$s | match("\\{([^{}]*)\\}"; "g") | .captures[0].string] as $phs
    | if any($phs[]; placeholder(.) == null) then null
      else ($s | colorize | gsub("\\{(?<p>[^{}]*)\\}"; placeholder(.p) // ""))
        | if (gsub("\u001b\\[[0-9;]*m"; "") | test("^\\s*$")) then null else . + "\u001b[0m" end
      end;

  ($tpl | split("\n") | map(sub("\r$"; "") | strip)) as $lines
  | ([$lines[] | select(startswith("@separator ")) | .[11:] | strip
      | if test("^\".*\"$") then .[1:-1] else . end] | last // " · " | colorize) as $sep
  | [$lines[] | select(. != "" and (startswith("#") | not) and (startswith("@") | not)) | segment(.)]
  | map(select(. != null))
  | join($sep)
