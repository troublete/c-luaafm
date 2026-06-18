# Lua AFM
> run apple foundation model inference in lua

## Requirements

- Xcode must be installed (i.e. requires macOS SDK plugged into Swift for FoundationModel lib)
- macOS version >=26

## Setup

```bash
# compile
make all
```

```lua
require("luaafm")

local s = session("optional system prompt")
local result = inference(s, "prompt")

close_session(s) -- required for memory management
```

## License

MIT
