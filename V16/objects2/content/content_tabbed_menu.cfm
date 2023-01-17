<cfparam name="is_content_summary" default="0">
<cfif isdefined('attributes.is_list_cid') and listlen(attributes.is_list_cid) neq 0>
	<cfquery name="get_content_" datasource="#DSN#">
		SELECT
			C.CONTENT_ID,
			C.CONT_HEAD
		FROM  
			CONTENT AS C, 
			CONTENT_CHAPTER AS CC,
			CONTENT_CAT CCAT
		WHERE 
			C.STAGE_ID = -2 AND	 
			C.CONTENT_STATUS = 1 AND
			C.CHAPTER_ID = CC.CHAPTER_ID AND 
			CCAT.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
			(
                <cfloop from="1" to="#listlen(attributes.is_list_cid)#" index="j">
                    C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_list_cid,j)#"> 
                    <cfif j neq listlen(attributes.is_list_cid)>OR</cfif>
                </cfloop>
			) AND
			<cfif isdefined("session.pp.company_category")>
				C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
				CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">)
			<cfelseif isdefined("session.ww.consumer_category")>
				C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
				CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
			<cfelseif isdefined("session.cp")>
				C.CAREER_VIEW = 1 AND
				CCAT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">)
			<cfelse>
				INTERNET_VIEW = 1
			</cfif>
		ORDER BY
			C.PRIORITY
	</cfquery>
	<table cellpadding="2" cellspacing="1" style="width:100%;">
		<tr>
			<td>
                <ul id="menu1" class="ajax_tab_menu">
                    <cfoutput query="get_content_">
                        <cfif currentrow eq 1>
                            <cfset birincil_ = content_id>
                        </cfif>
                        <li <cfif currentrow eq 1>class="selected"</cfif>id="content_link_#content_id#"><a onClick="content_detail_#this_row_id_#(#content_id#,content_link_#content_id#);">#cont_head#</a></link>
                    </cfoutput>
                </ul>
                <div id="table_icerik_<cfoutput>#this_row_id_#</cfoutput>" class="icerik" style="width:100%;height:100%;"></div>
			</td>
		</tr>
		<script type="text/javascript">
			<cfif isdefined("birincil_")>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_content_ajax&cid=#birincil_#&is_content_summary=#attributes.is_content_summary#</cfoutput>','table_icerik_<cfoutput>#this_row_id_#</cfoutput>',1);
			</cfif>
		</script>
	</table>	
	<script type="text/javascript">
		function content_detail_<cfoutput>#this_row_id_#</cfoutput>(id,content_link_)
		{
			var send_address = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_content_ajax&is_content_summary=#attributes.is_content_summary#&cid="+id+"</cfoutput>";
			AjaxPageLoad(send_address,'table_icerik_<cfoutput>#this_row_id_#</cfoutput>',0,'Yükleniyor',content_link_);
		}
	</script>
</cfif>

