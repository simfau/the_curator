JSON_SCHEMA = {
  "type": "function",
  "function": {
    "name": "tags-from-content",
    "parameters": {
      "type": "object",
      "properties": {
        "tags": {
          "type": "object",
          "properties": {
            "mood": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "theme": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "atmosphere": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "pacing": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "narrative_structure": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "aesthetic_style": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "philosophy": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "cultural_context": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "technique": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            }
          }
        }
      },
      "required": ["tags"]
    },
    "strict": true
  }
}
