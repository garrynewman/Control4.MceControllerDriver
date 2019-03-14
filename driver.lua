
C4:UpdateProperty( "State", "Unconnected" );

local socket = C4:CreateTCPClient()
socket:Option( "keepalive", true )
socket:Option( "nodelay", true )

socket:OnDisconnect( function()

    print( "Server Disconnected" );
    C4:UpdateProperty( "State", "Disconnected" );
    Connect();

end )

socket:OnConnect( function()

    print( "Connnected to server" );
    C4:UpdateProperty( "State", "Connected" );

end )

function Connect()
    socket:Connect( Properties[ "Server Address" ], Properties[ "Server Port" ] )
end

Connect();

function ReceivedFromProxy(idBinding, strCommand, tParams)

    if ( idBinding == 5000 ) then 
    
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
