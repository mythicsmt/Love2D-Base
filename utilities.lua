local Utilities = {}

function Utilities.distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
end

function Utilities.doLineSegmentsOverlap(x1, y1, x2, y2, x3, y3, x4, y4)
    local dx1, dy1 = x2 - x1, y2 - y1
    local dx2, dy2 = x4 - x3, y4 - y3
    local det = dx1 * dy2 - dx2 * dy1
    local dxc, dyc = x3 - x1, y3 - y1
    local t1 = (dxc * dy2 - dx2 * dyc) / det
    local t2 = (dxc * dy1 - dx1 * dyc) / det
    if t1 >= 0 and t1 <= 1 and t2 >= 0 and t2 <= 1 then
        return true
    end

    return false
end

function Utilities.calculateIntersectionsOnLineBetweenCircles(circle1, circle2)
    local dx = circle2.x - circle1.x
    local dy = circle2.y - circle1.y

    local length = math.sqrt(dx * dx + dy * dy)
    local factor = circle1.r / length

    local intersection1 = {
        x = circle1.x + dx * factor,
        y = circle1.y + dy * factor
    }

    local factor2 = circle2.r / length

    local intersection2 = {
        x = circle2.x - dx * factor2,
        y = circle2.y - dy * factor2
    }

    return intersection1, intersection2
end

function Utilities.distanceFromPointToConnection(x, y, connection)
    local A = x - connection.x1
    local B = y - connection.y1
    local C = connection.x2 - connection.x1
    local D = connection.y2 - connection.y1

    local dot = A * C + B * D
    local len_sq = C * C + D * D
    local param = dot / len_sq

    local xx, yy

    if param < 0 then
        xx, yy = connection.x1, connection.y1
    elseif param > 1 then
        xx, yy = connection.x2, connection.y2
    else
        xx, yy = connection.x1 + param * C, connection.y1 + param * D
    end

    local distance = Utilities.distance(xx, yy, x, y)
    return distance
end

function Utilities.iterativeCollectNodes(alphaNode)
    local collectedNodes = {}
    local stack = {alphaNode} 

    while #stack > 0 do
        local currentNode = table.remove(stack)

        if not table.contains(collectedNodes, currentNode) then
            table.insert(collectedNodes, currentNode)

            if currentNode.connections then
                for _, connection in pairs(currentNode.connections) do
                    if connection.nodes then
                        for _, node in pairs(connection.nodes) do
                            if not table.contains(collectedNodes, node) then
                                table.insert(stack, node)
                            end
                        end
                    end
                end
            end
        end
    end

    return collectedNodes
end

function Utilities.iterativeCollectConnections(alphaNode)
    local collectedConnections = {}
    local stack = {alphaNode}

    while #stack > 0 do
        local currentNode = table.remove(stack)

        if currentNode.connections then
            for _, connection in pairs(currentNode.connections) do
                if not table.contains(collectedConnections, connection) then
                    table.insert(collectedConnections, connection)

                    if connection.nodes then
                        for _, node in pairs(connection.nodes) do
                            if not table.contains(stack, node) then
                                table.insert(stack, node)
                            end
                        end
                    end
                end
            end
        end
    end

    return collectedConnections
end

function Utilities.nearestConnectionToNode(connections, comparingNode) 
    local nearestConnection = nil
    local minDistance = math.huge

    if not connections then
        return nearestConnection, minDistance
    end

    for _, connection in ipairs(connections) do
        local distance = Utilities.distanceFromPointToConnection(comparingNode.x, comparingNode.y, connection)
        if distance < minDistance then
            nearestConnection = connection
            minDistance = distance
        end
    end    

    return nearestConnection, minDistance
end

function Utilities.isIntersectingWithAnyConnection(connections, node1, node2)
    if not connections then
        return false
    end

    for _, connection in ipairs(connections) do
        if Utilities.doLineSegmentsOverlap(connection.x1, connection.y1, connection.x2, connection.y2, node1.x, node1.y, node2.x, node2.y) then
            return true
        end
    end
    return false
end

function Utilities.nearestValidNode(alphaNode, comparingNode)
    local nearestNode, distance = Utilities.nearestNode(alphaNode, comparingNode)
    if distance <= 0 then
        return nil
    end    

    local connections = Utilities.iterativeCollectConnections(alphaNode)
    local nearestConnection, distance = Utilities.nearestConnectionToNode(connections, comparingNode)
    if distance <= comparingNode.r then
        return nil
    end

    local nearestNode = nil
    local minDistance = math.huge
    local nodes = Utilities.iterativeCollectNodes(alphaNode)

    for _, node in ipairs(nodes) do
        local distance = Utilities.distance(comparingNode.x, comparingNode.y, node.x, node.y) - (node.r + comparingNode.r)
        if distance <= minDistance then
            if not Utilities.isIntersectingWithAnyConnection(connections, comparingNode, node) then
                nearestNode = node
                minDistance = distance                
            end
        end
    end

    return nearestNode
end

function Utilities.nearestNode(alphaNode, comparingNode)
    local nodes = Utilities.iterativeCollectNodes(alphaNode)
    local nearestNode = alphaNode
    local distance = Utilities.distance(comparingNode.x, comparingNode.y, alphaNode.x, alphaNode.y) - (alphaNode.r + comparingNode.r)

    for _, node in ipairs(nodes) do
        local newDistance = Utilities.distance(comparingNode.x, comparingNode.y, node.x, node.y) - (node.r + comparingNode.r)
        if newDistance < distance then
            nearestNode = node
            distance = newDistance
        end
    end     
    
    return nearestNode, distance
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

return Utilities