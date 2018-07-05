
local cjson = cjson or require "cjson"

-- JSON result
local result = {["result"]="FAIL", ["plate"]="", ["message"]=""}

function recognizePlate(imgPath)
	local server = "172.17.0.1"
	local port = 31200
	local sock = ngx.socket.udp()
    local ok, err = sock:setpeername(server, port)
	if not ok then
		ngx.log(ngx.ERR, "Failed to connect to the server: ["..server..":"..port.."]")
		return false, "车牌识别服务不可用"
	end
	sock:settimeout(2000)

	-- Send the image path
	local ok,err = sock:send(imgPath)
	if not ok then
		ngx.log(ngx.ERR, "Failed to send the image path")
		sock:close()
		return false, "发送图片地址失败"
	end

	-- Receive the recoginzed plate number
	local resp, err = sock:receive(1024)

	-- close the socket
	sock:close()
	if not resp then
		ngx.log(ngx.ERR, "Failed to recieve the recoginzed result")
		return false, "接收车牌识别结果失败"
	end

	if resp == "FAIL" then
		return false, "车牌未识别"
	end

	ngx.log(ngx.INFO, "成功识别车牌:["..resp.."]")
	return true, resp
end

local imagePath = ngx.var.arg_imagePath
if imagePath == nil or imagePath == "" then
	ngx.log(ngx.ERR, "Missing param: [imagePath]")
	result["message"] = "图片参数缺失"
	ngx.say(cjson.encode(result))
	ngx.exit(ngx.HTTP_OK)
end


ngx.log(ngx.INFO, "imagePath: ["..imagePath.."]")

local ok, resp = recognizePlate(imagePath)
if ok then
	result["result"] = "OK"
	result["plate"] = resp
else
	result["message"] = resp
end

ngx.say(cjson.encode(result))
ngx.exit(ngx.HTTP_OK)
