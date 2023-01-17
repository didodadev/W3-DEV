<cf_xml_page_edit fuseact="settings.list_district" is_multi_page="1">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
			get_district_county_action = createObject("component", "V16.settings.cfc.setupDistrict");
			get_district_county_action.dsn = dsn;
			
			get_quarter = get_district_county_action.get_quarter_fnc
			(keyword : '#attributes.keyword#',
			city : '#attributes.city#',
			country : '#attributes.country#');
	</cfscript>
<cfelse>
	<cfset get_quarter.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.country" default=''>
<cfparam name="attributes.city" default=''>

<cfparam name="attributes.totalrecords" default='#get_quarter.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY  ORDER BY COUNTRY_NAME 
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_quarter" action="#request.self#?fuseaction=settings.list_district" method="post">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group">
					<select name="country" id="country" onchange="LoadCity(this.value,'city','city')">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<cfoutput query="GET_COUNTRY">
							<option value="#country_id#" <cfif attributes.country eq country_id>selected="selected"</cfif>>#country_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="city" id="city">
						<cfquery name="GET_CITY" datasource="#DSN#">
							SELECT CITY_ID, CITY_NAME FROM SETUP_CITY  <cfif len(attributes.country)>WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country#"></cfif>
						</cfquery>
						<cfoutput query="GET_CITY">
							<option value="#CITY_ID#" <cfif attributes.city eq CITY_ID>selected="selected"</cfif>>#CITY_NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">					
				</div>		
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Mahalleler Köyler','63596')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58608.İl'></th>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id='58735.Mahalle'></th>
					<cfif xml_ims_code_show eq 1>
						<th><cf_get_lang dictionary_id='58134.Mikro Bölge Kodu'></th>
					</cfif>
						<th><cf_get_lang dictionary_id='57472.Posta Kodu'></th>
					<!-- sil -->
					<th width="35" ><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_form_add_district</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<cfif get_quarter.recordcount>
				<tbody>
					<cfoutput query="get_quarter" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="30">#currentrow#</td>
							<td>#city_name#</td>
							<td>#county_name#</td>
							<td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_district&district_id=#district_id#');" class="tableyazi">#district_name#</a></td>
							<cfif xml_ims_code_show eq 1>							
								<td>#ims_code#</td>
							</cfif>
							<td>#post_code#</td>
							<!-- sil -->
							<td width="35" align="center"><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_district&district_id=#district_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				</tbody>
			<cfelse>
				<tbody> 
                    <tr>
                        <td colspan="6">
					<cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif>
				 </tr>
			</tbody> 
		</cfif>
		</cf_grid_list>
		<cfset adres = "settings.list_district">
		<cfif isdefined("attributes.is_form_submitted") and len (attributes.is_form_submitted)>
			<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isDefined('attributes.city') and len(attributes.city)>
			<cfset adres = "#adres#&city=#attributes.city#">
		</cfif>
		<cfif isDefined('attributes.country') and len(attributes.country)>
			<cfset adres = "#adres#&country=#attributes.country#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
