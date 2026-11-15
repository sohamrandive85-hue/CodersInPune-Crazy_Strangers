# ContinuAI

**Code stays in Git. Context shouldn’t walk out the door.**

ContinuAI is an AI-powered project knowledge handover platform that turns raw Git history and structural code diffs into a verified, role-specific handover package—so incoming engineers understand not just *what* was built, but *why* every decision was made.

**Check it out on** : https://continuai.onrender.com/

[Why ContinuAI](#why-continuai) • [Key Capabilities](#key-capabilities) • [How It Works](#how-it-works) • [Project Architecture](#project-architecture) • [Quickstart](#quickstart-download--run) • [Configuration](#configuration--oauth-setup)

---

## Why ContinuAI?

When a key engineer leaves a project or switches teams, the source code remains in Git—but the reasoning behind it disappears. Commit logs capture snapshots of file changes, yet critical context stays buried:

- **Why** was one architecture chosen over another?
- **Which** alternatives were already tried and rejected?
- **Where** are the single-owner bottlenecks and unfinished tasks?

Scrambling to write handover docs during someone's final week rarely works. **ContinuAI** automates knowledge reconstruction directly from your repository, pairs AI extraction with structural code analysis, and puts your team in control of verifying every claim before the baton is passed.

---

## Key Capabilities

- **Multi-Provider AI & Offline Fallback**: Plug in **Gemini**, **Anthropic (Claude)**, or **OpenAI**, or run completely offline with the built-in **rule-based extractor**—no API keys required to explore the demo.
- **Python AST & Co-Change Intelligence**: Goes beyond commit messages by analyzing Python Abstract Syntax Tree (AST) structural diffs (functions, classes, signatures, imports) and building a **NetworkX** module co-change and contributor ownership graph.
- **3-Tier Graded Confidence Scoring**: Every extracted decision, conflict, or risk is scored (`0.0 – 1.0`) and labeled as **Confirmed**, **Likely**, or **Inferred** based on commit rationale and structural code evidence.
- **Human-in-the-Loop Review & Audit Trail**: Team members can approve, reject, or edit any extracted item before publishing. Every modification is versioned in SQLite with a complete chronological audit log.
- **Role-Filtered Handover Views & RBAC**: Once published, incoming teammates filter the handover by role (**Team Lead**, **Backend**, **Frontend**, **ML**, **Infrastructure**, or **Documentation**) and log formal receipt. Supports GitHub/GitLab OAuth 2.0 with Fernet-encrypted token storage and GitHub team RBAC policies.
- **Post-Publish Workflow Integrations**: Automatically notify channels and sync action items to **Slack**, **Jira**, and **Notion** upon publishing (including a dry-run mode for safe local testing).

---

## How It Works

ContinuAI guides teams through a structured five-stage handover workflow:

1. **Connect**: Point ContinuAI to a public or private GitHub/GitLab repository URL, `owner/repo` slug, or local Git path—or launch the built-in sample project in one click.
2. **Reconstruct**: ContinuAI reads the commit history, maps contributor ownership across modules, builds a co-change dependency graph, and flags single-owner risks.
3. **Verify**: Architectural decisions, trade-offs, rejected alternatives, reverts, and unfinished tasks are extracted and tagged with confidence levels and commit links.
4. **Review**: A reviewer audits the draft—approving accurate insights, editing wording, or rejecting noise—while every change is recorded in the versioned activity log.
5. **Hand Over**: Publish only approved items. Each incoming engineer views a tailored subset of decisions and dependency graphs relevant to their role and confirms receipt.

---

## Project Architecture

ContinuAI is intentionally lightweight with **zero frontend build steps**, making it fast to run locally and simple to deploy:

```text
continuai/
├── app.py              # Flask REST API, session management & SQLite persistence
├── analyzer.py         # Git log ingestion, NetworkX co-change graph & risk analysis
├── ast_analyzer.py     # Python AST structural diff parser & signature extractor
├── llm/
│   ├── engine.py       # Provider routing, retry logic & structured JSON extraction
│   └── providers.py    # Gemini, Anthropic, OpenAI & rule-based fallback providers
├── auth.py             # GitHub & GitLab OAuth 2.0 login flow
├── token_store.py      # Fernet-encrypted OAuth token storage
├── rbac.py             # GitHub team-based role access policy mapping
├── integrations.py     # Post-publish Slack, Jira & Notion connectors
└── static/
    └── index.html      # Single-page vanilla HTML/CSS/JS interface + vis-network graph
```

---

## Quickstart: Download & Run

### Prerequisites
- **Python 3.10+**
- **Git** installed and available on your system `PATH` (required to clone and analyze real repositories)

### 1. Download the Repository
Clone the project to your local machine and navigate into the project directory:

```bash
git clone https://github.com/<your-username>/<your-repo-name>.git
cd <your-repo-name>
```

### 2. Create a Virtual Environment & Install Dependencies
Set up an isolated Python environment and install the required packages:

**Windows (PowerShell / VS Code Terminal):**
```bash
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
```

**macOS / Linux:**
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3. Start the Application
Run the Flask server:

```bash
python app.py
```

Open **`http://localhost:5000`** in your browser and click **"Try the sample project"** to explore a pre-loaded 15-commit handover workflow immediately—no API keys or GitHub login required.

---

## Configuration & OAuth Setup

ContinuAI works out of the box in offline/rule-based mode. To enable AI extraction, private repository OAuth, or external integrations, copy `.env.example` to `.env` in the root directory and configure the variables below.

### 1. Environment Variables (`.env`)

| Category | Variable | Description |
| :--- | :--- | :--- |
| **LLM Engine** | `LLM_PROVIDER` | `gemini`, `anthropic`, `openai`, or `rule-based` (default fallback) |
| | `GEMINI_API_KEY` | API key for Google Gemini (default model: `gemini-3.5-flash`, override via `GEMINI_MODEL`) |
| | `ANTHROPIC_API_KEY` | API key for Claude (default model: `claude-3-5-sonnet-20241022`, override via `ANTHROPIC_MODEL`) |
| | `OPENAI_API_KEY` | API key for OpenAI (default model: `gpt-4o-mini`, override via `OPENAI_MODEL`) |
| **Security** | `FLASK_SECRET_KEY` | Random hex string for signing Flask session cookies |
| | `TOKEN_ENCRYPTION_KEY` | Fernet base64 key used to encrypt stored OAuth access tokens |
| **Server** | `BASE_URL` | Public or local app URL (default: `http://localhost:5000`) |
| | `PORT` | Server port (default: `5000`) |
| **OAuth 2.0** | `GITHUB_CLIENT_ID` / `GITHUB_CLIENT_SECRET` | Credentials for GitHub sign-in and private repo access |
| | `GITLAB_CLIENT_ID` / `GITLAB_CLIENT_SECRET` | Credentials for GitLab sign-in (optional custom host via `GITLAB_BASE`) |
| **Integrations** | `SLACK_WEBHOOK_URL` | Incoming Webhook URL to post published handover summaries |
| | `JIRA_BASE_URL`, `JIRA_EMAIL`, `JIRA_API_TOKEN`, `JIRA_PROJECT_KEY` | Sync approved tasks/risks to Jira (`JIRA_ISSUE_TYPE` defaults to `Epic`) |
| | `NOTION_TOKEN`, `NOTION_DATABASE_ID` | Export handover items to Notion (`NOTION_TITLE_PROP` defaults to `Name`) |
| | `INTEGRATIONS_DRY_RUN=1` | Set to `1` to simulate Slack/Jira/Notion calls without sending live requests |

### 2. GitHub OAuth App Setup (Optional)
To let users sign in with GitHub and pick private repositories from a dropdown:
1. Open **GitHub → Settings → Developer settings → OAuth Apps → New OAuth App**.
2. Set **Application name** to `ContinuAI`.
3. Set **Homepage URL** to `http://localhost:5000` (or your deployed `BASE_URL`).
4. Set **Authorization callback URL** to:
   ```text
   http://localhost:5000/auth/github/callback
   ```
   *(Replace `http://localhost:5000` with your `<BASE_URL>` in production).*
5. Copy the **Client ID** and **Client Secret** into your `.env` file.

---

## Running Tests

ContinuAI includes a full unit and integration test suite with mocked external API calls (zero LLM or integration credits consumed):

```bash
pytest -v
```

---

## Known Limitations & Roadmap

- **Multi-Language AST Parsing**: Full syntactic AST diff analysis is implemented for Python source files via Python's built-in `ast` module. JavaScript and TypeScript files currently use lightweight regex heuristics for function/class/import extraction, with full `tree-sitter` JS/TS parsing planned next.
- **PR & Issue Discussion Ingestion**: Decision and trade-off mining currently analyzes commit messages, multi-file diffs, and structural AST context. Direct ingestion of GitHub Pull Request reviews and issue threads is planned for a future release.
