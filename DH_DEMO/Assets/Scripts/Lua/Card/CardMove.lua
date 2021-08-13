require ("vector")

hand_cards = vector:new()

function Add(object)
    for i = 1, #hand_cards.tempVec, 1 do
        hand_cards:at(i).transform.position.x = hand_cards[i].transform.position.x - 100
    end
    CS.UnityEngine.Object.Instantiate()
    hand_cards:push_back(object)
end

function Use(index)
    local temp = hand_cards:at(index)
    hand_cards:erase(index)
    for i = 1, index, 1 do
        hand_cards[i].transform.position.x = hand_cards[i].transform.position.x + 100
    end
end

return hand_cards