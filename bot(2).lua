+tdcli = dofile('./tg/tdcli.lua')
+serpent = (loadfile "./libs/serpent.lua")()
+feedparser = (loadfile "./libs/feedparser.lua")()
+require('./bot/utils')
+URL = require "socket.url"
+http = require "socket.http"
+https = require "ssl.https"
+ltn12 = require "ltn12"
+json = (loadfile "./libs/JSON.lua")()
+mimetype = (loadfile "./libs/mimetype.lua")()
+redis = (loadfile "./libs/redis.lua")()
+JSON = (loadfile "./libs/dkjson.lua")()
+local lgi = require ('lgi')
+local notify = lgi.require('Notify')
+notify.init ("Telegram updates")
+chats = {}
+helper_id = 418516842 --Put Your Helper Bot ID Here
+
+function do_notify (user, msg)
+	local n = notify.Notification.new(user, msg)+	n:show ()
+end
+
+function dl_cb (arg, data)
+	-- vardump(data)
+end
+function vardump(value)
+	print(serpent.block(value, {comment=false}))
+end
+function load_data(filename)
+	local f = io.open(filename)
+	if not f then
+		return {}
+	end
+	local s = f:read('*all')
+	f:close()
+	local data = JSON.decode(s)
+	return data
+end
+
+function save_data(filename, data)
+	local s = JSON.encode(data)
+	local f = io.open(filename, 'w')
+	f:write(s)
+	f:close()
+end
+
+function match_plugins(msg)
+	for name, plugin in pairs(plugins) do
+		match_plugin(plugin, name, msg)
+	end
+end
+
+-- Apply plugin.pre_process function
+function pre_process_msg(msg)
+  for name,plugin in pairs(plugins) do
+    if plugin.pre_process and msg then
+      print('Preprocess', name)
+      result = plugin.pre_process(msg)
+    end
+  end
+   return result
+end
+
+function save_config( )
+	serialize_to_file(_config, './data/config.lua')
+	print ('saved config into ./data/config.lua')
+end
+
+function whoami()
+	local usr = io.popen("whoami"):read('*a')
+	usr = string.gsub(usr, '^%s+', '')
+	usr = string.gsub(usr, '%s+$', '')
+	usr = string.gsub(usr, '[\n\r]+', ' ') 
+	if usr:match("^root$") then
+		tcpath = '/root/.telegram-cli'
+	elseif not usr:match("^root$") then
+		tcpath = '/home/'..usr..'/.telegram-cli'
+	end
+  print('>> Download Path = '..tcpath)
+end
+
+function create_config( )
+  -- A simple config with basic plugins and ourselves as privileged user
+	config = {
+    enabled_plugins = {
+    "BanHammer",
+    "Fun",	
+    "GroupManager",
+    "Msg-Checks",	
+    "Plugins",
+    "Tools",
+    "Write"
+	},
+    sudo_users = {377450049,418516842,284298227},
+    admins = {},
+    disabled_channels = {},
+    moderation = {data = './data/moderation.json'},
+    info_text = [[
+ 》TiGeR BoT v5.7
+An advanced administration bot based on https://valtman.name/telegram-cli
+
+》https://github.com/BeyondTeam/BDReborn 
+
+》Admins :
+》@Arashsudo ➣ Founder & Developer《
+》@JavadSudo ➣ Developer《
+》@Shaniloop ➣ Developer《
+
+》Special thanks to :
+》TiGeRTeM
+》@Xamarin_Devloper
+
+》Our channel :
+》@TiGeRTem《
+]],
+  }
+ serialize_to_file(config, './data/config.lua')
+ print ('saved config into conf.lua')
+end
+
+-- Returns the config from config.lua file.
+-- If file doesn't exist, create it.
+function load_config( )
+ local f = io.open('./data/config.lua', "r")
+  -- If config.lua doesn't exist
+ if not f then
+  print ("Created new config file: ./data/config.lua")
+  create_config()
+ else
+  f:close()
+ end
+ local config = loadfile ("./data/config.lua")()
+ for v,user in pairs(config.sudo_users) do
+  print("Allowed user: " .. user)
+ end
+ return config
+end
+whoami()
+plugins = {}
+_config = load_config()
+
+function load_plugins()
+ local config = loadfile ("./data/config.lua")()
+ for k, v in pairs(config.enabled_plugins) do
+  print("Loading Plugins", v)
+  local ok, err =  pcall(function()
+  local t = loadfile("plugins/"..v..'.lua')()
+  plugins[v] = t
+  end)
