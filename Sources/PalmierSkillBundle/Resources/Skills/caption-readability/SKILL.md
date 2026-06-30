---
name: Caption readability
description: Use when generating, styling, or revising spoken captions and subtitles on the timeline.
---

## Purpose

Create readable timeline captions from speech without hand-building text clips.

## Workflow

1. Use `add_captions` for spoken captions. Do not transcribe first and place many `add_texts` clips by hand unless the user asks for bespoke text.
2. When the user asks for subtitles, captions, readable captions, short captions, or a platform-style caption track, pass `maxCharacters`.
3. If the user gives an exact limit, use that value. If they do not, choose a conservative readable limit:
   - vertical or narrow video: about 8-14 visible characters for CJK, 18-28 for alphabetic text
   - wide landscape video: about 12-20 visible characters for CJK, 28-42 for alphabetic text
   - larger font sizes need lower limits
4. Pass `language` when the speech language differs from the user's system language, or when the user names the language.
5. Use `maxWords` only when the user asks for a word-count rule, such as two-word captions.
6. Keep generated captions in the safe lower area unless the user asks for another placement. Use `centerY` only when needed.
7. After creating captions, use `inspect_timeline` on a representative frame if placement or readability is uncertain.

## Defaults

For a normal "generate subtitles" request with no exact format, prefer short readable phrases over full transcript sentences. Set `maxCharacters` instead of relying on the caption generator's unconstrained segment length.
