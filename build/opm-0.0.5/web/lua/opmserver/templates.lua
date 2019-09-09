--[[
   This Lua code was generated by Lemplate, the Lua
   Template Toolkit. Any changes made to this file will be lost the next
   time the templates are compiled.

   Copyright 2016 - Yichun Zhang (agentzh) - All rights reserved.

   Copyright 2006-2014 - Ingy döt Net - All rights reserved.
]]

local gsub = ngx.re.gsub
local concat = table.concat
local type = type
local math_floor = math.floor
local table_maxn = table.maxn

local _M = {
    version = '0.07'
}

local template_map = {}

local function tt2_true(v)
    return v and v ~= 0 and v ~= "" and v ~= '0'
end

local function tt2_not(v)
    return not v or v == 0 or v == "" or v == '0'
end

local context_meta = {}

function context_meta.plugin(context, name, args)
    if name == "iterator" then
        local list = args[1]
        local count = table_maxn(list)
        return { list = list, count = 1, max = count - 1, index = 0, size = count, first = true, last = false, prev = "" }
    else
        return error("unknown iterator: " .. name)
    end
end

function context_meta.process(context, file)
    local f = template_map[file]
    if not f then
        return error("file error - " .. file .. ": not found")
    end
    return f(context)
end

function context_meta.include(context, file)
    local f = template_map[file]
    if not f then
        return error("file error - " .. file .. ": not found")
    end
    return f(context)
end

context_meta = { __index = context_meta }

-- XXX debugging function:
-- local function xxx(data)
--     io.stderr:write("\n" .. require("cjson").encode(data) .. "\n")
-- end

local function stash_get(stash, expr)
    local result

    if type(expr) ~= "table" then
        result = stash[expr]
        if type(result) == "function" then
            return result()
        end
        return result or ''
    end

    result = stash
    for i = 1, #expr, 2 do
        local key = expr[i]
        if type(key) == "number" and key == math_floor(key) and key >= 0 then
            key = key + 1
        end
        local val = result[key]
        local args = expr[i + 1]
        if args == 0 then
            args = {}
        end

        if val == nil then
            if not _M.vmethods[key] then
                if type(expr[i + 1]) == "table" then
                    return error("virtual method " .. key .. " not supported")
                end
                return ''
            end
            val = _M.vmethods[key]
            args = {result, unpack(args)}
        end

        if type(val) == "function" then
            val = val(unpack(args))
        end

        result = val
    end

    return result
end

local function stash_set(stash, k, v, default)
    if default then
        local old = stash[k]
        if old == nil then
            stash[k] = v
        end
    else
        stash[k] = v
    end
end

