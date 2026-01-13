# Scanner AI Parser Backend

FastAPI backend for the Scanner application with AI-powered document parsing.

## Setup

1. Create virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On macOS/Linux
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run the server:
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## API Endpoints

- `GET /` - Root endpoint
- `GET /api/v1/health` - Health check
- `POST /api/v1/parse` - Parse document with AI
- `POST /api/v1/extract-text` - Extract text from image
- `POST /api/v1/classify` - Classify document type

## Project Structure

```
backend/
├── app/
│   ├── api/
│   │   └── routes/
│   │       ├── parser.py      # Parser endpoints
│   │       └── health.py      # Health check
│   ├── core/
│   │   └── config.py          # App configuration
│   ├── models/
│   │   └── schemas.py         # Pydantic models
│   ├── services/
│   │   └── ai_parser.py       # AI parser service
│   └── main.py                # FastAPI app
├── tests/
│   └── test_ai_parser.py      # Tests
└── requirements.txt
```

## Testing

```bash
pytest tests/
```
