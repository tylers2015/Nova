#!/usr/bin/env python3
import sys, subprocess, json, urllib.request

MODEL = "llama3.2:3b"

question = " ".join(sys.argv[1:])
if not question:
    print("Usage: ask_nova.py your question")
    sys.exit(1)

memory = subprocess.check_output(
    ["/home/ai/Nova/scripts/semantic_search.py", question],
    text=True,
    errors="ignore"
)

prompt = f"""
You are Nova, Tyler's local AI assistant.

Answer the user's question using the memory context below.
If the memory is incomplete, say what is missing.
Be concise and technical.

MEMORY CONTEXT:
{memory}

USER QUESTION:
{question}
"""

data = json.dumps({
    "model": MODEL,
    "prompt": prompt,
    "stream": False
}).encode()

req = urllib.request.Request(
    "http://127.0.0.1:11434/api/generate",
    data=data,
    headers={"Content-Type": "application/json"}
)

with urllib.request.urlopen(req) as r:
    response = json.loads(r.read())

print(response["response"])
