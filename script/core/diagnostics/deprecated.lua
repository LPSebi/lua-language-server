local files    = require 'files'
local vm       = require 'vm'
local lang     = require 'language'
local guide    = require 'parser.guide'
local config   = require 'config'
local define   = require 'proto.define'
local await    = require 'await'

local types = {'getglobal', 'getfield', 'getindex', 'getmethod'}
---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local dglobals = config.get(uri, 'Lua.diagnostics.globals')
    local rspecial = config.get(uri, 'Lua.runtime.special')
    local cache    = {}

    guide.eachSourceTypes(ast.ast, types, function (src) ---@async
        if src.type == 'getglobal' then
            local key = src[1]
            if not key then
                return
            end
            if dglobals[key] then
                return
            end
            if rspecial[key] then
                return
            end
        end

        await.delay()

        if not vm.isDeprecated(src, true) then
            return
        end

        await.delay()

        local defs = vm.getDefs(src)
        local validVersions
        for _, def in ipairs(defs) do
            if def.bindDocs then
                for _, doc in ipairs(def.bindDocs) do
                    if doc.type == 'doc.version' then
                        validVersions = vm.getValidVersions(doc)
                        break
                    end
                end
            end
        end

        local message = lang.script.DIAG_DEPRECATED
        local versions
        if validVersions then
            versions = {}
            for version, valid in pairs(validVersions) do
                if valid then
                    versions[#versions+1] = version
                end
            end
            table.sort(versions)
            if #versions > 0 then
                message = ('%s(%s)'):format(message
                    , lang.script('DIAG_DEFINED_VERSION'
                    , table.concat(versions, '/')
                    , config.get(uri, 'Lua.runtime.version'))
                )
            end
        end

        callback {
            start   = src.start,
            finish  = src.finish,
            tags    = { define.DiagnosticTag.Deprecated },
            message = message,
            data    = {
                versions = versions,
            }
        }
    end)
end
