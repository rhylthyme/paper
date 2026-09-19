# Evaluation data for the paper

A copy of `rhylthyme-cli-runner/eval/` (the source of truth), kept here so the
paper's numbers travel with the manuscript.

| Path | What it is |
|---|---|
| `baseline.json`, `four-turn.json` | The main result: `claude-haiku-4-5` on all 24 gold programs, single-shot baseline vs the four-turn prompt the MCP server ships |
| `cache/` | Raw model responses for those runs; re-scoring from them costs nothing |
| `models/<model>/<prompt>/` | The capped model comparison: `results.json`, per-program results and raw responses for each model and prompt |
| `models/comparison.md`, `comparison.csv` | Like-for-like table over the programs every model has run |
| `models/spend-ledger.json` | Every live run's estimated cost (peak list prices, an upper bound) |
| `run_model_comparison.py` | Driver: one program at a time, both prompts, hard spending cap |
| `compare_models.py` | Builds the comparison table; no model calls |

The harness itself is `rhylthyme-cli-runner/src/rhylthyme_cli_runner/eval/`
and the gold set is `rhylthyme-examples/gold/` (24 programs: 10 kitchen, 6
lab, 4 event, 4 fitness). To re-score without spending:

    rhylthyme eval-prompts --gold ../rhylthyme-examples/gold --model claude-haiku-4-5 \
        --patterns four-turn --from-cache --cache-dir eval/cache

No credentials are stored here. API keys are read from the environment at run
time (`ANTHROPIC_API_KEY`, `DEEPSEEK_API_KEY`, ...); cached files hold model
responses, token counts and content hashes only.
