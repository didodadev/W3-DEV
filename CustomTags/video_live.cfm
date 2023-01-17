<cfprocessingdirective suppresswhitespace="yes"><cfsetting enablecfoutputonly="yes">
<!---
usage : 
	<cf_video_live id="#some_userid#" zone="ep" info_text="İzle">
Parameters:
	id: videosu izlenecek kisi
	zone: pp or ep or ww (bakilacak kisinin portali)
	info_text: ikonun yanında gözükecek text
Modifications:
	
--->
<cfif isdefined("attributes.id") and isnumeric(attributes.id) and isdefined('attributes.zone')>
	<cfquery name="GET_VIDEO_LIVE" datasource="#CALLER.DSN#">
		SELECT
			USERID,
            USERNAME,
            IS_VIDEO_LIVE
		FROM
			WRK_SESSION
		WHERE
        	USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
		<cfif attributes.zone is "ep">
			USER_TYPE = 0
		<cfelseif attributes.zone is "pp">
			USER_TYPE = 1
		<cfelseif attributes.zone is "ww">
			USER_TYPE = 2
		</cfif>
	</cfquery>
</cfif>
<cfif get_video_live.is_video_live eq true>
	<cfoutput>
    <a href="#request.self#.cfm?fuseaction=objects2.detail_live_video&stream_name=#get_video_live.username#','','resizable=yes,scrollbars=yes,width=350,height=350,left=150,top=150');"><img border="0" src="/images/myportal/icon_live.gif" />&nbsp;#attributes.info_text#</a>
	</cfoutput>
</cfif>
<cfsetting enablecfoutputonly="no"></cfprocessingdirective>
