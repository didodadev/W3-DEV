<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.tevkifat_status" default="1">
<cfscript>
	url_string = 'objects.popup_list_tevkifat_rates';
	if (isdefined('attributes.field_tevkifat_rate') and len(attributes.field_tevkifat_rate)) url_string = '#url_string#&field_tevkifat_rate=#attributes.field_tevkifat_rate#';
	if (isdefined('attributes.call_function') and len(attributes.call_function)) url_string = '#url_string#&call_function=#attributes.call_function#';
</cfscript>
<cfquery name="GET_TEVKIFAT_RATES" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		SETUP_TEVKIFAT
	<cfif (isDefined("attributes.tevkifat_status") and len(attributes.tevkifat_status))>
		WHERE
		 	IS_ACTIVE = #attributes.tevkifat_status#
	</cfif> 
</cfquery>
<script type="text/javascript">
function add_tevkifat(tevkifat_rate,tevkifat_rate_id)
{
	<cfif isDefined("attributes.field_tevkifat_rate")>
		<cfif listlen(attributes.field_tevkifat_rate,'.') eq 1>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_tevkifat_rate#</cfoutput>.value = commaSplit(tevkifat_rate,8);
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_tevkifat_rate#</cfoutput>.value = commaSplit(tevkifat_rate,8);
		</cfif>
	</cfif>
	<cfif isDefined("attributes.field_tevkifat_rate_id")>
		//Baskette bu alan isdefined ancak alttaki rate_id alani yok, fakat bunun kullanilmasi gereken ekranlar da var o yuzden undefined kontrolu eklendi fbs 20110616
		<cfif listlen(attributes.field_tevkifat_rate_id,'.') eq 1>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.<cfoutput>#attributes.field_tevkifat_rate_id#</cfoutput>.value = tevkifat_rate_id;
		<cfelse>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif><cfoutput>.#attributes.field_tevkifat_rate_id#</cfoutput>.value = tevkifat_rate_id;
		</cfif>
	</cfif>
	<cfif isdefined("attributes.call_function")>//Tevkifat hesaplamalarını yap.
		<cfif attributes.call_function eq "tevkifat_plus_cb()">
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>tevkifat_plus_cb();
		<cfelse>
			<cfif not isdefined("attributes.draggable")>window.opener.</cfif>toplam_hesapla(1);
		</cfif>
	</cfif>
	<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );<cfelse>window.close();</cfif>
}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='43463.Tevkifat Oranları'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="tevk_search" id="tevk_search" method="post" action="#request.self#?fuseaction=#url_string#">
			<div class="ui-form-list">
				<div class="form-group col small">
					<select name="tevkifat_status" id="tevkifat_status">
						<option value="1"<cfif isDefined("attributes.tevkifat_status") and (attributes.tevkifat_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif isDefined("attributes.tevkifat_status") and (attributes.tevkifat_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif isDefined('attributes.tevkifat_status') and not len(attributes.tevkifat_status)>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group col col-6">
					<cf_wrk_search_button button_type="4" is_excel='0' search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('tevk_search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</div>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id="32927.Tevkifat Çarpanı"></th>
					<cfif session.ep.our_company_info.is_efatura eq 1><th><cf_get_lang dictionary_id='58022.Tevkifat'> <cf_get_lang dictionary_id ='49089.Kodu'></th></cfif>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				</tr>
			</thead>
			<tbody>
				<cfif GET_TEVKIFAT_RATES.recordcount>
					<cfoutput query="GET_TEVKIFAT_RATES">
						<tr>
							<td> <a href="javascript:add_tevkifat('#STATEMENT_RATE#','#TEVKIFAT_ID#');" class="tableyazi">#STATEMENT_RATE_NUMERATOR#/#STATEMENT_RATE_DENOMINATOR#</a></td>
							<cfif session.ep.our_company_info.is_efatura eq 1><td>#TEVKIFAT_CODE#</td></cfif>
							<td>#DETAIL#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayit Yok'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>
