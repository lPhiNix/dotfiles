-- #######################################################################################
-- HYPRLAND CONFIG.
-- EDIT THIS CONFIG ACCORDING TO THE WIKI INSTRUCTIONS.
-- #######################################################################################

-- This is an example Hyprland config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- ###############
-- ### SOURCES ###
-- ###############

-- You can split this configuration into multiple files
-- Create your files separately and then link them to this file like this:
-- require("myColors")
require("configs.workspaces")
require("configs.monitors")
require("configs.programs")
require("configs.autostart")
require("configs.permissions")
require("configs.appearance")
require("configs.input")
require("configs.keybinds")
require("configs.animations")


-- #############################
-- ### ENVIRONMENT VARIABLES ###
-- #############################

-- See https://wiki.hypr.land/Configuring/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")