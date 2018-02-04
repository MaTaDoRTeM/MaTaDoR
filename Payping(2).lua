local function run(msg, matches)
if matches[1]:lower() == "setnamepay" or matches[1]:lower() == "تنظیم نام درگاه" then
redis:set("setnamepayping",matches[2])
return "*نام درگاه پی پینگ ثبت شد :*\n"..matches[2]
end
if matches[1]:lower() == "setpay" or matches[1]:lower() == "تنظیم لینک پرداخت" then
redis:set("setpaypinglink",matches[2])
return "*لینک درگاه پی پینگ ثبت شد :*\n"..matches[2]
end


--[[if matches[1]:lower() == "pay" or "پرداخت" then
if tonumber(matches[2]) < 1000 or tonumber(matches[2]) > 900000 then
return "`خطا‼ مبلغ وارد شده باید`  *[1 تا 900]*  `هزار تومان باشد`"
end
    texth = "پرداخت مبلغ "..matches[2].." تومان به "..paypingname..""
local function payping(TM, MR)
      if MR.results_ and MR.results_[0] then
tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, MR.inline_query_id_, MR.results_[0].id_, dl_cb, nil)
    else
       text = "`Bold is offline`"
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "html")
   end
end
tdcli.getInlineQueryResults(107705060, msg.to.id, 0, 0, "[ "..texth.."](https://www.payping.ir/"..paypinglink.."/"..matches[2]..")", 0, payping, nil)
end
]]--

if matches[1]:lower() == "pay" or matches[1]:lower() == "پرداخت"  then
local paypingname = redis:get("setnamepayping")
local paypinglink = redis:get("setpaypinglink")
if tonumber(matches[2]) < 1000 then
return "`مبلغ وارد شده باید بیشتر از هزار تومن باشد.`"
end
if not paypingname then
return "*لطفا ابتدا نام اکانت پی پینگ خود را تنظیم کنید.*\n`مثال :`\n/setnamepayping mahdi mohseni"
end
if not paypinglink then
return "*لطفا ابتدا لینک اکانت پی پینگ خود را تنظیم کنید.*\n`مثال :`\n/setpaypinglink mahdiroo"
end
texth = "پرداخت مبلغ "..matches[2].." تومان به "..paypingname..""
local function payping(TM, MR)
      if MR.results_ and MR.results_[0] then
tdcli.sendInlineQueryResultMessage(msg.to.id, 0, 0, 1, MR.inline_query_id_, MR.results_[0].id_, dl_cb, nil)
    else
       text = "لطفا ابتدا با اکانت ربات @bold را استارت کنید"
  return tdcli.sendMessage(msg.to.id, msg.id, 0, text, 0, "html")
   end
end
tdcli.getInlineQueryResults(107705060, msg.to.id, 0, 0, "[ "..texth.."](https://www.payping.ir/"..paypinglink.."/"..matches[2]..")", 0, payping, nil)
end 
end

return {
patterns ={
"^[#!/]([Pp]ay) (%d+)$",
"^([Pp]ay) (%d+)$",
"^[#!/]([Ss]etnamepay) (.*)$",
"^([Ss]etnamepay) (.*)$",
"^[#!/]([Ss]etpay) (.*)$",
"^([Ss]etpay) (.*)$",
"^(پرداخت) (%d+)$",
"^(تنظیم پرداخت) (.*)$",
"^(تنظیم نام پرداخت) (.*)$",
},
run=run,
}
