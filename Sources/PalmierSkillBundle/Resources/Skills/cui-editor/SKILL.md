---
name: Cui editor
description: Use when turning spoken raw footage into a traceable rough cut, rewrite plan, readable captions, Palmier timeline edit, or CapCut/Jianying export.
---

# Cui Editor for Palmier

Use this skill for transcript-driven spoken-video editing. The goal is not to summarize the footage. The goal is to turn source speech into a reviewable, traceable, and executable edit: cut dead air and weak takes, keep sentence continuity, reorder the strongest material, caption it, and export from Palmier when requested.

## Palmier Tool Path

1. Start with `get_timeline`. Use its fps, resolution, track order, clip IDs, and `canGenerate` state.
2. If the material is still in the media library, call `get_media` and `inspect_media` before referencing it. `inspect_media` returns source-second transcript segments.
3. If the material is already on the timeline, call `get_transcript`. It returns the current audible timeline in project frames and word indices.
4. Use `remove_words` for filler words, stutters, false starts, retakes, and any spoken text that appears in `get_transcript`.
5. Use `ripple_delete_ranges` only for non-word-aligned spans such as visible dead air, room tone, or silence with no transcript word row.
6. Use `split_clips`, `move_clips`, `add_clips`, `insert_clips`, and `set_clip_properties` for structural edits. Keep linked audio/video together unless the user explicitly asks otherwise.
7. Use `add_captions` for spoken captions. Pass `maxCharacters` for readable short captions instead of placing many `add_texts` clips by hand.
8. Use `inspect_timeline` on representative frames after major edits or caption placement.
9. Use `export_project` when the user asks for delivery. Choose `mode: "capcut"` for CapCut/Jianying, `mode: "palmier"` for a self-contained Palmier package, and `mode: "video"` for rendered video.

## Hard Rules

- Do not directly patch Palmier project JSON or exported CapCut draft JSON as the default path. Use Palmier tools.
- Do not invent facts, examples, numbers, claims, or outcomes that are not present in the source material.
- Every retained, deleted, moved, or rewritten segment must remain traceable to source media and source time.
- If the transcript has no reliable timing, inspect or transcribe first. Do not create a formal cut plan from untimecoded text.
- Preserve sentence continuity. Removing silence is correct only when the surviving sentence still sounds natural and logically complete.
- For large destructive edits, create a compact review plan before applying cuts unless the user explicitly asked to execute immediately.
- If a tool returns an error, surface that error and re-plan from it. Do not silently rewrite arguments to hide the failure.

## Workflow

### 1. Prepare the timeline

- Confirm the target aspect ratio. For short-form vertical delivery, prefer a 1080x1920 project when the user has not specified otherwise.
- Identify the main speaker. If the user does not name one, choose the speaker with the longest effective speaking time.
- Keep source assets and clip IDs visible in your notes so later edits can be traced.

### 2. Build the rough cut

Read the transcript as editable material, not as a summary.

Remove or mark for removal:

- non-main-speaker speech, unless the user wants dialogue or interview texture
- greetings, throat-clearing, dead air, long inhales, and environmental noise
- isolated filler words such as "um", "ah", "uh", "这个", "那个", "然后呢"
- false starts and the weaker version of a corrected retake
- repeated sentences that add no new business information
- fragments with no clear referent, such as "this is that" or "and then it does that"

Keep with care:

- logic connectors such as "but", "so", "because", "其实", "所以", "但是"
- business objects such as customer, inventory, cash flow, sales, finance, ERP, CRM, order, process, data
- short judgment sentences that carry the point of the piece

For each proposed deletion, be able to state the reason: filler, silence, stutter, repeat, correction, non-main-speaker, topic shift, or manual judgment.

### 3. Cut on coherent boundaries

Use hard cuts when:

- speaker changes
- the topic changes
- the role of the sentence changes between problem, cause, consequence, method, and conclusion
- a clear contrast or pivot appears, such as "but", "actually", "the real issue", "so", "result", "你以为", "真正的问题"
- the same speaker pauses for more than about 0.8 seconds
- a wrong take is followed by a corrected take

Prefer soft cuts when:

- a pause is about 0.35 to 0.8 seconds
- the sentence cadence drops naturally
- a source sentence is longer than about 12 seconds
- a subtitle would exceed about 42 CJK characters

When trimming around speech, keep a small natural breath. Avoid swallowing the first or last meaningful word. Do not keep obvious empty space simply because it is adjacent to useful speech.

### 4. Rewrite and reorder

For business or "operator-style" spoken clips, reorder source material by audience comprehension rather than source chronology:

1. misconception or pain point
2. real cause
3. business consequence
4. operating judgment
5. concrete method or next action

Not every video needs all five parts, but the result should not stop at abstract explanation. Prefer sentences that define the problem, explain why it happens, connect to real business objects, create a useful contrast, or make a clear judgment.

Write compact spoken lines. Keep oral rhythm, remove rambling setup, split long sentences, and avoid report-like phrasing. Do not overuse "first, second, finally" unless the source material is already a step-by-step explanation.

### 5. Maintain a rewrite plan

For non-trivial rewrites, maintain a plan with these fields for each segment:

```json
{
  "id": "seg_0001",
  "rewriteGroupId": "sentence_0001",
  "sourceClipId": "clip_001",
  "sourceMediaRef": "media_001",
  "sourceFileName": "source.mp4",
  "sourceStart": 12.34,
  "sourceEnd": 18.92,
  "timelineStart": 0.0,
  "timelineEnd": 6.58,
  "text": "Final spoken caption text",
  "sourceText": "Original transcript text",
  "boundaryType": "word|utterance|semantic|manual",
  "decisionReason": "why this segment moved here or changed",
  "reason": "why this source material is retained",
  "confidence": 0.86
}
```

Requirements:

- `sourceEnd` must be greater than `sourceStart`.
- `timelineEnd` must be greater than `timelineStart`.
- Timeline ranges must be monotonic and non-overlapping.
- If one final sentence uses multiple source fragments, give those fragments the same `rewriteGroupId`.
- `text` is the final line; `sourceText` is the original transcript. Do not mix them.
- Never include API keys, tokens, or secrets in the plan.

### 6. Caption for readability

- Use `add_captions`, not hand-built text clips, for spoken captions.
- For vertical CJK videos, prefer short readable captions, usually around 8 to 14 visible characters when no exact limit is provided.
- For vertical alphabetic captions, prefer about 18 to 28 visible characters when no exact limit is provided.
- Lower the limit for larger text. Raise it only when the frame is wide or the text is intentionally small.
- Keep captions in the safe lower area unless the user asks for another placement.
- After adding captions, inspect at least one representative frame if placement or readability is uncertain.

### 7. Validate the result

Before calling the edit complete, verify:

- the current transcript still reads as coherent speech
- major deletions did not break cause, contrast, or conclusion
- every rewrite line traces back to source time
- captions are short enough to read
- the timeline preview matches the intended layout
- the requested export mode succeeded or reported a clear tool error
