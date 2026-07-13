local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")


local FIREBASE_URL =
"https://moderationpanel-86889-default-rtdb.firebaseio.com"



local CHECK_INTERVAL = 10



local function getCommands()

	local success, response = pcall(function()

		return HttpService:GetAsync(
			FIREBASE_URL .. "/commands.json"
		)

	end)


	if success then

		return HttpService:JSONDecode(response)

	end


	return nil

end





local function completeCommand(id)

	pcall(function()

		HttpService:PostAsync(

			FIREBASE_URL ..
			"/commands/" ..
			id ..
			"/completed.json",

			"true",

			Enum.HttpContentType.ApplicationJson

		)

	end)

end






local function findPlayer(target)


	-- Try username

	local player =
	Players:FindFirstChild(target)


	if player then
		return player
	end



	-- Try UserId

	local id =
	tonumber(target)



	if id then

		for _,player in pairs(Players:GetPlayers()) do

			if player.UserId == id then

				return player

			end

		end

	end


	return nil

end







while true do


	local commands =
	getCommands()



	if commands then


		for id,command in pairs(commands) do



			if command.completed ~= true then



				local player =
				findPlayer(command.target)



				if player then



					if command.action == "kick" then


						player:Kick(
							"Removed by moderator: "
							..
							command.reason
						)



					elseif command.action == "ban" then



						player:Kick(

							"You are banned.\nReason: "
							..
							command.reason

						)



					end



				end




				completeCommand(id)



			end


		end


	end



	task.wait(CHECK_INTERVAL)

end
