<cfif not isdefined("session.ep.userid")>
	<script type="text/javascript">
		window.close();
	</script>
	<cfabort>
</cfif> 
<cfquery name="GET_WRK_APP_COUNT" datasource="#DSN#">
	SELECT COUNT(USERID) AS TOTAL,USER_TYPE FROM WRK_SESSION GROUP BY USER_TYPE
</cfquery>
<cfsavecontent variable="right">
	<cfoutput>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_current_events','list');"><img src="/images/time.gif" border="0" title="<cf_get_lang dictionary_id ='33730.Ajanda Olayları'>" align="absmiddle"></a>
		<cfif (get_module_user(38)) and len(fms_server_address) and (isdefined("flashComServerApplicationsPath")) and (len(flashComServerApplicationsPath))>
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_video_conferans','video_conference','popup_video_conferans');"><img src="/images/instmes.gif" border="0" title="<cf_get_lang dictionary_id='57426.Video Konferans'>" align="absmiddle"></a>
		</cfif>
	</cfoutput>
</cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32415.Online Kullanıcılar'></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right#">
	<cf_form_list>
		<thead>
			<tr>
				<th>
				<cfoutput>
                    <cfloop index = "LoopCount" from = "1" to = "#get_wrk_app_count.recordcount#"> 
                        <cfif get_wrk_app_count.user_type[LoopCount] eq 0>
                            <li style="display:inline; cursor:pointer;" id="link0" class="selected"><a style="padding: 1px ;" onClick="pageload(0,link0);"><cf_get_lang dictionary_id='57576.Çalışan'>: #get_wrk_app_count.total[LoopCount]#</a></li>
                        <cfelseif get_wrk_app_count.user_type[LoopCount] eq 1>
                            <li style="display:inline; cursor:pointer;" id="link1"><a style="padding: 1px ;" onClick="pageload(1,link1);"><cf_get_lang dictionary_id='32402.Kurumsal'>: #get_wrk_app_count.total[LoopCount]#</a></li>
                        <cfelseif get_wrk_app_count.user_type[LoopCount] eq 2>
                            <li style="display:inline; cursor:pointer;" id="link2"><a style="padding: 1px ;" onClick="pageload(2,link2);"><cf_get_lang dictionary_id='58079.İnternet'>: #get_wrk_app_count.total[LoopCount]#</a></li>
                        <cfelseif get_wrk_app_count.user_type[LoopCount] eq 3>
                            <li style="display:inline; cursor:pointer;" id="link3"><a style="padding: 1px ;" onClick="pageload(3,link3);"><cf_get_lang dictionary_id='58030.Kariyer'>: #get_wrk_app_count.total[LoopCount]#</a></li>
                        <cfelseif get_wrk_app_count.user_type[LoopCount] eq 5>
                            <li style="display:inline; cursor:pointer;" id="link5"><a style="padding: 1px ;" onClick="pageload(5,link5);"><cf_get_lang dictionary_id='32733.PDA'>: #get_wrk_app_count.total[LoopCount]#</a></li>
                    </cfif>
                    </cfloop>
                </cfoutput>
				</th>
			</tr>
		</thead>
	</cf_form_list>
	<div id="USERS" style="width:100%;z-index:9999; float:left;"></div>
</cf_popup_box>
<script type="text/javascript">
function pageload(page,_link_)
	{
	 <cfoutput>
		if(page==0)
			var url_str = "#request.self#?fuseaction=objects.banner_list&user_type=0"
		else if(page==1)
			var url_str = "#request.self#?fuseaction=objects.banner_list&user_type=1"
		else if(page==2)
			var url_str = "#request.self#?fuseaction=objects.banner_list&user_type=2"
		else if(page==3)
			var url_str = "#request.self#?fuseaction=objects.banner_list&user_type=3"
		else if(page==5)
			var url_str = "#request.self#?fuseaction=objects.banner_list&user_type=5"
		AjaxPageLoad(url_str,'USERS',1,'Yükleniyor',_link_);
	</cfoutput>
	}
pageload(0,link0);
</script>
