local DH = getgenv().DonumHub
if not DH then
    error("DonumHub namespace not found")
end

DH.Utils = DH.Utils or {}