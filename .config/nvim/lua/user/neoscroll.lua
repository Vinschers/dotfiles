local status_ok, neoscroll = pcall(require, "neoscroll")
if not status_ok or type(neoscroll) == "boolean" then
	return
end

neoscroll.setup()
