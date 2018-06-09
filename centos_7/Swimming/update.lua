GLOBAL_CONFIG.client_time = GLOBAL_CONFIG.client_time or NOW_TIME

function GetInnerPathRoot(path_list)
	local path_inner = nil
	for i = #path_list, 1, -1 do
		local path = path_list[i]
		local b1, e1 = string.find(path, 'data/', 0, true)
		if nil ~= b1 and e1 == string.len(path) then
			print("path find1 " .. path)
			path_inner = path
			break
		end

		local b2, e2 = string.find(path, 'scripts/', 0, true)
		if nil ~= b2 and e2 == string.len(path) then
			path_inner = string.sub(path, 1, b2 - 1)
			print("path find2 " .. path)
			break
		end
	end

	print("path inner " .. path_inner)
	return path_inner
end

function GetInnerPathList(path_list)
	local inner_list = {}
	for _,path in ipairs(path_list) do
		local b, e = string.find(path, '/', 1, true)
		if 1 ~= b then
			table.insert(inner_list, path)
		end
	end
	return inner_list
end

local check_update = {
	task_status = 0,
	FILE_TYPE_ZIP = 3,
}

function check_update:Name()
	return "check_update"
end

function check_update:Start()
	self:CleanOldAsset()

	local update_pkg = GLOBAL_CONFIG.param_list.switch_list.update_package
	local old_pkg_ver = string.gsub(GLOBAL_CONFIG.package_info.version or '', '%.', '')
	old_pkg_ver = tonumber(old_pkg_ver) or 0
	local new_pkg_ver = string.gsub(GLOBAL_CONFIG.version_info.package_info.version or '', '%.', '')
	new_pkg_ver = tonumber(new_pkg_ver) or 0

	if update_pkg and new_pkg_ver > old_pkg_ver then
		local msg = tostring(GLOBAL_CONFIG.version_info.package_info.msg) or  "版本过低，请下载安装最新安装包"
		local dialog_format = { cancelable = false, title = "版本更新", message = msg, positive = "下载", negative = "退出", }

		PlatformAdapter:OpenAlertDialog(dialog_format, LUA_CALLBACK(self, self.DialogCallback))
		self.task_status = MainLoader.TASK_STATUS_FINE
	else
		local version_text = cjson.encode(GLOBAL_CONFIG.version_info.assets_info) or ""
		UtilEx:writeText(UtilEx:getDataPath() .. "temp/version.txt", version_text)

		if GLOBAL_CONFIG.param_list.switch_list.update_assets then
			MainLoader:PushTask(require("scripts/preload/asset_update"))
		else
			MainLoader:PushTask(require("scripts/preload/load_script"))
		end

		self.task_status = MainLoader.TASK_STATUS_DONE
	end

	MainProber:Step(MainProber.STEP_TASK_CHECK_UPDATE_BEG, old_pkg_ver, new_pkg_ver, update_pkg)
end

function check_update:Update()
	return self.task_status
end

function check_update:Stop()
	self.task_status = -1
	
	MainProber:Step(MainProber.STEP_TASK_CHECK_UPDATE_END)
end

function check_update:DialogCallback(result)
	if "positive" == result then
		PlatformAdapter:OpenBrowser(GLOBAL_CONFIG.version_info.package_info.url)
	else
		AdapterToLua:endGame()
	end
end

function check_update:LoadTable(text)
	if nil == text then
		text = "{}"
	end

	local t = nil

	local f = loadstring("local t = " .. text .. " return t")
	if nil ~= f and "function" == type(f) then
		t = f()
	end
	if (nil == t or "table" ~= type(t)) then
		t = {}
	end

	return t 
end

function check_update:ExtractZipFile()
	local path_list = cc.FileUtils:getInstance():getSearchPaths()
	local inner_list = GetInnerPathList(path_list)
	local path_inner = GetInnerPathRoot(path_list)
	local path_outer = UtilEx:getDataPath() .. "main/data/"
	print("path_inner == " .. path_inner)

	cc.FileUtils:getInstance():setSearchPaths(inner_list)

	local list_text = UtilEx:readZipText("list.zip")

	local file_list = self:LoadTable(list_text)
	for k,v in pairs(file_list) do
		if self.FILE_TYPE_ZIP == v.t then
			local path = string.sub(k, 6)
			print("read zip == " .. path_inner .. path)
			local data = UtilEx:readZipText(path_inner .. path)
			print("text len == " .. string.len(data))
			if nil ~= data and "" ~= data then
				print("write text == " .. path_outer .. path)
				UtilEx:writeText(path_outer .. path, data)
			end
		end
	end

	cc.FileUtils:getInstance():setSearchPaths(path_list)
end

function check_update:CleanOldAsset()
	local saved_version = UtilEx:readText(UtilEx:getDataPath() .. "version.pkg")

	if tostring(saved_version) ~= tostring(GLOBAL_CONFIG.package_info.version) then
		UtilEx:removeFile(UtilEx:getDataPath() .. "main/")
		UtilEx:removeFile(UtilEx:getDataPath() .. "temp/")
		UtilEx:removeFile(UtilEx:getDataPath() .. "config.txt")

		self:ExtractZipFile()

		UtilEx:writeText(UtilEx:getDataPath() .. "version.pkg", tostring(GLOBAL_CONFIG.package_info.version))
	end
end

return check_update
