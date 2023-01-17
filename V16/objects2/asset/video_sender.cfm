<cf_box title="Gönderen">
<cfif not isdefined("get_user")>
	<cfif not isdefined("userData")>
		<cfset userData=createObject("component","objects2.asset.query.UserData").init(dsn) />
    </cfif>
    <cfset get_user=userData.GetUserData(usertype,userid) />
</cfif>
<table border="0">
	<tr>
		<td width="58" valign="top"><cfif len(get_user.Photo)><cf_get_server_file output_file="member/consumer/#get_user.Photo#" output_server="#get_user.PhotoServerId#" output_type="0" image_width="60" image_height="60" alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#"></cfif></td>
        <td width="332" valign="top">
            <cf_get_lang no='166.Gönderen'>: <cfoutput>#get_user.Name#</cfoutput><br/>
            <cf_get_lang_main no='674.Üyelik'>: <cfoutput>#dateFormat(get_user.RecordDate,"dd.mm.yyyy")#</cfoutput><br/>
            <cfif not isDefined("videoData")>
                <cfset videoData=createObject("component","objects2.asset.query.AssetData").init(dsn,2) />
            </cfif>
            <cfset video_count = videoData.GetAssetCount(get_user.UserType,get_user.UserId) />
            <cf_get_lang no='167.Videolar'>: <cfoutput>#video_count#</cfoutput><br/>
        </td>
	</tr>
</table>
</cf_box>

