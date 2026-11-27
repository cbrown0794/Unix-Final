# Model Comparison

## Environment

- Host: Windows 11 PC, Docker Desktop (WSL2)
- Container: `ollama/ollama:0.40.18`, limited to 1.5 CPUs, 4GB memory, no GPU
- Settings: context 4096, temperature 0, seed 42, one llm loaded at a time
- Date Measured: 2026-11-26
- Benchmark Script: `scripts/bench-models.ps1`

> These tests were done in a local environment for development purposes; VM figures will be recorded at a later date.

> > Also, for an unknown reason, the `qwen2.5:3b` model gave different responses for the same prompt on 2 different occasions. The llama models (`llama3.2:1b`, `llama3.2:3b`) gave identical responses to the same prompt, as expected with a set seed and a temperature of 0. This could make the test less reproducible on other machines. 

## Prompts

- p1 (general): "Explain the difference between a process and a thread in Unix in 4 sentences."
- p2 (grounded RAG): "Context: The nightly backup runs at 02:00 UTC. Backups are stored on the /data/db logical volume and kept for 14 days. Restores require the operator to run restore.sh with the snapshot name. Using only the context above, answer: How long are backups kept and where are they stored?"
- p3 (hallucination check): "Context: The nightly backup runs at 02:00 UTC. Backups are stored on the /data/db logical volume and kept for 14 days. Restores require the operator to run restore.sh with the snapshot name. Using only the context above, answer: Which cloud region hosts the backups?"

## Results

| | llama3.2:1b | llama3.2:3b | qwen2.5:3b |
|---|---|---|---|
| File size | 1.3 GB | 2.0 GB | 1.9 GB |
| Loaded size | 1.5 GB | 2.6 GB | 2.2 GB |
| Container memory | 2.78 GiB | 3.555 GiB | 3.172 GiB |
| Cold load time | 3.49 sec | 7.01 sec | 7.9 sec |
| Appx. Warm TTFT, median of 3 | 0.81 sec | 0.78 sec | 1.18 sec |
| Tokens/sec, median of 3 | 1.6 tokens/sec | 1.3 tokens/sec | 0.8 tokens/sec |
| CPU % during generation | 148.07% | 148.69% | 148.36% |
| p2 correct response? | Yes (3/3) | Yes (3/3) | Yes (3/3) |
| Pass p3 hallucination check? | Yes (3/3) | Yes (3/3) | Yes (3/3) |
| License | [Llama 3.2 Community License Agreement](https://dev.meta.ai/llama/llama3_2/license) | [Llama 3.2 Community License Agreement](https://dev.meta.ai/llama/llama3_2/license) | [Qwen Research License Agreement](https://huggingface.co/Qwen/Qwen2.5-3B/blob/main/LICENSE) |

## Quality Notes

### Prompt 1 (p1) Responses

All p1 responses followed a similar structure; the definition of a process, the definition of a thread, how they are similar, and how they are different.

- `llama3.2:1b`
    - Responses were very bare-bones and didn't use complex sentence structures as much as other models. Contradicted itself and gave incorrect info.
- `llama3.2:3b`
    - Responses included complex sentence structures that were more appealing. Also gave information about some suitable use cases for processes versus threads.
- `qwen2.5:3b`
    - Responses used less complex sentence structures that were less appealing than other options. One other thing to note is that in the cold run, the model responded with 5 sentences, which did not follow the prompt of responding with 4 sentences.

### Prompt 2 (p2) Responses

All p2 responses gave accurate answers, but the quality of each response differed.

- `llama3.2:1b`
    - Responses cited exactly from the context provided. No context was provided in the responses, and the response order was different from the prompt.
- `llama3.2:3b`
    - Responses detailed that the info was cited from the context. Info was ordered relative to the order that the prompt asked.
- `qwen2.5:3b`
    - Responses do not detail the info being cited from the context. Info was ordered relative to the order that the prompt asked.

### Prompt 3 (p3) Responses

All p3 responses acknowledge that they cannot give a correct answer from the provided context. Quality of response varies between models.

- `llama3.2:1b`
    - Does not explain why it cannot answer the question. Responds with a generic phrase.
- `llama3.2:3b`
    - Responses detailed that the info was unable to be garnered from the context. Gave a summary of the info given in the context, and how the prompt could not be answered with the info given.
- `qwen2.5:3b`
    - Responses detailed that the info was unable to be garnered from the context. Included a description of the information that would be needed to complete the request.

## Conclusion

The llama models (`llama3.2:1b`, `llama3.2:3b`) both have a speed greater than 1.25 tokens per second, while the `qwen2.5:3b` model is moderately slower with a speed of 0.8 tokens per second. Under the 1.5 CPU cap, a 150 token answer will take more than 1 minute.

The 3b models (`llama3.2:3b`, `qwen2.5:3b`) both use more than 2.1 GB of loaded memory, while the `llama3.2:1b` model uses a modest 1.5 GB.

The `qwen2.5:3b` model was the slowest of the 3 by a large margin, had the largest diversity of responses to the same prompts, and it also has the most restrictive license, restricting to research and personal use only with commercial use locked behind an exclusive license. Combined with the cold response not following its respective prompt, the `qwen2.5:3b` model is not the best option for our project.

Because the models' bottleneck was the number of CPUs, the best choice for this project is the `llama3.2:3b` model, as the increased cost of loaded memory is not a limitation and the speed of response is comparable to the `llama3.2:1b` model but with a higher quality of response.

## Evidence

Model file sizes: [evidence/model-comp/model-stats.txt](evidence/model-comp/model-stats.txt)

Model benchmarks: 
- `llama3.2:1b`: [evidence/model-comp/bench/bench-llama3.2-1b.txt](evidence/model-comp/bench/bench-llama3.2-1b.txt)
- `llama3.2:3b`: [evidence/model-comp/bench/bench-llama3.2-3b.txt](evidence/model-comp/bench/bench-llama3.2-3b.txt)
- `qwen2.5:3b`: [evidence/model-comp/bench/bench-qwen2.5-3b.txt](evidence/model-comp/bench/bench-qwen2.5-3b.txt)

Model loaded size and container memory:
- `llama3.2:1b`: [evidence/model-comp/ps/ps-llama3.2-1b.txt](evidence/model-comp/ps/ps-llama3.2-1b.txt)
- `llama3.2:3b`: [evidence/model-comp/ps/ps-llama3.2-3b.txt](evidence/model-comp/ps/ps-llama3.2-3b.txt)
- `qwen2.5:3b`: [evidence/model-comp/ps/ps-qwen2.5-3b.txt](evidence/model-comp/ps/ps-qwen2.5-3b.txt)
