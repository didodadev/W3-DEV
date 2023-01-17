<cf_xml_page_edit fuseact="settings.list_quality_control_types">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="quality_control_type" datasource="#dsn3#">
		SELECT
			0 SORT_TYPE,
			'' AS RESULT_ID,
			TYPE_ID,
			QUALITY_CONTROL_TYPE,
			TYPE_DESCRIPTION,
			STANDART_VALUE,
			QUALITY_MEASURE,
			TOLERANCE,
			IS_ACTIVE
		FROM
			QUALITY_CONTROL_TYPE
		WHERE
			<cfif ListFind("1,0",attributes.is_active)>
				IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
			</cfif>
			<cfif len(attributes.keyword)>
				(
					QUALITY_CONTROL_TYPE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					TYPE_DESCRIPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				) AND
			</cfif>
			<cfif Len(attributes.process_cat_id)>
				PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat_id#"> AND
			</cfif>
			1 = 1
		ORDER BY
			TYPE_ID,
			SORT_TYPE
	</cfquery>
<cfelse>
	<cfset quality_control_type.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#quality_control_type.recordcount#">

<cfset url_string = "" />
<cfif isDefined("attributes.call_function")><cfset url_string &= "call_function=#attributes.call_function#" /></cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang(1713,'Kalite Kontrol Kategorileri',43696)#" scroll="1" collapsable="1" resize="1" popup_box="1">
		<cfform name="quality_control" action="#request.self#?fuseaction=objects.popup_list_quality_control_types&#url_string#" method="post">
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cf_box_search>
				<div class ="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" maxlength="50" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class ="form-group">
					<select name="process_cat_id" id="process_cat_id" style="width:125px;">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<option value="76" <cfif attributes.process_cat_id eq 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
						<option value="171" <cfif attributes.process_cat_id eq 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
						<option value="811" <cfif attributes.process_cat_id eq 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
						<option value="-1" <cfif attributes.process_cat_id eq -1>selected</cfif>><cf_get_lang dictionary_id='54365.Operasyonlar'></option>
						<option value="-2" <cfif attributes.process_cat_id eq -2>selected</cfif>><cf_get_lang dictionary_id='57656.Servis'></option>
					</select>
				</div>
				<div class ="form-group">
					<select name="is_active" id="is_active" style="width:60px;">
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber(this);" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('quality_control', #attributes.modal_id#)">
				</div>
			</cf_box_search>
		</cfform>
        <cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='43698.Kontrol'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<cfif xml_show_values eq 1>
						<th><cf_get_lang dictionary_id='43677.Standart'></th>
						<th><cf_get_lang dictionary_id='57686.Ölçü'></th>
						<th><cf_get_lang dictionary_id='29443.Tolerans'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
				<cfif quality_control_type.recordcount>
					<cfoutput query="quality_control_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="setControlType({ type_id: #TYPE_ID#, quality_control_type: '#QUALITY_CONTROL_TYPE#', type_description: '#TYPE_DESCRIPTION#', standart_value: '#STANDART_VALUE#', quality_measure: '#QUALITY_MEASURE#', tolerance: '#TOLERANCE#'})"><b>#QUALITY_CONTROL_TYPE#</b></a></td>
							<td>#TYPE_DESCRIPTION#</td>
							<cfif xml_show_values eq 1>
								<td>#STANDART_VALUE#</td>
								<td>#QUALITY_MEASURE#</td>
								<td>#TOLERANCE#</td>
							</cfif>
							<td><cfif is_active eq 1><cf_get_lang dictionary_id ='57493.Aktif'><cfelse><cf_get_lang dictionary_id ='57494.Pasif'></cfif></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="<cfoutput>#xml_show_values eq 1 ? 7 : 4#</cfoutput>"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "objects.popup_list_quality_control_types&form_submitted=1&is_active=#attributes.is_active#">
			<cfif Len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
			<cfif Len(attributes.process_cat_id)><cfset url_str = "#url_str#&process_cat_id=#attributes.process_cat_id#"></cfif>
            <cfif isDefined("attributes.call_function")><cfset url_str = "#url_str#&call_function=#attributes.call_function#"></cfif>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#"
                isAjax="1"> 
		</cfif>
	</cf_box>
</div>

<script>
    function setControlType( args ) {
        <cfif isdefined("attributes.call_function")>
            <cfoutput>#attributes.call_function#(args)</cfoutput>;
        </cfif>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    }
</script>