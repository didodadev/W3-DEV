<cf_xml_page_edit fuseact="settings.popup_form_add_county">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.country" default="">

<cfsavecontent variable="right_images">
    <cfoutput>
        <li><a href="javascript://" onclick="import_cities()"><i class="fa fa-download" title="<cf_get_lang dictionary_id='63422.Data Services'> - <cf_get_lang dictionary_id='59129.İller'> / <cf_get_lang dictionary_id='59130.İlçeler'>"></i></a></li>
    </cfoutput>
</cfsavecontent>

<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
			get_city_county_action = createObject("component", "V16.settings.cfc.setupCity");
			get_city_county_action.dsn = dsn;
			
			GET_CITY_COUNTY_1 = get_city_county_action.GET_CITY_COUNTY_1_FNC
			(
				special_state :  '#iif(isdefined("attributes.special_state"),"attributes.special_state",DE(""))#',
				xml_dsp_special_state : '#xml_dsp_special_state#',
				keyword : '#attributes.keyword#',
				country: '#attributes.country#' );
				
				
			GET_CITY_COUNTY_2 = get_city_county_action.GET_CITY_COUNTY_2_FNC
			(
				special_state :  '#iif(isdefined("attributes.special_state"),"attributes.special_state",DE(""))#',
				xml_dsp_special_state : '#xml_dsp_special_state#',
				keyword : '#attributes.keyword#',
				country: '#attributes.country#' );
			
			
			GET_CITY_COUNTY_ = get_city_county_action.GET_CITY_COUNTY_FNC
			(
				special_state :  '#iif(isdefined("attributes.special_state"),"attributes.special_state",DE(""))#',
				xml_dsp_special_state : '#xml_dsp_special_state#',
				keyword : '#attributes.keyword#' ,
				country: '#attributes.country#');
		
	</cfscript>
<cfelse>
	<cfset get_city_county_.recordcount = 0>
</cfif>

<cfscript>
	get_city_county_action = createObject("component", "V16.settings.cfc.setupCity");
	get_city_county_action.dsn = dsn;
	
	GET_SPECIAL_STATE = get_city_county_action.GET_SPECIAL_STATE_FNC();
</cfscript>
<cfquery name="GET_COUNTRY" datasource="#DSN#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default='#get_city_county_.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_city" method="post" action="#request.self#?fuseaction=settings.list_city">
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group">
					<select name="country" id="country">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<cfoutput query="get_country">
							<option value="#country_id#" <cfif attributes.country eq country_id>selected="selected"</cfif>>#country_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3" onKeyUp="isNumber (this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">					
				</div>	
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_form_add_city')"><i class="fa fa-plus"></i></a>					
				</div>			
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','İller İlçeler','42894')#" uidrop="1" hide_table_column="1" right_images="#right_images#">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58608.İl'></th>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id='30316.Telefon Kodu'></th>
					<th><cf_get_lang dictionary_id='43119.Plaka Kodu'></th>
					<th><cf_get_lang dictionary_id='58219.Ülke'></th>
					<th width="35"><a   onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_form_add_city</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='43363.İl Ekle'>"></i></a></th>
					<th><cf_get_lang dictionary_id='43480.İlçe Ekle'></th>
			</tr>
			</thead>
			<cfif get_city_county_.recordcount>
				<tbody>
					<cfoutput query="get_city_county_" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td width="30">#currentrow#</td>
						<td><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_city&city_id=#city_id#');" class="tableyazi">#city_name#</a></td>
						<td><!-- sil --><a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_county&cit_id=#city_id#&county_id=#county_id#');" class="tableyazi"><!-- sil -->#county_name#</a></td>
						<td>#phone_code#</td>
						<td>#plate_code#</td>
						<td>#country_name# <cfif len(country_phone_code)>(#country_phone_code#)</cfif></td>
						<td width="35" align="right" style="text-align:right;">
							<a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_upd_city&city_id=#city_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>"></i></a>
						</td>
						<td width="50" align="right" style="text-align:right;">
							<a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_form_add_county&city_id=#city_id#');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='43480.İlçe Ekle'>"></i></a>
						</td>
					</tr>
					</cfoutput>
				</tbody>
			<cfelse>
				<tbody> 
                    <tr>
                        <td colspan="8">
					<cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif>
				 </tr>
			</tbody> 
		</cfif>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres = "">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.special_state") and len(attributes.special_state)>
				<cfset adres = "#adres#&special_state=#attributes.special_state#">
			</cfif>
			<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
				<cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
			</cfif>
			<cfif isdefined("attributes.country") and len(attributes.country)>
				<cfset adres = "#adres#&country=#attributes.country#">
			</cfif>
			<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="settings.list_city#adres#">
		</cfif>
	</cf_box>
</div>  
<script type="text/javascript">
	document.getElementById('keyword').focus();

    function import_cities() {
		openBoxDraggable("<cfoutput>#request.self#?fuseaction=settings.city_county_dataservice</cfoutput>",'','ui-draggable-box-small');
    }
</script>
