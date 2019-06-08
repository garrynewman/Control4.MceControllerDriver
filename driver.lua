C4:UpdateProperty( "State", "Unconnected" );
connected = false;
socket = nil

function Connect()

	if ( socket ~= nil ) then return end

	print( "Connecting to " .. Properties[ "Server Address" ] .. ":" .. Properties[ "Server Port" ] );
	C4:UpdateProperty( "State", "Connecting" );
	
    socket = C4:CreateTCPClient()
    socket:Option( "keepalive", true )
	socket:Option( "nodelay", true )
	socket:Option( "linger", true, 60 * 30 )

	socket:OnConnect(function(client)
		print("OnConnect")
		C4:UpdateProperty( "State", "Connected" );
	end)

	socket:OnDisconnect(function(client, errCode, errMsg)

		if (errCode ~= 0) then
			print( "Disconnected with error " .. errCode .. ": " .. errMsg)
		else
			print( "Disconnected and no response received")
		end

		C4:UpdateProperty( "State", "Disconnected" );
		socket = nil

	end)

	socket:OnError(function(client, errCode, errMsg)

		C4:UpdateProperty( "State", "Disconnected Error " .. errCode .. ": " .. errMsg );
		socket = nil

	end)

    
	socket:Connect( Properties[ "Server Address" ], Properties[ "Server Port" ] )
	
end

function OnDriverLateInit()

	Connect();

end


function ReceivedFromProxy(idBinding, strCommand, tParams)

    if ( idBinding == 5000 ) then 
    
	   Connect();
	   
	   if ( strCommand == "ENTER" ) then strCommand = "RETURN" end
	   if ( strCommand == "PVR" ) then strCommand = "F11" end
	   if ( strCommand == "CANCEL" ) then strCommand = "ESCAPE" end
	   if ( strCommand == "SCAN_REV" ) then strCommand = "Z" end
	   if ( strCommand == "SCAN_FWD" ) then strCommand = "X" end
    
	   socket:Write( "VK_" .. strCommand .. "\r" );
    end

end


function OnPropertyChanged(strProperty)

    if ( strProperty == "Server Address" ) then Connect() end
    if ( strProperty == "Server Port" ) then Connect() end

end

--
-- Refresh the connection every couple of minutes
-- (the socket seems to go into a zombie state after a while without this)
--
if ( killTimer ~= nil ) then killTimer:Cancel(); end

killTimer = C4:SetTimer( 1000 * 120, function(timer, skips)

	C4:UpdateProperty( "State", "Killed" );
	socket = nil
	Connect()

end, true )
