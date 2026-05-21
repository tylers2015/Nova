#!/usr/bin/env python3
import os, json, hashlib, urllib.request

ROOTS = [
    "/home/ai/Nova/memory",
    "/home/ai/Nova/docs",
    "/home/ai/Nova/logs/dev",
]

OUT = "/home/ai/Nova/brain/index/memory_index.jsonl"
MODEL = "nomic-embed-text"

def embed(text):
    data = json.dumps({"model": MODEL, "prompt": text}).encode()
    req = urllib.request.Request("http://127.0.0.1:11434/api/embeddings", data=data, headers={"Content-Type": "application/json"})
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read())["embedding"]

def chunks(text, size=900):
    parts = []
    lines = text.splitlines()
    buf = ""
    for line in lines:
        if len(buf) + len(line) > size:
            parts.append(buf.strip())
            buf = ""
        buf += line + "\n"
    if buf.strip():
        parts.append(buf.strip())
    return parts

os.makedirs(os.path.dirname(OUT), exist_ok=True)

with open(OUT, "w") as out:
    for root in ROOTS:
        for path, _, files in os.walk(root):
            for name in files:
                if not name.endswith((".md", ".txt", ".log")):
                    continue
                file_path = os.path.join(path, name)
                try:
                    text = open(file_path, "r", errors="ignore").read()
                    for chunk in chunks(text):
                        if not chunk:
                            continue
                        item = {
                            "id": hashlib.sha256((file_path + chunk).encode()).hexdigest(),
                            "file": file_path,
                            "text": chunk,
                            "embedding": embed(chunk),
                        }
                        out.write(json.dumps(item) + "\n")
                        print("Indexed:", file_path)
                except Exception as e:
                    print("Skipped:", file_path, e)

print("Memory index complete:", OUT)
