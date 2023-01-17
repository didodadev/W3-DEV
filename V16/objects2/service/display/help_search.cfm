<cfparam name="attributes.search_key" default="">
<cfparam name="attributes.isfaq" default="">
<cfparam name="attributes.module_id" default="">
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT 
		*
	FROM 
		MODULES
	ORDER BY 
		MODULE_ID ASC
</cfquery>
<cfset modul_list = valuelist(GET_MODULES.MODULE_SHORT_NAME)>
<cfquery name="GET_HELP" datasource="#DSN#">
	SELECT 
		*
	FROM
		HELP_DESK
	WHERE
		IS_INTERNET = 1 AND
	<cfif isdefined('attributes.isfaq') and attributes.isfaq eq 1>
		IS_FAQ = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.isfaq#"> AND
	</cfif>
	(HELP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_key#%"> OR HELP_TOPIC LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.search_key#%">) 
	<cfif len(attributes.module_id)>
		AND	HELP_CIRCUIT LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(modul_list,attributes.module_id)#%">
	</cfif>
	ORDER BY 
		HELP_HEAD
</cfquery>
<cfset url_str = "">
<cfif len(attributes.search_key)>
	<cfset url_str = "#url_str#&search_key=#attributes.search_key#">
</cfif>
<cfif len(attributes.module_id)>
	<cfset url_str = "#url_str#&module_id=#attributes.module_id#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_help.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<br/>
<table width="98%" align="center" border="0" cellpadding="2" cellspacing="1" class="color-border">
  <tr class="color-row">
	<td>
		<table width="98%" align="center">
			<tr class="color-list" height="30">
				<td class="headbold" height="25"><cf_get_lang_main no='676.Workcube Arama Sonuçları'></td>
			</tr>
		</table>
		<table width="98%" align="center" cellpadding="4" cellspacing="4">
		<cfform name="online_help" action="#request.self#?fuseaction=objects.popup_online_help">
			<tr valign="top">
				<td class="formbold"><cf_get_lang no='647.Aradığınız kelimeyi veya modülü giriniz'>.</td>
			</tr>
			<tr valign="top">
				<td>
					<input type="text" name="search_key" id="search_key" style="width:150px;" value="<cfoutput>#attributes.search_key#</cfoutput>">
					<select name="module_id" id="module_id" style="width:150px;">
						<option value=""><cf_get_lang no ='1470.Tüm Modüller'></option>
						<cfoutput query="GET_MODULES">
							<option value="#MODULE_ID#"<cfif attributes.module_id eq module_id>selected</cfif>>#MODULE_NAME_TR#</option>
						</cfoutput>	
					</select>
					<input type="checkbox" value="1" name="isfaq" id="isfaq" <cfif attributes.isfaq eq 1>checked</cfif>>
					<cfif attributes.totalrecords gt 0 >
					<input type="text" name="maxrows" id="maxrows" style="width:25px;" value="<cfoutput>#attributes.maxrows#</cfoutput>">
					</cfif>
					<input type="submit" value="<cf_get_lang_main no='153.ARA'>">
				</td>
			</tr>
		</table>
		<table width="98%" align="center" cellpadding="2" cellspacing="1">
			<tr class="color-list" height="20">
				<td class="headbold" width="520"><cf_get_lang_main no='723.Sonuçlar'>:&nbsp;<cfif attributes.totalrecords eq 0><font color="#FF0000" size="1"><cf_get_lang_main no='524.Aradığınız kriterlere uyan sonuç bulunamamıştır'>.!!</font></cfif></td>
			</tr>
		</table>
		<table width="98%" align="center" cellpadding="3" cellspacing="3">
			<cfoutput query="GET_HELP" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="5">#currentrow#</td>			
				<td><img src="../../../images/notkalem.gif" border="0" align="absmiddle"><a href="#request.self#?fuseaction=objects.popup_search_detail&help_id=#HELP_ID#&search_key=#attributes.search_key#&module_id=#attributes.module_id#" class="tableyazi">#HELP_HEAD#</a></td>
			</tr>
			</cfoutput>
		</table>
		</cfform>
			<cfif attributes.totalrecords gt attributes.maxrows>
			  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="10">
				<tr class="color-list">
				  <td><cf_pages page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#attributes.totalrecords#" 
							startrow="#attributes.startrow#" 
							adres="objects.popup_online_help#url_str#"></td>
				  <!-- sil --><td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords# - <cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				</tr>
			  </table> 
			</cfif>
		</td>
	</tr>
</table>
