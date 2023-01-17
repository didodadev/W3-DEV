<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_all_worknet" datasource="#dsn#">
		SELECT 
			*
		FROM 
			WORKNET
		WHERE
		1=1 
		<cfif isdefined("attributes.status") and attributes.status eq 1>AND WORKNET_STATUS = 1 </cfif>
		<cfif isdefined("attributes.status") and attributes.status eq 2>AND WORKNET_STATUS = 0</cfif>
		<cfif len(attributes.keyword)>
			AND WORKNET LIKE '%#attributes.keyword#%'
		</cfif>
		<cfif not isdefined("session.ep")>
			AND IS_INTERNET = 1
		</cfif>
	</cfquery>
<cfelse> 
	<cfset get_all_worknet.recordcount = 0>
</cfif> 
<cfparam name="attributes.totalrecords" default='#get_all_worknet.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<!--- form labels --->
<cfsavecontent variable="title"><cf_get_lang no ='7.İşbirliği Platformları'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
<cfsavecontent variable="search"><cf_get_lang_main no ='153.ARA'></cfsavecontent>

<!--- search form --->
<cf_big_list_search title="#title#"> 
	<cfform name="list_worknet" method="post" action="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#">
		<input name="form_submitted" id="form_submitted" type="hidden" value="1">
		<cf_big_list_search_area>
			<div class="row">
				<div class="col col-12 form-inline">
					<div class="form-group">
						<div class="input-group x-10">
							<select name="status" id="status">
								<option value="1" <cfif isdefined("attributes.status") and attributes.status eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
								<option value="2" <cfif isdefined("attributes.status") and attributes.status eq 2>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
								<option value="3" <cfif isdefined("attributes.status") and attributes.status eq 3>selected</cfif>><cf_get_lang_main no ='296.Tümü'></option>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="input-group x-10">
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cf_wrk_search_button search_function='input_control()'>
						</div>
					</div>
				</div>
			</div>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area></cf_big_list_search_detail_area>
	</cfform>
</cf_big_list_search>

<!--- records --->
<cf_big_list>
	<thead>
		<tr>
			<th width="100"><cf_get_lang no ='27.Detaylı Bilgi'></th>
			<th><cf_get_lang no ='27.Detaylı Bilgi'></th>
			<th class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#&event=add</cfoutput>"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_all_worknet.recordcount>
			<cfoutput query="get_all_worknet" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="100" height="100">
						<cfif len(get_all_worknet.image_path)>
							<cf_get_server_file output_file="worknet/#image_path#" output_server="#server_image_path_id#" output_type="0" image_width="100" image_height="100">
						</cfif>
					</td>
					<td colspan="2" valign="top">
						<strong>#worknet#</strong><br/>
						#detail#<br/><br/>
						<a href="#website#">#website#</a><br/><br/>
						<a href="index.cfm?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#&event=upd&worknet_id=#get_all_worknet.worknet_id#">>><cf_get_lang no ='27.Detaylı Bilgi'></a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="worknet-row " height="25">
				<td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<script type="text/javascript">
    document.getElementById('keyword').focus();
	function input_control()
	{
		return true;
	}	
</script>
