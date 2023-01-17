  <cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cf_papers paper_type = "ship">
<table class="dph">
	<tr>
		<td class="dpht"><a href="javascript:gizle_goster_basket(detail_inv_ships);">&raquo;</a><cf_get_lang no='121.Grup İçi İrsaliyesi Ekle'></td>
		<td class="dphb"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=store.add_ship_from_file&from_where=5"><img src="images/barcode_phl.gif" border="0" title="<cf_get_lang no='118.PHL Ekle'>"></a></td>
	</tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=store.emptypopup_add_sale_process_group" onsubmit="return (pre_submit());">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
    <cfif isdefined("paper_number")><input type="hidden" name="paper_number" id="paper_number" value="<cfoutput>#paper_number#</cfoutput>"></cfif>
    <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')><cfoutput>#paper_printer_code#</cfoutput></cfif>">
    <cf_basket_form id="detail_inv_ships">
		<table>
			<tr>
				<td><cf_get_lang_main no='1633.İrsaliye Tipi'></td>
				<td width="200">
					<cfif isdefined("attributes.process_cat")>
						<cfoutput><cf_workcube_process_cat onclick_function="check_process_is_sale();" process_cat="#attributes.process_cat#"></cfoutput>
					<cfelse>
						<cf_workcube_process_cat onclick_function="check_process_is_sale();"> 
					</cfif>
				</td>
				<td><cf_get_lang no='68.İrsaliye Tarihi'>*</td>
				<td width="200">
					<cfsavecontent variable="message"><cf_get_lang no='171.İrsaliye Tarihi girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" required="Yes" message="#message#" validate="#validate_style#" name="ship_date" style="width:150px;"   value="#dateformat(now(),dateformat_style)#">
					<cf_wrk_date_image date_field="ship_date">
				</td>
				<td><cf_get_lang_main no='1631.Çıkış Depo'> *</td>
				<td>
					<input type="hidden" name="branch_id" id="branch_id"<cfif isdefined("attributes.branch_id")><cfoutput> value="#attributes.branch_id#"</cfoutput></cfif>>
					<input type="hidden" name="location_id" id="location_id"<cfif isdefined("attributes.location_id")><cfoutput> value="#attributes.location_id#"</cfoutput></cfif>>
					<input type="hidden" name="department_id" id="department_id"<cfif isdefined("attributes.department_id")><cfoutput> value="#attributes.department_id#"</cfoutput></cfif>>
					<input type="hidden" name="adres" id="adres"  value="<cfif isdefined("attributes.adres")><cfoutput>#attributes.adres#</cfoutput></cfif>">
					<cfsavecontent variable="message"><cf_get_lang no='116.Çıkış Depo Girmelisiniz'> !</cfsavecontent>
					<cfif isdefined("attributes.txt_departman_")>
						<cfinput type="Text" style="width:150px;" name="txt_departman_" value="#attributes.txt_departman_#" required="yes" message="#message#" passthrough="readonly">
					<cfelse>
						<cfinput type="Text" style="width:150px;" name="txt_departman_" value="" required="yes" message="#message#" passthrough="readonly">
					</cfif>
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_&field_id=department_id&is_branch=1&field_location_id=location_id&branch_id=branch_id</cfoutput>','list')" >
					<img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
			</tr>
			<input type="hidden" name="company_id" id="company_id"<cfif isdefined("attributes.company_id")><cfoutput> value="#attributes.company_id#"</cfoutput></cfif>>
			<input type="hidden" name="comp_name" id="comp_name"<cfif isdefined("attributes.comp_name")><cfoutput> value="#attributes.comp_name#"</cfoutput></cfif>>
			<input type="hidden" name="partner_id" id="partner_id"<cfif isdefined("attributes.partner_id")><cfoutput> value="#attributes.partner_id#"</cfoutput></cfif>>
			<input type="hidden" name="consumer_id" id="consumer_id"<cfif isdefined("attributes.consumer_id")><cfoutput> value="#attributes.consumer_id#"</cfoutput></cfif>>
			<input type="hidden" name="partner_name" id="partner_name"<cfif isdefined("attributes.partner_name")><cfoutput> value="#attributes.partner_name#"</cfoutput></cfif>>
			<input type="hidden" name="order_number" id="order_number" value="">
			<tr>
				<td><cf_get_lang_main no='726.İrsaliye No'>*</td>
				<td width="200">
					<cfsavecontent variable="message"><cf_get_lang no='169.İrsaliye No girmelisiniz'>!</cfsavecontent>
					<cfif isdefined("paper_full")>
						<cfinput type="text" name="ship_number" style="width:150px;" required="Yes" maxlength="50" message="#message#" value="#paper_full#">
					<cfelse>
						<cfinput type="text" name="ship_number" style="width:150px;" required="Yes" maxlength="50" message="#message#" value="">
					</cfif>
				</td>
				<td><cf_get_lang no='183.Fiili Sevk Tarihi'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='161.Fiili Sevk Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput type="text"  validate="#validate_style#" name="deliver_date_frm" style="width:150px;" value="" message="#message#">
					<cf_wrk_date_image date_field="deliver_date_frm">
				</td>
				<td><cf_get_lang no ='172.Giriş Depo'> *</td>
				<td>
					<input type="hidden" name="branch_id_to" id="branch_id_to"<cfif isdefined("attributes.branch_id_to")><cfoutput> value="#attributes.branch_id_to#"</cfoutput></cfif>>
					<input type="hidden" name="location_id_to" id="location_id_to"<cfif isdefined("attributes.location_id_to")><cfoutput> value="#attributes.location_id_to#"</cfoutput></cfif>>
					<input type="hidden" name="department_id_to" id="department_id_to"<cfif isdefined("attributes.department_id_to")><cfoutput> value="#attributes.department_id_to#"</cfoutput></cfif>">
					<cfsavecontent variable="message"><cf_get_lang no ='162.Giriş Depo Girmelisiniz'> !</cfsavecontent>
					<cfif isdefined("attributes.txt_departman_to_")>
						<cfinput type="Text" style="width:150px;" name="txt_departman_to_" value="#attributes.txt_departman_to_#" required="yes" message="#message#" passthrough="readonly">
					<cfelse>
						<cfinput type="Text" style="width:150px;" name="txt_departman_to_" value="" required="yes" message="#message#" passthrough="readonly">	
					</cfif>
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_to_&field_id=department_id_to&is_branch=1&field_location_id=location_id_to&branch_id=branch_id_to&is_ingroup</cfoutput>','list')" >
					<img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1703.Sevk Metodu'>*</td>
				<td>
					<input type="hidden" name="SHIP_METHOD" id="SHIP_METHOD" value="">
					<cfsavecontent variable="message"><cf_get_lang no='176.Sevk Metodu girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" required="yes" message="#message#"  passthrough="readonly" name="ship_method_name"STYLE="width:150px;" value="" >
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=form_basket.ship_method_name&field_id=form_basket.SHIP_METHOD</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
			</tr>
		</table>
		<cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol_firma()'></cf_basket_form_button>
    </cf_basket_form>
	<cfset attributes.basket_id = 21>
    <cfif not isdefined("attributes.file_format")>
        <cfset attributes.form_add = 1>
    <cfelse>
        <cfset attributes.basket_sub_id = 4>
    </cfif>
    <cfinclude template="../../objects/display/basket.cfm">
</cfform>
<script type="text/javascript">
	function kontrol_firma()
	{	
		if(!chk_process_cat('form_basket')) return false;
		return true;
	}

	<cfif not isdefined("attributes.process_cat")>
	function toptan_satis_sec()
	{
		if(document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value!='')
		{
			max_sel = form_basket.process_cat.options.length;
			for(my_i=0;my_i<max_sel;my_i++)
			{
				deger = form_basket.process_cat.options[my_i].value;
				if(deger!="")
				{
					var fis_no = eval("form_basket.ct_process_type_" + deger );
					if(fis_no.value == 71)
					{
						form_basket.process_cat.options[my_i].selected = true;
						my_i = max_sel + 1;
					}
				}
			}
		}
	}
	toptan_satis_sec();
	</cfif>
	
	function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
		<cfif get_basket.basket_id is 21>
		if(document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value!='')
		{
			var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
			if(proc_control==71)
				sale_product= 0;
			else
				sale_product = 1;
		}
		<cfelse>
			return true;
		</cfif>
	}
	check_process_is_sale();
</script>
