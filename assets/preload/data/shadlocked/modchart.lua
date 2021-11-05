-- this gets called starts when the level loads.
function start(song) -- arguments, the song name

end

-- this gets called every frame
function update (elapsed)
	if curStep >= 0 and curStep < 263 then
		local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
		end
    	end
		if curStep >= 264 and curStep < 519 then
			local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,7 do
				setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
			end
			end
			if curStep >= 520 and curStep < 648 then
				local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,7 do
					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
				end
				end
				if curStep >= 649 and curStep < 779 then
					local currentBeat = (songPos / 1000)*(bpm/60)
					for i=0,7 do
						setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
						setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
					end
					end
					if curStep >= 780 and curStep < 909 then
						local currentBeat = (songPos / 1000)*(bpm/60)
						for i=0,7 do
							setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
							setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
						end
						end
						if curStep >= 927 and curStep < 1206 then
							local currentBeat = (songPos / 1000)*(bpm/60)
							for i=0,7 do
								setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
								setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
							end
							end
							if curStep >= 1207 and curStep < 1208 then
								local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,7 do
									setActorX(_G['defaultStrum'..i..'X'] + 0 * math.sin((currentBeat + i*0) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 0 * math.cos((currentBeat + i*0) * math.pi), i)
								end
								end
							if curStep >= 1225 and curStep < 1522 then
								local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,7 do
									setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
								end
								end
								if curStep >= 1523 and curStep < 1857 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=0,7 do
										setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*0.25) * math.pi), i)
										setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*0.75) * math.pi), i)
									end
									end
									if curStep >= 1858 and curStep < 1859 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=0,7 do
											setActorX(_G['defaultStrum'..i..'X'] + 0 * math.sin((currentBeat + i*0) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 0 * math.cos((currentBeat + i*0) * math.pi), i)
										end
										end

end

function stepHit (step)
	if step == 312 then
		camHudAngle = 8
	end
	if step == 320 then
		camHudAngle = -8
	end
	if step == 328 then
		camHudAngle = 0
	end	
	if step == 440 then
		camHudAngle = 8
	end
		if step == 448 then
			camHudAngle = -8
		end
			if step == 456 then
				camHudAngle = 0
			end	
	if step == 272 then
		setCamZoom(1.2)
	end
	if step == 276 then
		setCamZoom(1.2)
	end
	if step == 336 then
		setCamZoom(1.2)
	end
	if step == 340 then
		setCamZoom(1.2)
	end
	if step == 400 then
		setCamZoom(1.2)
	end
	if step == 404 then
		setCamZoom(1.2)
	end
	if step == 464 then
		setCamZoom(1.2)
	end
	if step == 468 then
		setCamZoom(1.2)
	end
	if step == 528 then
		setCamZoom(1.2)
	end
	if step == 532 then
		setCamZoom(1.2)
	end
	if step == 592 then
		setCamZoom(1.2)
	end
	if step == 596 then
		setCamZoom(1.2)
	end
	if step == 656 then
		setCamZoom(1.2)
	end
	if step == 660 then
		setCamZoom(1.2)
	end
	if step == 720 then
		setCamZoom(1.2)
	end
	if step == 724 then
		setCamZoom(1.2)
	end
	if step == 789 then
		setCamZoom(1.2)
	end
	if step == 794 then
		setCamZoom(1.2)
	end
	if step == 864 then
		setCamZoom(1.2)
	end
	if step == 868 then
		setCamZoom(1.2)
	end
	if step == 938 then
		setCamZoom(1.2)
	end
	if step == 942 then
		setCamZoom(1.2)
	end
	if step == 1012 then
		setCamZoom(1.2)
	end
	if step == 1017 then
		setCamZoom(1.2)
	end
	if step == 1087 then
		setCamZoom(1.2)
	end
	if step == 1091 then
		setCamZoom(1.2)
	end
	if step == 1161 then
		setCamZoom(1.2)
	end
	if step == 1165 then
		setCamZoom(1.2)
	end
end