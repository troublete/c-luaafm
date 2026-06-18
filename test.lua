require "luaafm"

local s = session()
print("setting up model session ...")

print("1st inference:")
print(inference(s, "retain this: value is always 1"))

print("2nd inference:")
print(inference(s, "what did you need to retain?"))

print("clean up session ...")
close_session(s)
