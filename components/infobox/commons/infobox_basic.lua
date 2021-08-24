---
-- @Liquipedia
-- wiki=commons
-- page=Module:Infobox/Basic
--
-- Please see https://github.com/Liquipedia/Lua-Modules to contribute
--

local Class = require('Module:Class')
local Infobox = require('Module:Infobox')
local String = require('Module:String')
local Logic = require('Module:Logic')
local getArgs = require('Module:Arguments').getArgs

local BasicInfobox = Class.new(
	function(self, frame)
		self.args = getArgs(frame)
		self.pagename = mw.title.getCurrentTitle().text
		self.name = self.args.name or self.pagename

		if self.args.wiki == nil then
			return error('Please provide a wiki!')
		end

		self.infobox = Infobox:create(frame, self.args.wiki)
	end
)

--- Allows for overriding this functionality
function BasicInfobox:addCustomCells(infobox, args)
    return infobox
end

--- Allows for overriding this functionality
function BasicInfobox:addCustomContent(infobox, args)
    return infobox
end

--- Allows for overriding this functionality
function BasicInfobox:createBottomContent(infobox)
    return nil
end

--- Allows for using this for customCells
function BasicInfobox:getAllArgsForBase(args, base, options)
	local foundArgs = {}
	if String.isEmpty(args[base]) then
		return foundArgs
	end

	options = options or {}
	local makeLink = Logic.readBool(options.makeLink)

	local baseArg = args[base]
	if makeLink then
		baseArg = '[[' .. (args[base .. 'link'] or baseArg)
			.. '|' .. baseArg .. ']]'
	end

	table.insert(foundArgs, baseArg)
	local index = 2

	while not String.isEmpty(args[base .. index]) do
		local indexedbase = args[base .. index]
		if makeLink then
			indexedbase = '[[' .. (args[base .. index .. 'link'] or indexedbase)
				.. '|' .. indexedbase .. ']]'
		end
		table.insert(foundArgs, indexedbase)
		index = index + 1
	end

	return foundArgs
end

return BasicInfobox
