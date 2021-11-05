function start(song)

    spinLength = 19

end

function update(elapsed)

    if difficulty == 2 and curStep > 128 then

        if spinLength < 32 then

            spinLength = spinLength + 6

        end

        local currentBeat = (songPos / 1000)*(bpm/60)

    for i=0,7,1 do

            local receptor = _G['receptor_'..i]

        receptor.x = receptor.defaultX + spinLength * math.sin((currentBeat + i*50) * math.pi)

        receptor.y = receptor.defaultY + spinLength * math.cos((currentBeat + i*0.25) * math.pi)

        end

    end

end

function playerTwoTurn()

    camGame:tweenZoom(0.7,(crochet * 4) / 1000)

end

function playerOneTurn()

    camGame:tweenZoom(0.7,(crochet * 4) / 1000)

end

print("Yay The Mod Chart script  Has loaded In :D")