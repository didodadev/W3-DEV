<cf_xml_page_edit fuseact="objects.popup_export_customer_type"> 
<cfsavecontent variable="message"><cf_get_lang dictionary_id='45845.Müşteri Kartları'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="form_export" method="post" action="#request.self#?fuseaction=objects.emptypopup_export_customer_type">
	<div class="row form-inline">
		<div class="form-group" id="item-target_pos">
				<label width="75"><cf_get_lang dictionary_id='58594.Format'> *</label>
			<div class="input-group x-12">
					<select name="target_pos" id="target_pos" style="width:150px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
						<option value="-1"><cf_get_lang dictionary_id='32843.Genius'></option>
						<option value="-2">Inter</option>
						<option value="-6">ESPOS</option>
					</select>
				</div>
		  	</div>
		</div>	  
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	<cfif xml_consumer_card_detail eq 1>
		if(document.getElementById("target_pos").value != -1)
			{
				alert ("<cf_get_lang dictionary_id='34318.İlgili Formatta Kart Bilgisi Alamazsınız'> !");
				return false;
			}
	</cfif>
	x = document.form_export.target_pos.selectedIndex;
	if (document.form_export.target_pos[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='32915.İlgili Formatı Seçiniz'> !");
		return false;
	}
	return true;
}
</script>
