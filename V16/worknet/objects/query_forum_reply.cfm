<cfsetting showdebugoutput="no">
<!--- add topic reply --->
<cfset cmp = createObject("component","worknet.objects.forums") />
<cfset cmp.addTopicReply(topicid:attributes.topicid,reply_area:attributes.reply_area) />
<cfabort>

