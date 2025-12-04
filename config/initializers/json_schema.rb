JSON_SCHEMA = {
  type: "function",
    function: {
      name: "tags-from-content",
      description: "Generate comprehensive tags for any creative content (songs, movies, paintings, etc.)",
      parameters: {
        type: "object",
        properties: {
          tags: {
            type: "object",
            properties: {
              mood: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Emotional atmosphere (melancholic, joyous, tense, etc.)"
              },
              tone: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Overall tone (dark, light, satirical, serious, etc.)"
              },
              theme: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Central themes (love, redemption, conflict, journey, etc.)"
              },
              philosophy: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Philosophical or worldview elements (existentialism, optimism, cynicism, etc.)"
              },
              energy_level: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Energy intensity (calm, intense, explosive, subdued, etc.)"
              },

              pacing: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Temporal flow (fast-paced, slow-burn, rhythmic, episodic, etc.)"
              },
              narrative_structure: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Storytelling approach (linear, non-linear, circular, episodic, etc.)"
              },
              emotional_arc: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Emotional journey (rise-fall, steady, cathartic, ambiguous, etc.)"
              },

              visual_style: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Visual/aesthetic approach (minimalist, ornate, gritty, dreamy, etc.)"
              },
              color_palette: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Color themes (warm, cool, monochromatic, vibrant, muted, etc.)"
              },
              texture: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Textural qualities (smooth, rough, layered, sparse, dense, etc.)"
              },

              cultural_context: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Cultural background or influences (period, region, subculture, etc.)"
              },
              genre: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Genre classifications (rock, drama, abstract, horror, etc.)"
              },

              technique: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Technical approach or style (experimental, traditional, innovative, etc.)"
              },
              complexity: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Complexity level (simple, intricate, accessible, challenging, etc.)"
              },
              originality: {
                type: "array",
                items: { type: "string", minLength: 1, maxLength: 20 },
                description: "Level of innovation (conventional, groundbreaking, derivative, etc.)"
              }
            },
            required: [
              "mood", "tone", "theme", "philosophy", "energy_level",
              "pacing", "narrative_structure", "emotional_arc",
              "visual_style", "color_palette", "texture",
              "cultural_context", "genre", "technique", "complexity", "originality"
            ]
          }
        },
        required: ["content_id", "title", "creator", "type", "tags"]
      },
      strict: true
    }
  }
