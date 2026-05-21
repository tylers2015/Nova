#!/usr/bin/env python3
import sys, json, math, urllib.request

INDEX = "/home/ai/Nova/brain/index/memory_index.jsonl"
MODEL = "nomic-embed-text"

query = " ".join(sys.argv[1:])
if not query:
    print("Usage: semantic_search.py search question")
    sys.exit(1)

def embed(text):
    data = json.dumps({"model": MODEL, "prompt": text}).encode()
    req = urllib.request.Request("http://127.0.0.1:11434/api/embeddings", data=data, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())["embedding"]

def cosine(a, b):
    dot = sum(x*y for x, y in zip(a, b))
    na = math.sqrt(sum(x*x for x in a))
    nb = math.sqrt(sum(y*y for y in b))
    return dot / (na * nb) if na and nb else 0

q = embed(query)
results = []

with open(INDEX, "r") as f:
    for line in f:
        item = json.loads(line)
        score = cosine(q, item["embedding"])
        results.append((score, item))

for score, item in sorted(results, reverse=True)[:5]:
    print("=" * 60)
    print(f"Score: {score:.3f}")
    print(f"File: {item['file']}")
    print("-" * 60)
    print(item["text"][:1200])
