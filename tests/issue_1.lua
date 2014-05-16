function test1()
    local thing = nil -- @LUACOV_TEST MISSED
    print("test1")
end
test1()

function test2()
    local stuff = function (x) return x end
    local thing = stuff({
        b = { name = 'bob',
        },
        -- comment
    }) -- @LUACOV_TEST EMPTY
    print("test2")
end
test2()

function test3()
    if true then -- @LUACOV_TEST EMPTY
        print("test3")
    end
end
test3()

function test4()
    while true do -- @LUACOV_TEST EMPTY
        print("test4")
        break
    end
end
test4()

-- My own addition:

function test5()
    local stuff = function (x) return x end
    local thing = stuff({
        b = { name = 'bob',
        },
        -- comment
    }
    ) -- @LUACOV_TEST EMPTY
    print("test5")
end
test5()

function test6()
	-- @LUACOV_TEST EMPTY
	if true then -- @LUACOV_TEST EMPTY
	end -- @LUACOV_TEST EMPTY
	print("test6")
end
test6()

function test7()
    local a, b = 1,2
    if
        a < b
    then -- @LUACOV_TEST EMPTY
      a = b
    end -- @LUACOV_TEST EMPTY
    print("test7")
end
test7()

function test8()
    local a,b = 1,2
    if a < b then
      a = b
    end; -- @LUACOV_TEST EMPTY

    local function foo(f) f() end
    foo(function()
      a = b
    end) -- @LUACOV_TEST EMPTY

    print("test8")
end
test8()

function test9()
    local function foo(f)
        return function() -- @LUACOV_TEST EMPTY
            a = a
        end
    end
    foo()()

    print("test9")
end
test9()

function test10()
    local s = {
        a = 1; -- @LUACOV_TEST HIT
        b = 2, -- @LUACOV_TEST HIT
        c = 3  -- @LUACOV_TEST HIT
    }

    print("test10")
end
test10()

function test11()
    local function foo(f)
        return 1, 2, function() -- @LUACOV_TEST HIT
            a = a
        end
    end
    local a,b,c = foo()
    c()

    print("test11")
end
test11()
