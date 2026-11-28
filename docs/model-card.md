# Model Card

## Summary

Using the Ollama docker container and RAG, the model `llama3.2:1b` is used along with `nomic-embed-text` for embedding.

## Inference Server

- **Software**: Ollama
- **Image & Version**: `ollama/ollama:0.40.18`
- **Models**: 
    - `llama3.2:3b`
        - Completion and tools capabilities
        - 3.2B parameters
        - 4,096 context window as set in the compose file (131,072 is the model maximum)
        - 2.0 GB file size
        - 2.6 GB loaded size
        - Q4_K_M quantization
        - 100% CPU ([evidence](evidence/ollama-cpu-only.txt))
        - Licensed under [Llama 3.2 Community License Agreement](https://dev.meta.ai/llama/llama3_2/license)
        - Strengths
            - Good quality of response for the speed
        - Limitations
            - More expensive and slower than lightweight models such as `llama3.2:1b`
    - `nomic-embed-text:v1.5`
        - Embedding capabilities
        - 137M parameters
        - 2,048 context window (8,192 is the model maximum)
        - 274MB file size
        - 389MB loaded size
        - 768 embedding length
        - F16 quantization
        - 100% CPU ([evidence](evidence/ollama-cpu-only.txt))
        - Licensed under [Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
- **Chunking Configuration**:
    - Chunk size set to 400
    - Chunk overlap set to 50
- **Vector Storage**: Qdrant

## Sources

| Item | Link | Accessed |
|---|---|---|
| llama3.2 (Ollama library) | https://ollama.com/library/llama3.2 | 2026-11-26 |
| Llama 3.2 original model card | https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct | 2026-11-26 |
| Llama 3.2 Community License | https://dev.meta.ai/llama/llama3_2/license | 2026-11-26 |
| nomic-embed-text (Ollama library) | https://ollama.com/library/nomic-embed-text | 2026-11-26 |
| nomic-embed-text original model card | https://huggingface.co/nomic-ai/nomic-embed-text-v1.5 | 2026-11-26 |



*Built with Llama*