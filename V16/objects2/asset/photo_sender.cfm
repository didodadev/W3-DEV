<cf_box title="Gönderen">
	<cfif not isdefined("get_user")>
		<cfset cmp=createObject("component","objects2.asset.query.UserData").init(dsn) />
		<cfset get_user=cmp.GetUserData(usertype,userid) />
	</cfif>
	
	<form name="pop_gonder_video_info" action="" method="post"><!--- index.cfm?fuseaction=myportal.profile --->
	  <input type="hidden" name="profile_id" id="profile_id" value=""/>
	</form>
	<table border="0">
		<tr>
			<td width="58" valign="top"><cfif len(get_user.Photo)><cf_get_server_file output_file="member/consumer/#Get_user.Photo#" output_server="#Get_user.PhotoServerId#" output_type="0" image_width="60" image_height="60" alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#"></cfif></td>
			<td width="332" valign="top">
				<cf_get_lang no='166.Gönderen'>: <cfoutput><cfif usertype eq "consumer"><a href="javascript:;" onclick="forms['pop_gonder_video_info'].elements['profile_id'].value=#GET_USER.UserId#;forms['pop_gonder_video_info'].submit();"></cfif>#Get_user.Name#<cfif usertype eq "consumer"></a></cfif></cfoutput><br/>
				<cf_get_lang_main no='674.Üyelik'>: <cfoutput>#dateFormat(get_user.RecordDate,"dd.mm.yyyy")#</cfoutput><br/>
				<cfif not isdefined("photoData")>
					<cfset photoData=createObject("component","objects2.asset.query.AssetData").init(dsn,1) />
				</cfif>
				<cfset foto_count = photoData.GetAssetCount(Get_user.UserType,Get_user.UserId) />
				<cf_get_lang no='173.Fotolar'>: <cfoutput>#foto_count#</cfoutput><br/>
			</td>
		</tr>
	</table>
</cf_box>

