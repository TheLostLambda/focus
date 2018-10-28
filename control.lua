--
-- Created by IntelliJ IDEA.
-- User: tom
-- Date: 27/10/2018
-- Time: 16:09
-- To change this template use File | Settings | File Templates.
--

require("love.timer")
require("love.image")
require("love.thread")
local pl = require('pl.pretty')

local server = require("osc.server")

local thread

module("control")

--plin = require('pl.pretty')

function uint(n)
    if n >= 2 ^ 31 then
        return n - 2 ^ 32
    end
    return n
end

function setup(love)
    --local pl = plin
    pl.dump(msg)

    --local this_thread = love.thread.getThread()

    love.thread.getChannel( 'info' ):push( "messagestart" )
    tserv = server.new{host="127.0.0.1", port = 7777, handle = function (_, msg)
        if msg[3] == "s" then
            --pl.dump(msg)
            love.thread.getChannel( 'info' ):push( msg[4] )
        elseif msg[17] == "i" then
            love.thread.getChannel( 'data' ):push( {uint(msg[4]), uint(msg[8]), uint(msg[12]), uint(msg[16])} )
        end
    end
    }



    tserv:loop()


end