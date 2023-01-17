<cfif listlen(attributes.list_cat) neq 0>
	<cfquery name="GET_SPOT_CAT" datasource="#DSN#">
		SELECT
			CT.CONTENTCAT,
			CT.CONTENTCAT_ID
		FROM  
			CONTENT_CAT CT
		WHERE 
			CT.IS_RULE <> 1 AND
			(
                <cfloop from="1"  to="#listlen(attributes.list_cat)#" index="ccat">
                    CT.CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.list_cat,ccat)#"> 
                    <cfif ccat neq listlen(attributes.list_cat)>OR</cfif>
                </cfloop>
			) AND
			<cfif isdefined("session.pp.company_category")>
				CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">) AND
				CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#">
			<cfelseif isdefined("session.ww.consumer_category")>
				CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">) AND
				CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#">
			<cfelseif isdefined("session.cp")>
				CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.our_company_id#">) AND
				CT.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.cp.language#">	
			<cfelse>
				CT.CONTENTCAT_ID IN (SELECT CONTENTCAT_ID FROM CONTENT_CAT_COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">)
			</cfif>
	</cfquery>
	<table cellpadding="2" cellspacing="1" style="width:100%;">
		<tr>
			<td>
                <ul id="menu1" class="ajax_tab_menu">
                    <cfoutput query="get_spot_cat">
                        <cfif currentrow eq 1>
                            <cfset birincil_ = contentcat_id>
                        </cfif>
                        <li <cfif currentrow eq 1>class="selected"</cfif> id="content_link#currentrow#"><a onClick="content_spot(#contentcat_id#,content_link#currentrow#);">#contentcat#</a></link>
                    </cfoutput>
                </ul>
                <div id="table_icerik" class="icerik" style="width:100%;height:100%;"></div>
			</td>
		</tr>
		<script type="text/javascript">
			<cfif isdefined("birincil_")>
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_contentcat&cat_id=#birincil_#</cfoutput>','table_icerik',1);
			</cfif>
		</script>
	</table>	
	<script type="text/javascript">
		function content_spot(id,content_link_)
		{
			var send_address = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_contentcat&cat_id="+id+"</cfoutput>";
			AjaxPageLoad(send_address,'table_icerik',0,'Y�kleniyor',content_link_);
		}
	</script>
</cfif>

