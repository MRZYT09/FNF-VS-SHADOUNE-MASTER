function start (song)
	setCamZoom(1)
	setHudZoom(2)

	--strumLine1Visible = false
	--strumLine2Visible = false
	
	end
	
	
	function update (elapsed)
				if curStep == 5 then
				setHudZoom(1)
			end
				if curStep == 100 then
				setHudZoom(2)
			end

		--	if curStep == 128 then
				--setHudZoom(2)
				--strumLine1Visible = true
				--strumLine2Visible = true
			--end
			--	if curStep == 120 then
				--strumLine1Visible = true
		--	end
			--	if curStep == 128 then
			--	strumLine2Visible = true
			--end

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
				setCamZoom(0.7)
			end
				if curStep == 1290 then
					setCamZoom(0.7)
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

		
	
			if curStep >= 128 and curStep < 190 then
				local currentBeat = (songPos / 1000)*(bpm/60)
				for i=0,5 do
					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
					setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
				end
			end

				
				if curStep >= 192 and curStep < 255 then
					local currentBeat = (songPos / 1000)*(bpm/60)
					for i=6,12 do
						setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
						setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
					end
				end

					if curStep >= 256 and curStep < 286 then
						local currentBeat = (songPos / 1000)*(bpm/60)
						for i=0,5 do
							setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
							setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
							tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
							tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
						end
					end

						
						if curStep >= 288 and curStep < 319 then
							local currentBeat = (songPos / 1000)*(bpm/60)
								for i=6,12 do
									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
									tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
									tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
								end
						end

							if curStep >= 320 and curStep < 352 then
								local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,5 do
									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
									setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
										tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
										tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
								end
							end

							if curStep >= 352 and curStep < 384 then
								local currentBeat = (songPos / 1000)*(bpm/60)
								for i=0,5 do
										setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
										setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
										tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
										tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
										
									end
								end

								if curStep >= 384 and curStep < 416 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=6,12 do
										setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
										setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
									end
								end
								
								if curStep >= 416 and curStep < 447 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=6,12 do
											setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
											
										end
									end

									if curStep >= 448 and curStep < 495 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=0,5 do
											setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
										end
										end

										if curStep >= 496 and curStep < 511 then
											local currentBeat = (songPos / 1000)*(bpm/60)
											for i=0,5 do
												setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
												setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
												tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
												tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
											end
											end

											
								if curStep >= 512 and curStep < 559 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=6,12 do
										setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
										setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
									end
								end
								
								if curStep >= 560 and curStep < 575 then
									local currentBeat = (songPos / 1000)*(bpm/60)
									for i=6,12 do
											setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
											
										end
									end

									if curStep >= 576 and curStep < 639 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=0,5 do
											setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
										end
									end

									if curStep >= 640 and curStep < 703 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=6,12 do
											setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
										end
									end

									if curStep >= 704 and curStep < 736 then
										local currentBeat = (songPos / 1000)*(bpm/60)
										for i=0,5 do
											setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
											setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
										end
										end

										if curStep >= 746 and curStep < 767 then
											local currentBeat = (songPos / 1000)*(bpm/60)
											for i=0,5 do
													setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
													setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
													tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
													tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
													
												end
											end

											if curStep >= 767 and curStep < 800 then
												local currentBeat = (songPos / 1000)*(bpm/60)
												for i=6,12 do
													setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
													setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
													tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
													tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
												end
												end
		
												if curStep >= 800 and curStep < 831 then
													local currentBeat = (songPos / 1000)*(bpm/60)
													for i=6,12 do
															setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
															setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
															tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
															tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
															
														end
													end

													if curStep >= 831 and curStep < 895 then
														local currentBeat = (songPos / 1000)*(bpm/60)
														for i=0,5 do
															setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
															setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
															tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
															tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
														end
														end

														if curStep >= 896 and curStep < 959 then
															local currentBeat = (songPos / 1000)*(bpm/60)
															for i=6,12 do
																setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
															end
															end

															if curStep >= 960 and curStep < 1023 then
																local currentBeat = (songPos / 1000)*(bpm/60)
																for i=0,5 do
																	setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																	setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																	tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																	tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																end
																end

																if curStep >= 1024 and curStep < 1087 then
																	local currentBeat = (songPos / 1000)*(bpm/60)
																	for i=6,12 do
																		setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
																		setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
																		tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																		tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																	end
																end

																
																	if curStep >= 1088 and curStep < 1151 then
																		local currentBeat = (songPos / 1000)*(bpm/60)
																		for i=0,5 do
																			setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																		tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																		tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																		end
																	end


																	if curStep >= 1152 and curStep < 1216 then
																		local currentBeat = (songPos / 1000)*(bpm/60)
																		for i=6,12 do
																			setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																			tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																			tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																		end
																	end

																	if curStep >= 1216 and curStep < 1279 then
																		local currentBeat = (songPos / 1000)*(bpm/60)
																		for i=0,5 do
																			setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																			setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																			tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																			tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																		end
																		end

																		if curStep >= 1280 and curStep < 1311 then
																			local currentBeat = (songPos / 1000)*(bpm/60)
																			for i=6,12 do
																				setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																				setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																			end
																			end

																			if curStep >= 1312 and curStep < 1343 then
																				local currentBeat = (songPos / 1000)*(bpm/60)
																				for i=0,5 do
																						setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																						setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																					end
																			end

																			
																			if curStep >= 1344 and curStep < 1375 then
																				local currentBeat = (songPos / 1000)*(bpm/60)
																				for i=6,12 do
																						setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																						setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																					end
																			end

																			if curStep >= 1376 and curStep < 1471 then
																				local currentBeat = (songPos / 1000)*(bpm/60)
																				for i=0,5 do
																					setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																					setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																				end
																			end

																			if curStep >= 1391 and curStep < 1535 then
																				local currentBeat = (songPos / 1000)*(bpm/60)
																				for i=6,12 do
																					setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																					setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																				end
																			end

																			if curStep >= 1536 and curStep < 1599 then
																				local currentBeat = (songPos / 1000)*(bpm/60)
																				for i=0,5 do
																						setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																						setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																						
																					end
																				end

																				if curStep >= 1536 and curStep < 1599 then
																					local currentBeat = (songPos / 1000)*(bpm/60)
																					for i=6,12 do
																							setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																							setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																							tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																							tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																							
																						end
																					end

																					
																						if curStep >= 1600 and curStep < 1791 then
																							local currentBeat = (songPos / 1000)*(bpm/60)
																							for i=0,5 do
																								setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																								setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																									tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																									tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																							end
																						end
																							

																								if curStep >= 1664 and curStep < 1791 then
																								local currentBeat = (songPos / 1000)*(bpm/60)
																								for i=6,12 do
																									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																									setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																										tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																										tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																								end
																							end

																							if curStep >= 1792 and curStep < 1984 then
																								local currentBeat = (songPos / 1000)*(bpm/60)
																								for i=0,5 do
																									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																									setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																									tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																									tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																								end
																								end
																								
																								if curStep >= 1824 and curStep < 1984 then
																									local currentBeat = (songPos / 1000)*(bpm/60)
																									for i=6,12 do
																										setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																										setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																										tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																										tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																									end
																									end

																									if curStep >= 1984 and curStep < 2111 then
																										local currentBeat = (songPos / 1000)*(bpm/60)
																										for i=0,5 do
																											setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
																											setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
																											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																										end
																										end

																										if curStep >= 2048 and curStep < 2111 then
																											local currentBeat = (songPos / 1000)*(bpm/60)
																											for i=6,12 do
																												setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
																												setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
																												tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																												tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																											end
																											end

																											if curStep >= 2112 and curStep < 2252 then
																												local currentBeat = (songPos / 1000)*(bpm/60)
																												for i=0,5 do
																													setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																													setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																													tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																													tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																												end
																											end
																												if curStep >= 2176 and curStep < 2252 then
																													local currentBeat = (songPos / 1000)*(bpm/60)
																													for i=6,12 do
																														setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																														setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																														tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																														tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																													end
																												end

																												if curStep >= 2254 and curStep < 2271 then
																													local currentBeat = (songPos / 1000)*(bpm/60)
																													for i=0,5 do
																															setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																															setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																															tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																															tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																															
																														end
																													end

																													if curStep >= 2272 and curStep < 2303 then
																														local currentBeat = (songPos / 1000)*(bpm/60)
																														for i=6,12 do
																																setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																
																															end
																														end

																														if curStep >= 2304 and curStep < 2431 then
																															local currentBeat = (songPos / 1000)*(bpm/60)
																															for i=0,5 do
																																setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																																	tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																	tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																															end
																															end

																															if curStep >= 2368 and curStep < 2431 then
																																local currentBeat = (songPos / 1000)*(bpm/60)
																																for i=6,12 do
																																	setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																	setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																																		tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																		tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																end
																																end

																																if curStep >= 2432 and curStep < 2559 then
																																	local currentBeat = (songPos / 1000)*(bpm/60)
																																	for i=0,5 do
																																		setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																		setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																		tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																		tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																	end
																																	end

																																	if curStep >= 2496 and curStep < 2559 then
																																		local currentBeat = (songPos / 1000)*(bpm/60)
																																		for i=6,12 do
																																			setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																			setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																			tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																			tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																		end
																																		end

																																		if curStep >= 2560 and curStep < 2623 then
																																			local currentBeat = (songPos / 1000)*(bpm/60)
																																			for i=0,5 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																		end

																																		if curStep >= 2624 and curStep < 2687 then
																																			local currentBeat = (songPos / 1000)*(bpm/60)
																																			for i=6,12 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																		end

																																		if curStep >= 2688 and curStep < 2815 then
																																			local currentBeat = (songPos / 1000)*(bpm/60)
																																			for i=0,5 do
																																				setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																				setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																				tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																				tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																			end
																																			end

																																			if curStep >= 2752 and curStep < 2815 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=6,12 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																				end

																																			if curStep >= 2816 and curStep < 2943 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=0,5 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																			end

																																			if curStep >= 2880 and curStep < 2943 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=6,12 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																			end

																																			if curStep >= 2944 and curStep < 3199 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=0,5 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																			end

																																			if curStep >= 3008 and curStep < 3199 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=6,12 do
																																					setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																					setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
																																					tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																					tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																				end
																																			end

																																			if curStep >= 3200 and curStep < 3390 then
																																				local currentBeat = (songPos / 1000)*(bpm/60)
																																				for i=0,5 do
																																						setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																						setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																						tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																						tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																						
																																					end
																																				end

																																				if curStep >= 3264 and curStep < 3390 then
																																					local currentBeat = (songPos / 1000)*(bpm/60)
																																					for i=6,12 do
																																							setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																							setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																							tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																							tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																							
																																						end
																																					end

																																					if curStep >= 3392 and curStep < 3455 then
																																						local currentBeat = (songPos / 1000)*(bpm/30)
																																						for i=0,5 do
																																								setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																								setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																								tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																								tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																								
																																							end
																																						end
		
																																						if curStep >= 3392 and curStep < 3455 then
																																							local currentBeat = (songPos / 1000)*(bpm/30)
																																							for i=6,12 do
																																									setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																									setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																									tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																									tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																									
																																								end
																																							end

																																							if curStep >= 3456 and curStep < 3679 then
																																								local currentBeat = (songPos / 1000)*(bpm/60)
																																								for i=0,5 do
																																									setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																									setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																									tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																									tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																								end
																																								end

																																								if curStep >= 3520 and curStep < 3679 then
																																									local currentBeat = (songPos / 1000)*(bpm/60)
																																									for i=6,12 do
																																										setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																										setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																										tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																										tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																									end
																																									end

																																									if curStep >= 3700 and curStep < 3775 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=0,5 do
																																												setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																												setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																																												tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																												tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																											end
																																									end

																																									if curStep >= 3712 and curStep < 3775 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																											for i=6,12 do
																																												setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																												setActorY(_G['defaultStrum'..i..'Y'] + 8 * math.cos((currentBeat + i*0) * math.pi), i)
																																												tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																												tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																											end
																																									end

																																									if curStep >= 3776 and curStep < 3967 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=0,5 do
																																											setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																											setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																										end
																																									end

																																									if curStep >= 3840 and curStep < 3967 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=6,12 do
																																											setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*2) * math.pi), i)
																																											setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.75) * math.pi), i)
																																											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																										end
																																									end

																																									if curStep >= 3968 and curStep < 4095 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=0,5 do
																																											setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
																																											setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
																																											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																										end
																																									end

																																									if curStep >= 4032 and curStep < 4095 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=6,12 do
																																											setActorX(_G['defaultStrum'..i..'X'] + 8 * math.sin((currentBeat + i*0) * math.pi), i)
																																											setActorY(_G['defaultStrum'..i..'Y'] + 50 * math.cos((currentBeat + i*2) * math.pi), i)
																																											tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																											tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																										end
																																									end

																																									if curStep >= 4096 and curStep < 4607 then
																																										local currentBeat = (songPos / 1000)*(bpm/60)
																																										for i=0,5 do
																																												setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																												setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																												tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																												tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																												
																																											end
																																										end

																																										if curStep >= 4160 and curStep < 4367 then
																																											local currentBeat = (songPos / 1000)*(bpm/60)
																																											for i=6,12 do
																																													setActorX(_G['defaultStrum'..i..'X'] + 41 * math.sin((currentBeat + i*0.40) * math.pi), i)
																																													setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.40) * math.pi), i)
																																													tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																													tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																													
																																												end
																																											end

																																											
																																												if curStep >= 4368 and curStep < 4560 then
																																													local currentBeat = (songPos / 1000)*(bpm/60)
																																													for i=6,12 do
																																														setActorX(_G['defaultStrum'..i..'X'] + 20 * math.sin((currentBeat + i*0) * math.pi), i)
																																														setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.50) * math.pi), i)
																																														tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
																																														tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
																																													end
																																												end




	end

	