---@class BehaviourNode : Class
local BehaviourNode = Class("BehaviourNode")

function BehaviourNode:__ctor()
    self.up = nil

    --- 按照index从小到大，对用从左到右的调度顺序
    self.down = {}
end

function BehaviourNode:__dtor()
    
end

---@generic T : BehaviourNode
---@param node : T
---@return T
function BehaviourNode:AddNode(node, ...)

end

---调度到当前节点
function BehaviourNode:Schedule()

end

--region 节点生命周期

function BehaviourNode:OnEnter()

end

function BehaviourNode:Update()
    
end

function BehaviourNode:FixedUpdate()
    
end

function BehaviourNode:LateUpdate()
    
end

function BehaviourNode:OnLeave()

end

--endregion