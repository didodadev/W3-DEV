<cfset replyCFC = CreateObject("component","V16.forum.cfc.reply").init(dsn = application.systemParam.systemParam().dsn)>
<cfset reply = replyCFC.select(replyid:attributes.replyid)>