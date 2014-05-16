local luacov_reporter = require "luacov.reporter"

local ReporterBase = luacov_reporter.ReporterBase

----------------------------------------------------------------
local TestReporter = setmetatable({}, ReporterBase) do
TestReporter.__index = TestReporter

local function debug_print(o, ...)
   if not o._debug then return end
   io.stdout:write(...)
end

function TestReporter:pass(filename, lineno, line)
   self._pass = self._pass + 1
end

function TestReporter:fail(filename, lineno, line)
   self._fail = self._fail + 1
end

local function match_test(line)
   return (line:match("%-%-%s+@LUACOV_TEST (%S+)%s*$"))
end

function TestReporter:test(cond, filename, lineno, line)
   local pat = match_test(line)
   if not pat then return end
   local find = not not string.find("|" .. pat .. "|", "|" .. cond .. "|", nil, true)
   if find then return self:pass(filename, lineno, line) end
   self:fail(filename, lineno, line)
   print("  Fail - " .. lineno .. " - " .. line:gsub("^%s+", ""))
end

function TestReporter:new(conf)
   local o, err = ReporterBase.new(self, conf)
   if not o then return nil, err end
   
   return o
end

function TestReporter:on_start()
   self._pass = 0
   self._fail = 0
end

function TestReporter:on_new_file(filename)
   print("Start test :", filename)
end

function TestReporter:on_empty_line(filename, lineno, line)
   self:test("EMPTY", filename, lineno, line)
end

function TestReporter:on_mis_line(filename, lineno, line)
   self:test("MISSED", filename, lineno, line)
end

function TestReporter:on_hit_line(filename, lineno, line, hits)
   self:test("HIT", filename, lineno, line)
end

function TestReporter:on_end_file(filename, hits, miss)

end

function TestReporter:on_end()
   if self._fail > 0 then
      os.exit(1)
   end
end

end
----------------------------------------------------------------

return { report = function() return luacov_reporter.report(TestReporter) end }
