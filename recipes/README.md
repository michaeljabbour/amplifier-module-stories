# Amplifier Stories Recipes

This directory contains automated workflows (recipes) for generating content from Amplifier data.

## Available Recipes

### session-to-case-study

Convert completed Amplifier session files into compelling case studies in Word format.

**Purpose:** Automatically analyze session data and generate professional case study documents that tell the story of how problems were solved using Amplifier.

**Workflow:**
1. **Research Phase** - Analyzes events.jsonl to extract:
   - Session metadata (duration, agents, tools, iterations)
   - Key breakthrough moments
   - Quantified metrics (tool calls, files modified, complexity indicators)
   - Final outcome and deliverables

2. **Strategy Phase** - Evaluates case study worthiness:
   - Requires 10+ tool calls for substantive work
   - Must have successful outcome
   - Should have interesting problem-solving narrative
   - Determines target audience (technical/mixed/community)

3. **Writing Phase** - Generates Word document using template:
   - Creates engaging title
   - Writes Challenge/Approach/Results sections
   - Includes quantified metrics throughout
   - Adds actionable key takeaways

4. **Finalization** - Auto-opens document for review

**Usage:**

```bash
# Basic usage with session file
amplifier run "execute session-to-case-study.yaml with session_file=~/.amplifier/sessions/2026-01-15/events.jsonl"

# With custom output name
amplifier run "execute session-to-case-study.yaml with session_file=./my-session.jsonl output_name=automation-success-story"

# From recent session (relative path)
amplifier run "execute session-to-case-study.yaml with session_file=../sessions/recent/events.jsonl"
```

**Inputs:**
- `session_file` (required): Path to events.jsonl session file
- `output_name` (optional): Custom filename for output (defaults to session ID)

**Outputs:**
- Word document at `workspace/docx/output/case-study-[name].docx`
- Auto-opened in Microsoft Word for immediate review

**Requirements:**
- Agents: `story-researcher`, `content-strategist`, `case-study-writer`
- Template: `workspace/docx/templates/case-study-template.js`
- Node.js with `docx` package installed

**Success Criteria:**
- Clear narrative structure (Challenge → Approach → Results)
- Metrics quantified from actual session data
- Technical accuracy maintained
- Compelling story, not just data dump
- Actionable takeaways for readers

**Not Case-Study Worthy?**
The recipe will analyze and report if a session doesn't meet criteria:
- Too few tool calls (<10)
- Failed or abandoned session
- Routine/trivial problem
- Unclear narrative potential

In these cases, you'll get a report explaining why and what would make it case-study material.

---

## Creating New Recipes

To create a new recipe in this collection:

1. Create a `.yaml` file in this directory
2. Follow the recipe format (see examples in `@recipes:examples/`)
3. Validate with: `amplifier recipes validate your-recipe.yaml`
4. Document it in this README
5. Test thoroughly before committing

## Recipe Format Reference

Key components:
- `name`: Unique identifier
- `description`: What the recipe does
- `context`: Input variables
- `steps`: Sequential workflow with agents or bash commands
- `condition`: Optional step execution logic
- `output`: Variable capture for next steps

See the Amplifier recipes documentation for full specification.
