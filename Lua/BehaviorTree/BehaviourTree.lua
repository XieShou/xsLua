---@class BehaviourTree : BehaviourNode
local BehaviourTree = Class("BehaviourTree", BT.BehaviourNode)

function BehaviourTree:__ctor()
    ---当前节点
    ---@type BehaviourNode
    self.current = nil
    self.state = BT.State.NoStart
    self.curIndex = 0
end

function BehaviourTree:__dtor()
    
end

function BehaviourTree:Start()
    local first = self.down[1]
    if not first then
        --无下层节点，空树无法开始
        return
    end
    -- 初始化当前节点并开始运行
    self.curIndex = 1
    self.current = self.down[self.curIndex]
    self:Schedule()
end

function BehaviourTree:Update()
    if self.current then
        if self.state == BT.State.Running then
            self.current:Update()
        end
    end
end

function BehaviourTree:FixedUpdate()
    if self.current then
        if self.state == BT.State.Running then
            self.current:FixedUpdate()
        end
    end
end

function BehaviourTree:LateUpdate()
    if self.current then
        if self.state == BT.State.Running then
            self.current:LateUpdate()
        end
    end
end

function BehaviourTree:GetNext()

end

function BehaviourTree:Schedule()
    -- 调用当前节点逻辑，得到当前节点运行状态
    -- 成功则获得下一个节点，继续执行逻辑
    -- 如果运行则将自己置于挂起状态，等待当前节点逻辑完成
    -- 失败则停止运行，在下一帧时根据'是否自动重新运行'进行再次调度
end

