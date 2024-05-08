-- Controller
module("luci.controller.socat_redirect", package.seeall)

function index()
	entry({"admin", "services", "socat_redirect"}, cbi("socat_redirect"), _("Socat Redirect"), 60)
end
d