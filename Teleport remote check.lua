local teleportRemote = game.ReplicatedStorage:FindFirstChild("TeleportToPrivateServer")
if teleportRemote then
    teleportRemote:FireServer("PlaceID_or_ServerCode")
end
