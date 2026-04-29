---
name: journal 
description: A skill to auto generate my job journal. 
model: claude-sonnet-4-6
allowed-tools: Read, Bash(git *), Bash(cat *), Bash(gh *), Bash(echo *), Bash(find *), Bash(ls *), Bash(python3 *), Write, Bash(tail *), Bash(git log *)
---

Use today's date from context. Summarize my work today between 8am and 4pm PST.

Helper scripts live in ~/Code/scripts/journal/:
- parse_transcripts.py — parses Claude JSONL transcripts into readable text.
  - `python3 ~/Code/scripts/journal/parse_transcripts.py --today` prints all transcripts modified today
  - `python3 ~/Code/scripts/journal/parse_transcripts.py <file.jsonl> [max_chars]` parses a single file

To gather context, read the following sources:
1. Claude conversation transcripts — run `python3 ~/Code/scripts/journal/parse_transcripts.py --today`
2. Bash history — read ~/.bash_history directly with cat; use the last few hundred lines as a rough proxy for today's activity since timestamps are not guaranteed
3. Git history — find repos with `find ~/ -name ".git" -maxdepth 4 -type d`, then in each run `git log --since="8am today" --until="4pm today" --author=$(git config user.email) --oneline`

Format the entry as:

{Weekday} {Day of Month} {Year}
    - Task 1
    - Task 2
    ...

Each task is something I accomplished. Keep it precise and simple. Only include things relevant to my job. Do not duplicate entries that already exist in ~/job_journal.txt for today's date.

If today is Friday, first read ~/job_journal.txt to find this week's entries (Monday through Friday), then write a weekly summary paragraph followed by Friday's bullet points:

------------ Week Summary ---------------------

Small paragraph here describing the week's work.

----------------------------------------------

{Friday} {Day of Month} {Year}
    - Task 1
    - Task 2
    ...

Prepend the full entry to ~/job_journal.txt.
