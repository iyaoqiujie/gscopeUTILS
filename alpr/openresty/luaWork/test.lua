
ngx.say("This is a response from docker openresty")

    local sock = ngx.socket.udp()
    local ok, err = sock:setpeername("172.17.0.1", 31200)
sock:settimeout(2000)
local ok,err = sock:send("/opt/CPR/alpr/sandbox/testIMGs/1.jpg")
local resp, err = sock:receive(1024)
ngx.say(resp)
ngx.exit(ngx.HTTP_OK)
