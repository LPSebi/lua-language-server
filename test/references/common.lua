local config = require "config"
TEST [[
local <~a~> = 1
<!a!> = <!a!>
]]

TEST [[
<~a~> = 1
<!a!> = <!a!>
]]

TEST [[
local t
t.<~a~> = 1
t.<!a!> = t.<!a!>
]]

TEST [[
t.<~a~> = 1
t.<!a!> = t.<!a!>
]]

TEST [[
:: <!LABEL!> ::
goto <~LABEL~>
if true then
    goto <!LABEL!>
end
]]

TEST [[
:: <~LABEL~> ::
goto <!LABEL!>
if true then
    goto <!LABEL!>
end
]]

TEST [[
local a = 1
local <~a~> = 1
<!a!> = <!a!>
]]

TEST [[
local <~a~>
local b = <!a!>
]]

TEST [[
local t = {
    <~a~> = 1
}
print(t.<!a!>)
]]

TEST [[
t[<~'a'~>] = 1
print(t.<!a!>)
]]

TEST [[
local t = {
    [<~'a'~>] = 1
}
print(t.<!a!>)
]]

TEST [[
table.<!dump!>()
function table.<~dump~>()
end
]]

TEST [[
local t = {}
t.<~x~> = 1
t[a.b.c] = 1
]]

TEST [[
local t = {}
t.x = 1
t[a.b.<~x~>] = 1
]]

TEST [[
self = {
    results = {
        <~labels~> = {},
    }
}
self[self.results.<!labels!>] = lbl
]]

TEST [[
a.b.<~c~> = 1
print(a.b.<!c!>)
]]

TEST [[
local <!mt!> = {}
function mt:x()
    <~self~>:x()
end
]]

TEST [[
local <~mt~> = {}
function <!mt!>:x()
    self:x()
end
]]

TEST [[
local mt = {}
function mt:<!x!>()
    self:<~x~>()
end
]]

TEST [[
local mt = {}
function mt:<~x~>()
    self:<!x!>()
end
]]

TEST [[
a.<!b!>.c = 1
print(a.<~b~>.c)
]]

TEST [[
_G.<~xxx~> = 1

print(<!xxx!>)
]]

TEST [[
---@class <~Class~>
---@type <!Class!>
---@type <!Class!>
]]

TEST [[
---@class Class
local <~t~>
---@type Class
local x
]]

TEST [[
---@class Class
local t
---@type Class
local <~x~>
]]

-- BUG
TEST [[
---@return <~xxx~>
function f() end
]]

TEST [[
---@class A
---@class B: A

---@type A
local <~t~>
]]

--TEST [[
-----@class A
--local a
--
-----@type A
--local b
--
-----@type A
--local c
--
--b.<~x~> = 1
--c.<!x!> = 1
--]]
