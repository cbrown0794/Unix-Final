# Model Card

## Summary

Using the Ollama docker container and RAG, the model `llama3.2:1b` is used along with `nomic-embed-text` for embedding.

## Inference Server

- **Software**: Ollama
- **Image & Version**: `ollama/ollama:0.40.18`
- **Models**: 
    - `llama3.2:1b`
        - 1.24 billion parameters
        - 128k context window
        - Licensed under [Llama 3.2 Community License Agreement](https://dev.meta.ai/llama/llama3_2/license)
        > Chosen for being relatively lightweight so it can run smoothly on an affordable GCP VM
    - `nomic-embed-text`
        - 137 million parameters
        - 8,192 context window
        - Licensed under [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
- **Chunking Configuration**:
    - Chunk size set to 400
    - Chunk overlap set to 50
- **Vector Storage**: Qdrant