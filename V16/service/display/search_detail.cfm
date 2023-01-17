<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		MODULE_ID,
		MODULE_SHORT_NAME,
		MODULE_NAME_TR
	FROM 
		MODULES
	ORDER BY MODULE_ID ASC
</cfquery>
<cfset modul_list = valuelist(get_modules.module_short_name)>
	<cfquery name="LIST_HELP" datasource="#DSN#">
		SELECT 
			HELP_CIRCUIT,
			HELP_ID,
			HELP_HEAD,
			HELP_TOPIC
		FROM 
			HELP_DESK
		WHERE 
			HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.help_id#">
	</cfquery>
	<cfquery name="GET_HELP" datasource="#DSN#">
		SELECT 
			HELP_ID,
			HELP_HEAD
		FROM
			HELP_DESK
		WHERE
			IS_INTERNET = 1 AND	
			HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#list_help.help_circuit#%">
			<cfif len(attributes.module_id)>
				AND	HELP_CIRCUIT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(modul_list,attributes.module_id)#%">
			</cfif>
			AND #LIST_HELP.HELP_ID# <> HELP_ID
		ORDER BY 
			HELP_HEAD
	</cfquery>
	<!-- sil -->
<br/>
<table border="0" cellpadding="2" cellspacing="1" class="color-border" style="width:98%">
   	<tr class="color-row">
		<td>
			<!-- sil -->
			<table style="width:98%; text-align:center">
				<tr class="color-list" style="height:35px;">
					<td class="headbold"><img src="/images/amblem_small.gif" align="absmiddle" title="<cf_get_lang no='638.Workcube Online Yardım'>"><cf_get_lang no='638.Workcube Online Yardım'></td>
					<td align="right" style="text-align:right;">
						<table>
							<cfform name="online_help" action="#request.self#?fuseaction=objects.popup_online_help">
								<tr>
									<td><cf_get_lang_main no='48.Filtre'></td>
									<td>
									<input type="text" name="search_key" id="search_key" style="width:150px;" value="<cfoutput>#attributes.search_key#</cfoutput>">
									<select name="module_id" id="module_id" style="width:150px;">
									<option value=""><cf_get_lang no ='1470.Tüm Modüller'></option>
									<cfoutput query="GET_MODULES">
									<option value="#MODULE_ID#"<cfif attributes.module_id eq module_id>selected</cfif>>#MODULE_NAME_TR#</option>
									</cfoutput>	
									</select>
									<input type="text" name="maxrows" id="maxrows" style="width:25px;" value="<cfoutput>#attributes.maxrows#</cfoutput>">
									</td>
									<td>
									<input type="image" src="/images/ara_blue.gif">
									</td>
									<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
									<td>
									<a href="javascript://" onClick="history.back(-1)"><img src="/images/back.gif" align="absmiddle" title="<cf_get_lang_main no='20.Geri'>" border="0"></a>
									</td>
								</tr>
							</cfform>
						</table>
					</td>
				</tr>
			</table>
			<!-- sil -->
			<table width="98%" align="center">
				<tr>
				<td colspan="2" height="30" class="formbold"><cf_get_lang no='39.Konu'>: <font color="#FF0000"><cfoutput>#LIST_HELP.HELP_HEAD#</cfoutput></font></td>
				</tr>
				<tr>
					<td><cfoutput>#LIST_HELP.HELP_TOPIC#</cfoutput></td>
				</tr>	
			</table>
			<table width="98%" align="center" cellpadding="2" cellspacing="2">
				<tr class="color-list" height="30">
			<td class="formbold" colspan="2"><cf_get_lang no='640.İlişkili Konular'></td>
			</tr>
			<cfoutput query="GET_HELP">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="20">#currentrow#</td>
				<td><a href="#request.self#?fuseaction=objects.popup_search_detail&help_id=#HELP_ID#&search_key=#attributes.search_key#&module_id=#attributes.module_id#" class="tableyazi">#HELP_HEAD#</a></td>	
			</tr>	
				</cfoutput>
			</table>
		</td>
   	</tr>
</table>   		
<!-- sil -->
