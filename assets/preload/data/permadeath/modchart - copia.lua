function start (song)
	setCamZoom(1)
	setHudZoom(2)
	showOnlyStrums = true
	strumLine1Visible = false
	strumLine2Visible = false
	
	end
	
	
	function update (elapsed)
			if curStep == 5 then
			setHudZoom(1)
		end
			if curStep == 100 then
			setHudZoom(2)
		end
			if curStep == 120 then
			strumLine1Visible = true
		end
			if curStep == 130 then
			strumLine2Visible = true
		end

		if curStep == 170 then
			setCamZoom(1.7)
		end

		if curStep == 200 then
			setCamZoom(1.7)
		end

		if curStep == 270 then
			setCamZoom(1.7)
		end

		if curStep == 300 then
			setCamZoom(1.7)
		end

		if curStep == 350 then
			setCamZoom(1.7)
		end

		if curStep == 400 then
			setCamZoom(1.7)
		end
			if curStep == 576 then
			setCamZoom(1.7)
			showOnlyStrums = true
		end
			if curStep == 580 then
			setCamZoom(1.7)
		end

		if curStep == 650 then
			setCamZoom(1.7)
		end

		if curStep == 700 then
			setCamZoom(1.7)
		end

		if curStep == 750 then
			setCamZoom(1.7)
		end

			if curStep == 880 then
			setCamZoom(0.4)
		end
			if curStep == 895 then
			setCamZoom(1)
		end
			if curStep == 896 then
			setCamZoom(1.7)
		end
			if curStep == 898 then
			setCamZoom(1.7)
		end

		if curStep == 980 then
			setCamZoom(1.7)
		end

		if curStep == 1000 then
			setCamZoom(1.7)
		end

		if curStep == 1100 then
			setCamZoom(1.7)
		end

		if curStep == 1200 then
			setCamZoom(1.7)
		end

			if curStep == 1280 then
			setCamZoom(1.7)
		end
			if curStep == 1282 then
			setCamZoom(1.7)
		end
			if curStep == 1288 then
			setCamZoom(0.4)
		end
			if curStep == 1290 then
			showOnlyStrums = true
		end

		if curStep == 1350 then
			setCamZoom(1.7)
		end

		if curStep == 1400 then
			setCamZoom(1.7)
		end

		if curStep == 1450 then
			setCamZoom(1.7)
		end

		if curStep == 1500 then
			setCamZoom(1.7)
		end

		if curStep == 1600 then
			setCamZoom(1.7)
		end

		if curStep == 1650 then
			setCamZoom(1.7)
		end

		if curStep == 1700 then
			setCamZoom(1.7)
		end

		if curStep == 1750 then
			setCamZoom(1.7)
		end

		if curStep == 1800 then
			setCamZoom(1.7)
		end

		if curStep == 1850 then
			setCamZoom(1.7)
		end

		if curStep == 1900 then
			setCamZoom(1.7)
		end

		if curStep == 1950 then
			setCamZoom(1.7)
		end

		if curStep == 2000 then
			setCamZoom(1.7)
		end

		if curStep == 2150 then
			setCamZoom(1.7)
		end

		if curStep == 2220 then
			setCamZoom(1.7)
		end

		if curStep == 2350 then
			setCamZoom(1.7)
		end

		if curStep == 2400 then
			setCamZoom(1.7)
		end

		if curStep == 2450 then
			setCamZoom(1.7)
		end

		if curStep == 2500 then
			setCamZoom(1.7)
		end

		if curStep == 2550 then
			setCamZoom(1.7)
		end

		if curStep == 2600 then
			setCamZoom(1.7)
		end

		if curStep == 2650 then
			setCamZoom(1.7)
		end
	
		if curStep == 2750 then
			setCamZoom(1.7)
		end

		if curStep == 2800 then
			setCamZoom(1.7)
		end

		if curStep == 2900 then
			setCamZoom(1.7)
		end

		if curStep == 2950 then
			setCamZoom(1.7)
		end

		if curStep == 3000 then
			setCamZoom(1.7)
		end

		if curStep == 3100 then
			setCamZoom(1.7)
		end

		if curStep == 3700 then
			setCamZoom(1.7)
		end

		if curStep == 3750 then
			setCamZoom(1.7)
		end

		if curStep == 3800 then
			setCamZoom(1.7)
		end

		if curStep == 3900 then
			setCamZoom(1.7)
		end

		if curStep == 4007 then
			setCamZoom(1.7)
		end

		if curStep == 4100 then
			setCamZoom(1.7)
		end

		if curStep == 4150 then
			setCamZoom(1.7)
		end

		if curStep == 4200 then
			setCamZoom(1.7)
		end
		if curStep == 4250 then
			setCamZoom(1.7)
		end

		if curStep == 4300 then
			setCamZoom(1.7)
		end

		if curStep == 4350 then
			setCamZoom(1.7)
		end

		if curStep == 4450 then
			setCamZoom(1.7)
		end

		if curStep == 4500 then
			setCamZoom(1.7)
		end


		if curStep >= 384 and curStep < 447 then
		local currentBeat = (songPos / 1000)*(bpm/120)
			for i=0,5 do
				setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
			end
		end
		if curStep >= 450 and curStep < 600 then
			local currentBeat = (songPos / 1000)*(bpm/120)
				for i=0,5 do
					setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
				end
			end
		if curStep >= 767 and curStep < 895 then
		local currentBeat = (songPos / 1000)*(bpm/120)
			for i=6,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
			end
		end
		if curStep >= 895 and curStep < 1007 then
		local currentBeat = (songPos / 1000)*(bpm/120)
			for i=0,5 do
				setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
			end
		end
		if curStep >= 1151 and curStep < 1225 then
		local currentBeat = (songPos / 1000)*(bpm/120)
			for i=6,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
		end
	end
		if difficulty == 575 and curStep < 766 then
				local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
		if difficulty == 766 and curStep < 894 then
				local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,5 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
		if difficulty == 895 and curStep < 1250 then
				local currentBeat = (songPos / 1000)*(bpm/60)
			for i=6,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
			if difficulty == 1300 and curStep < 1500 then
				local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end


		if curStep >= 1500 and curStep < 2000 then
			local currentBeat = (songPos / 1000)*(bpm/120)
				for i=0,5 do
					setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
				end
			end
			if curStep >= 2000 and curStep < 2500 then
				local currentBeat = (songPos / 1000)*(bpm/120)
					for i=0,5 do
						setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
						setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
					end
				end
			if curStep >= 2500 and curStep < 3000 then
			local currentBeat = (songPos / 1000)*(bpm/120)
				for i=6,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
				end
			end
			if curStep >= 3000 and curStep < 3500 then
			local currentBeat = (songPos / 1000)*(bpm/120)
				for i=0,5 do
					setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
				end
			end
			if curStep >= 3500 and curStep < 4000 then
			local currentBeat = (songPos / 1000)*(bpm/120)
				for i=6,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
			end
		end
			if difficulty == 4000 and curStep < 4500 then
					local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
					setActorY(_G['defaultStrum'..i..'Y'],i)
				end
			end
			if difficulty == 4500 and curStep < 5000 then
					local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,5 do
					setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
					setActorY(_G['defaultStrum'..i..'Y'],i)
				end
			end
			if difficulty == 5000 and curStep < 5500 then
					local currentBeat = (songPos / 1000)*(bpm/60)
				for i=6,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
					setActorY(_G['defaultStrum'..i..'Y'],i)
				end
			end
				if difficulty == 5500 and curStep < 6000 then
					local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
					setActorY(_G['defaultStrum'..i..'Y'],i)
				end
			end

			if curStep >= 2000 and curStep < 4600 then
				local currentBeat = (songPos / 1000)*(bpm/120)
					for i=0,5 do
						setActorX(_G['defaultStrum'..i..'X'] + 5 * math.sin((currentBeat + i*50) * math.pi), i)
						setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*0.25) * math.pi), i)
						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
					end
				end

				if difficulty == 2000 and curStep < 4500 then
					local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,12 do
					setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
					setActorY(_G['defaultStrum'..i..'Y'],i)
				end
			end

			if difficulty == 2000 and curStep < 4500 then
				local currentBeat = (songPos / 1000)*(bpm/60)
			for i=6,12 do
				setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i*0)), i)
				setActorY(_G['defaultStrum'..i..'Y'],i)
			end
		end
			

	end

	-- :shadounepoto: