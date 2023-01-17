<cfparam name="attributes.module_name" default=''>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="GET_LANGS" datasource="#DSN#">
        SELECT
            *
        FROM
            SETUP_LANG_SPECIAL
        WHERE
            ITEM_ID IS NOT NULL
        <cfif len(attributes.module_name)>
            AND MODULE_ID = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#attributes.module_name#">
        </cfif>
        <cfif len(attributes.keyword)>
            AND ITEM LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
        </cfif>
        ORDER BY ITEM_ID, LANG_NAME
    </cfquery>
<cfelse>
	<cfset get_langs.recordcount = 0>
</cfif>

<cfinclude template="../query/get_lang_modules.cfm">  
<cfparam name="attributes.totalrecords" default="#get_langs.RecordCount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
	<cfform name="form_special" action="#request.self#?fuseaction=settings.special_langs" method="post">
		<cfinput type="hidden" name="is_form_submitted" value="1">		
		<cf_box_search>
			<div class="form-group" id="form_ul_keyword">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
			</div>
			<div class="form-group" id="form_ul_keyword">
				<select name="module_name" id="module_name">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="GET_MODULES">
						<option value="#MODULE_SHORT_NAME#" <cfif attributes.module_name is '#MODULE_SHORT_NAME#'>selected</cfif>>#MODULE_NAME_#</option>
					</cfoutput>
					<option value="home" <cfif attributes.module_name is 'home'>selected</cfif>> Home</option>				
					<option value="myhome" <cfif attributes.module_name is 'myhome'>selected</cfif>> Myhome</option>
					<option value="main" <cfif attributes.module_name is 'main'>selected</cfif>><cf_get_lang no='778.Temel'></option>					   
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes">
			</div>
			<div class="form-group">				
				<cf_wrk_search_button button_type="4">
			</div>
			<div class="form-group">
				<a  class="ui-btn ui-btn-gray2" href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.special_lang_set" target="blank_"><i class="fa fa-download "></i></a>
			</div>
		</cf_box_search>
	</cfform>
</cf_box>
<cf_box title="#getLang('settings',1265)#" closable="0" uidrop="1" resize="1" hide_table_column="1" responsive_table="1">
	<cf_grid_list>
		<thead> 
			<tr> 
				<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
				<th><cf_get_lang no='1239.Kelime No'></th>
				<th><cf_get_lang no='195.Modül'></th>
				<th><cf_get_lang no='319.Kelime'></th>			
				<th><cf_get_lang_main no='1584.Dil'></th>
				<th class="header_icn_none"><a><i class="fa fa-minus" alt="<cf_get_lang_main no='51.Sil'>" title="<cf_get_lang_main no='51. Sil'>"></i></a></th><!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfif get_langs.RecordCount>
				<cfoutput query="get_langs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
					<td>#currentrow#</td>
					<td>#item_id#</td>
					<td>#module_id#</td>
					<td>#item#</td>
					<td>#lang_name#</td>
					<!-- sil -->
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_special_lang_item&module_id=#MODULE_ID#&item_id=#ITEM_ID#&lang_name=#LANG_NAME#','small');">
					<i class="fa fa-minus" alt="<cf_get_lang_main no='51.Sil'>" title="<cf_get_lang_main no='51. Sil'>"></i>
					</a></td>
					<!-- sil -->
					</tr>
				</cfoutput> 
			<cfelse>
			<tr> 
				<td colspan="6"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif></td>
			</tr>
			</cfif>
		</tbody>
	</cf_grid_list> 
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.special_langs&is_form_submitted=1">
		<cfif len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.module_name)>
			<cfset adres = "#adres#&module_name=#attributes.module_name#">
		</cfif>
		<cf_paging page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
	</cfif>
</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
