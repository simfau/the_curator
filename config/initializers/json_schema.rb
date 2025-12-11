JSON_SCHEMA = {
  "type": "function",
  "function": {
    "name": "tags-from-content",
    "description": "Generate comprehensive tags for any creative content (songs, movies, paintings, etc.)",
    "parameters": {
        "type": "object",
        "properties": {
        "tags": {
          "type": "object",
          "properties": {
            "emotion": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "theme": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
            "narrative_structure": {
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
            "aesthetic_style": {
              "type": "array",
              "items": { "type": "string", "maxLength": 40 },
            },
          }
        }
      },
      "required": ["tags"]
    },
    "strict": true
  }
}
