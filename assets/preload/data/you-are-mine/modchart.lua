function start(song) -- do nothing

end

function update(elapsed)


	--movimiento de flechas 
    if curStep >= 0 and curStep < 127 then
		local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
		end

		if curStep >= 127 and curStep < 158 then
			local currentBeat = (songPos / 1000)*(bpm/60)
			for i=0,7 do
				setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
				setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
			end
			end

			if curStep >= 158 and curStep < 190 then
				local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,7 do
					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
				end
				end

				if curStep >= 190 and curStep < 220 then
					local currentBeat = (songPos / 1000)*(bpm/60)
					for i=0,7 do
						setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
						setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
					end
					end

					if curStep >= 223 and curStep < 254 then
						local currentBeat = (songPos / 1000)*(bpm/60)
						for i=0,7 do
							setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
							setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
						end
						end

						if curStep >= 255 and curStep < 288 then
							local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,7 do
									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
								end
						end

						if curStep >= 288 and curStep < 319 then
							local currentBeat = (songPos / 1000)*(bpm/60)
							for i=0,7 do
								setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
								setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
							end
							end

							if curStep >= 320 and curStep < 351 then
								local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,7 do
									setActorX(_G['defaultStrum'..i..'X'] + 0 * math.sin((currentBeat + i*0) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 0 * math.cos((currentBeat + i*0) * math.pi), i)
								end
								end

								if curStep >= 320 and curStep < 383 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=0,7 do
										setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
										setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
									end
								end

									if curStep >= 384 and curStep < 511 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=0,7 do
											setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
										end
										end

										if curStep >= 511 and curStep < 640 then
											local currentBeat = (songPos / 1000)*(bpm/60)
											for i=0,7 do
												setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
												setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
											end
										end

											if curStep >= 640 and curStep < 767 then
												local currentBeat = (songPos / 1000)*(bpm/60)
												for i=0,7 do
													setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
													setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
												end
												end

												if curStep >= 767 and curStep < 831 then
													local currentBeat = (songPos / 1000)*(bpm/60)
													for i=0,7 do
														setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
														setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
													end
													end

													if curStep >= 831 and curStep < 895 then
														local currentBeat = (songPos / 1000)*(bpm/60)
															for i=0,7 do
																setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
															end
													end

													if curStep >= 895 and curStep < 1024 then
														local currentBeat = (songPos / 1000)*(bpm/60)
														for i=0,7 do
															setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
															setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
														end

					
													



end

function stepHit (step)

		--zooms
		if step == 155 then
			setCamZoom(1.2)
		end

		if step == 184 then
			setCamZoom(1.2)
		end

		if step == 640 then
			setCamZoom(1.2)
		end

		if step == 645 then
			setCamZoom(1.2)
		end

		if step == 650 then
			setCamZoom(1.2)
		end

		if step == 655 then
			setCamZoom(1.2)
		end

		if step == 660 then
			setCamZoom(1.2)
		end

		if step == 665 then
			setCamZoom(1.2)
		end

		if step == 670 then
			setCamZoom(1.2)
		end

		if step == 675 then
			setCamZoom(1.2)
		end

		if step == 680 then
			setCamZoom(1.2)
		end

		if step == 685 then
			setCamZoom(1.2)
		end

		if step == 690 then
			setCamZoom(1.2)
		end

		if step == 695 then
			setCamZoom(1.2)
		end

		if step == 700 then
			setCamZoom(1.2)
		end

		if step == 705 then
			setCamZoom(1.2)
		end

		if step == 710 then
			setCamZoom(1.2)
		end

		if step == 715 then
			setCamZoom(1.2)
		end

		if step == 720 then
			setCamZoom(1.2)
		end

		if step == 725 then
			setCamZoom(1.2)
		end

		if step == 730 then
			setCamZoom(1.2)
		end

		if step == 735 then
			setCamZoom(1.2)
		end

		if step == 740 then
			setCamZoom(1.2)
		end

		if step == 745 then
			setCamZoom(1.2)
		end

		if step == 750 then
			setCamZoom(1.2)
		end

		if step == 755 then
			setCamZoom(1.2)
		end

		if step == 757 then
			setCamZoom(1.2)
		end

		--hud

		if step == 1020 then
			camHudAngle = 8
		end

		if step == 1022 then
			camHudAngle = -8
		end

		if step == 1024 then
			camHudAngle = 0
		end
		
end

end