_M.vmethods = {
    join = function (list, delim)
        delim = delim or ' '
        local out = {}
        local size = #list
        for i = 1, size, 1 do
            out[i * 2 - 1] = list[i]
            if i ~= size then
                out[i * 2] = delim
            end
        end
        return concat(out)
    end,

    first = function (list)
        return list[1]
    end,

    keys = function (list)
        local out = {}
        i = 1
        for key in pairs(list) do
            out[i] = key
            i = i + 1
        end
        return out
    end,

    last = function (list)
        return list[#list]
    end,

    push = function(list, ...)
        local n = select("#", ...)
        local m = #list
        for i = 1, n do
            list[m + i] = select(i, ...)
        end
        return ''
    end,

    size = function (list)
        if type(list) == "table" then
            return #list
        else
            return 1
        end
    end,

    sort = function (list)
        local out = { unpack(list) }
        table.sort(out)
        return out
    end,

    split = function (str, delim)
        delim = delim or ' '
        local out = {}
	local start = 1
	local sub = string.sub
	local find = string.find
	local sstart, send = find(str, delim, start)
        local i = 1
	while sstart do
	    out[i] = sub(str, start, sstart-1)
            i = i + 1
	    start = send + 1
	    sstart, send = find(str, delim, start)
	end
	out[i] = sub(str, start)
	return out
    end,
}

_M.filters = {
    html = function (s, args)
        s = gsub(s, "&", '&amp;', "jo")
        s = gsub(s, "<", '&lt;', "jo");
        s = gsub(s, ">", '&gt;', "jo");
        s = gsub(s, '"', '&quot;', "jo"); -- " end quote for emacs
        return s
    end,

    lower = function (s, args)
        return string.lower(s)
    end,

    upper = function (s, args)
        return string.upper(s)
    end,
}

function _M.process(file, params)
    local stash = params
    local context = {
        stash = stash,
        filter = function (bits, name, params)
            local s = concat(bits)
            local f = _M.filters[name]
            if f then
                return f(s, params)
            end
            return error("filter '" .. name .. "' not found")
        end
    }
    context = setmetatable(context, context_meta)
    local f = template_map[file]
    if not f then
        return error("file error - " .. file .. ": not found")
    end
    return f(context)
end
-- footer.tt2
template_map['footer.tt2'] = function (context)
    if not context then
        return error("Lemplate function called without context\n")
    end
    local stash = context.stash
    local output = {}
    local i = 0

i = i + 1 output[i] = '<div class="content-footer">\n<!-- <hr class="footer-sep"/> -->\n<div class="footer">\n  <p>'
-- line 4 "footer.tt2"
i = i + 1 output[i] = 'Copyright © 2016, 2017 Yichun Zhang (agentzh)'
i = i + 1 output[i] = '</p>\n  <p>'
-- line 5 "footer.tt2"
i = i + 1 output[i] = '100% Powered by OpenResty and PostgreSQL'
i = i + 1 output[i] = '\n     '
-- line 6 "footer.tt2"
i = i + 1 output[i] = '('
i = i + 1 output[i] = '<a href="https://github.com/openresty/opm/">\n     '
-- line 7 "footer.tt2"
i = i + 1 output[i] = 'view the source code of this site'
i = i + 1 output[i] = '</a>'
-- line 7 "footer.tt2"
i = i + 1 output[i] = ')'
i = i + 1 output[i] = '</p>\n  <p>京ICP备16021991号</p>\n</div>\n</div>\n'

    return output
end

-- index.tt2
template_map['index.tt2'] = function (context)
    if not context then
        return error("Lemplate function called without context\n")
    end
    local stash = context.stash
    local output = {}
    local i = 0

i = i + 1 output[i] = '<!DOCTYPE html>\n<html lang="en">\n<head>\n    <meta charset="utf-8">\n    <title>OPM - OpenResty Package Manager</title>\n    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes">\n    <link rel="stylesheet" type="text/css" href="/css/main.css">\n</head>\n<body>\n<h1>\n    <span>\n    <a href="https://openresty.org"><img src="https://openresty.org/images/logo.png" width="64"></a>\n    </span>\n    OPM - OpenResty Package Manager</h1>\n<div>\n    <h2>How to Use</h2>\n    <p>Please read the <a href="https://github.com/openresty/opm#readme">opm documentation</a> for more details.</p>\n    <h2>Recent Uploads</h2>\n    <p>We already have '
-- line 19 "index.tt2"
i = i + 1 output[i] = stash_get(stash, 'total_uploads')
i = i + 1 output[i] = ' successful uploads\n       across '
-- line 20 "index.tt2"
i = i + 1 output[i] = stash_get(stash, 'package_count')
i = i + 1 output[i] = ' distinct package names from '
-- line 20 "index.tt2"
i = i + 1 output[i] = stash_get(stash, 'uploader_count')
i = i + 1 output[i] = '\n       contributors. Come on, OPM authors!</p>\n    <table class="recent">\n    <tbody>'
-- line 56 "index.tt2"

-- FOREACH
do
    local list = stash_get(stash, 'recent_uploads')
    local iterator
    if list.list then
        iterator = list
        list = list.list
    end
    local oldloop = stash_get(stash, 'loop')
    local count
    if not iterator then
        count = table_maxn(list)
        iterator = { count = 1, max = count - 1, index = 0, size = count, first = true, last = false, prev = "" }
    else
        count = iterator.size
    end
    stash.loop = iterator
    for idx, value in ipairs(list) do
        if idx == count then
            iterator.last = true
        end
        iterator.index = idx - 1
        iterator.count = idx
        iterator.next = list[idx + 1]
        stash['row'] = value
i = i + 1 output[i] = '\n    <tr>\n        '
-- line 26 "index.tt2"
stash_set(stash, 'uploader', stash_get(stash, {'row', 0, 'uploader_name', 0}));
-- line 26 "index.tt2"
stash_set(stash, 'org', stash_get(stash, {'row', 0, 'org_name', 0}));
-- line 26 "index.tt2"
stash_set(stash, 'account', stash_get(stash, 'uploader'));
-- line 26 "index.tt2"
if tt2_true(stash_get(stash, 'org')) then
-- line 26 "index.tt2"
stash_set(stash, 'account', stash_get(stash, 'org'));
end

i = i + 1 output[i] = '\n        <td>'
-- line 39 "index.tt2"
if tt2_true(stash_get(stash, {'row', 0, 'indexed', 0})) then
i = i + 1 output[i] = '\n        <span class="indexed">Indexed</span>'
elseif tt2_true(stash_get(stash, {'row', 0, 'failed', 0})) then
i = i + 1 output[i] = '\n        <span class="failed">Failed</span>'
else
i = i + 1 output[i] = '\n        <span class="pending">Pending</span>'
end

i = i + 1 output[i] = '\n        </td>\n\n        <td>\n            <a href="'
-- line 43 "index.tt2"
i = i + 1 output[i] = stash_get(stash, {'row', 0, 'repo_link', 0})
i = i + 1 output[i] = '">\n            '
-- line 44 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, 'account') .. '/' .. stash_get(stash, {'row', 0, 'package_name', 0})

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '\n            </a>\n        </td>\n        <td>v'
-- line 47 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, {'row', 0, 'version_s', 0})

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '</td>\n        <td>'
-- line 48 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, {'row', 0, 'abstract', 0})

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '</td>\n        <td>\n            <a href="https://github.com/'
-- line 50 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, 'uploader')

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '/">\n                '
-- line 51 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, 'uploader')

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '\n            </a>\n        </td>\n        <td>'
-- line 54 "index.tt2"

-- FILTER
local value
do
    local output = {}
    local i = 0

i = i + 1 output[i] = stash_get(stash, {'row', 0, 'created_at', 0})

    value = context.filter(output, 'html', {})
end
i = i + 1 output[i] = value

i = i + 1 output[i] = '</td>\n    </tr>'
        iterator.first = false
        iterator.prev = value
    end
    stash_set(stash, 'loop', oldloop)
end

i = i + 1 output[i] = '\n    </tbody>\n    </table>\n</div>\n'
-- line 60 "index.tt2"
i = i + 1 output[i] = context.process(context, 'footer.tt2')
i = i + 1 output[i] = '\n</body>\n<script>\nvar ga_func = function () {\n    (function(i,s,o,g,r,a,m){i[\'GoogleAnalyticsObject\']=r;i[r]=i[r]||function(){\n        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),\n    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)\n    })(window,document,\'script\',\'https://www.google-analytics.com/analytics.js\',\'ga\');\n\n    ga(\'create\', \'UA-24724965-2\', \'auto\');\n    ga(\'send\', \'pageview\');\n}\nsetTimeout(ga_func, 0);\n</script>\n</html>\n'

    return output
end

return _M