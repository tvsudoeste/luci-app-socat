local nixio = require "nixio"
local luci = require "luci"
local sys = require "luci.sys"
local Map = require "luci.model.map"
local NamedSection = require "luci.model.sections".NamedSection
local translate = luci.i18n.translate

local try_devices = nixio.fs.glob("/dev/tty[A-Z]*[0-9]")
local m = Map("socat", translate("Socat Configuration"), translate("Configuration panel for socat."))
local s = m:section(NamedSection, 'http', "socat", translate("Serial Port and Network Settings"))
s.anonymous = true

function m.on_commit(map)
    sys.call("/etc/init.d/socat restart")
end

-- Opção para selecionar a porta serial
local dev = s:option(Value, "serialport", translate("Serial Port"))
if try_devices then
	for node in try_devices do
		dev:value(node, node)
	end
end

-- Opção para definir a taxa de transmissão
local baud = s:option(ListValue, "baudrate", translate("Baud Rate"))
baud:value("9600", "9600")
baud:value("19200", "19200")
baud:value("38400", "38400")
baud:value("57600", "57600")
baud:value("115200", "115200")
baud:value("230400", "230400")
baud:value("460800", "460800")
baud:value("921600", "921600")
baud.default = "9600"

-- Opção para definir os bits de dados
local databits = s:option(ListValue, "databits", translate("Data Bits"))
databits:value("5", "5")
databits:value("6", "6")
databits:value("7", "7")
databits:value("8", "8")
databits.default = "8"

-- Opção para definir a paridade
local parity = s:option(ListValue, "parity", translate("Parity"))
parity:value("none", translate("None"))
parity:value("even", translate("Even"))
parity:value("odd", translate("Odd"))
parity.default = "none"

-- Opção para definir os bits de parada
local stopbits = s:option(ListValue, "stopbits", translate("Stop Bits"))
stopbits:value("1", "1")
stopbits:value("2", "2")
stopbits.default = "1"

-- Opção para controle de fluxo
local flowcontrol = s:option(ListValue, "flowcontrol", translate("Flow Control"))
flowcontrol:value("none", translate("None"))
flowcontrol:value("hardware", translate("Hardware (RTS/CTS)"))
flowcontrol:value("software", translate("Software (XON/XOFF)"))
flowcontrol.default = "none"

-- Opção para especificar a porta de rede
local netport = s:option(Value, "networkport", translate("Network Port"))
netport.datatype = "port"
netport.default = "8000"

-- Opção booleana para ativar/desativar a configuração
local enable = s:option(Flag, "enable", translate("Enable"), translate("Activate or deactivate the configuration"))
enable.default = "1"

return m
