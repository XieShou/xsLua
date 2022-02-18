require("Lua.Class")



BT = {}

BT.State = {
    NoStart = "NoStart",
    Success = "Success",
    Running = "Running",
    Fail = "Fail",
}

BT.BehaviourNode = require("Lua.BehaviorTree.BehaviourNode")
BT.BehaviourTree = require("Lua.BehaviorTree.BehaviourTree")

require("Lua.BehaviorTree.BehaviourNode")

