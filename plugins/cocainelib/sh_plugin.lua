local PLUGIN = PLUGIN

PLUGIN.name = "Minerva Servers Cocaine Library"
PLUGIN.description = ""
PLUGIN.author = "Riggs"

--[[---------------------------------------------------------------------------
    Plugin Config
---------------------------------------------------------------------------]]--

PLUGIN.CustomModels = {}
PLUGIN.CustomModels.Stove = true -- Replaces default model of stove to portable one.
PLUGIN.CustomModels.Plant = true -- Replaces default plantation model to a new one.
PLUGIN.CustomModels.Gascan = true -- Replaces default model of gas to gascan.
PLUGIN.CustomModels.Cocaine = true -- Replaces default model of cocaine to brick of cocaine.

PLUGIN.Draw = {}
PLUGIN.Draw.Distance = 512 -- Distance when 3D2D interface starts loading.
PLUGIN.Draw.AimingOnEntity = false -- Draw 3D2D Interface when player aim on entity.
PLUGIN.Draw.FadeInOnComingCloser = true -- Draw 3D2D Interface when player coming closer to entity.

PLUGIN.Plant = {}
PLUGIN.Plant.Leaves = 15 -- Amount of leaves on coca plantation.
PLUGIN.Plant.DropSeed = true -- Drop Coca Seed with a random chance when all leaves are collected? Yes - true, No - false.
PLUGIN.Plant.GrowingTimer = 5 -- Time to grow up plant.
PLUGIN.Plant.RespawnTimer = 5 -- Time to re-grow up leaves.

PLUGIN.Seed = {}
PLUGIN.Seed.Model = "models/props/cs_office/plant01_gib1.mdl" -- The model of Coca Seed.
PLUGIN.Seed.RemovingTime = 300 -- Time to get removed after spawn.

PLUGIN.Box = {} 
PLUGIN.Box.MaxAmount = 20 -- Maximal amount of leaves in box.

PLUGIN.Kerosin = {}
PLUGIN.Kerosin.MaxAmount = 45 -- Maximal amount of leaves that will allow player to shake them with kerosin.

PLUGIN.Drafting = {}
PLUGIN.Drafting.Timer = 10 -- Time that you should wait until start shaking.
PLUGIN.Drafting.MaxAmount = 2 -- Maximal amount of leaves in kerosin.

PLUGIN.Cleaning = {}
PLUGIN.Cleaning.Timer = 10 -- Time that for cleaning semi-drug.
PLUGIN.Cleaning.MaxAmount = 2 -- Maximal amount of drufted leaves.

PLUGIN.Pot = {}
PLUGIN.Pot.MaxAmount = 1 -- Maximal amount of cleaned semi-drugs.
PLUGIN.Pot.Temperature = 70 -- Temperature of cooked dirty drug.
PLUGIN.Pot.ExplodeTemperature = 100 -- If temperature is higher, pot will explode. 

PLUGIN.Stove = {}
PLUGIN.Stove.GravityGun = true -- 'true' lets stove be used by gravity-gun.
PLUGIN.Stove.MaxAmountOfGas = 350 -- Maximal amount of gas in stove.

PLUGIN.Gas = {}
PLUGIN.Gas.Amount = 350 -- Amount in one gas cylinder.

PLUGIN.Gasoline = {}
PLUGIN.Gasoline.Timer = 120 -- Time to clean dirty drug.
PLUGIN.Gasoline.MaxAmount = 1 -- Maximal amount of cooked dirty drug.

PLUGIN.Cocaine = {}
PLUGIN.Cocaine.Reward = 1200 -- Reward for cocaine 

ix.util.Include("cl_plugin.lua")
ix.util.Include("sv_plugin.lua")
