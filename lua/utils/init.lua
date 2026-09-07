---@class utils
---@field debug utils.debug
---@field call_hierarchy utils.call_hierarchy
local M = {}

M.debug = require("utils.debug")

M.call_hierarchy = require('utils.call_hierarchy')

return M
