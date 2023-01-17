<cfsavecontent variable="message"><cf_get_lang dictionary_id='29478.XML Import'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=objects.emptypopup_upload_xml_import">
		<table>
			<tr>
		  		<td width="100"><cf_get_lang dictionary_id='58594.Format'></td>
		  		<td><select name="target_pos" id="target_pos" style="width:200px;">
						<option value="-50"><cf_get_lang dictionary_id='57441.Fatura'></option>
						<option value="-51"><cf_get_lang dictionary_id='57845.Tahsilat'></option>
						<option value="-52"><cf_get_lang dictionary_id='57611.Sipariş'></option>
						<option value="-53"><cf_get_lang dictionary_id='34041.Objects2 Ürünler'></option>
					</select>
				</td>
			</tr>
		  	<tr>
				<td><cf_get_lang dictionary_id='32901.Belge Formatı'></td>
				<td><select name="file_format" id="file_format" style="width:200px;">
						<option value="ISO-8859-9"><cf_get_lang dictionary_id='32979.ISO-8859-9 (Türkçe)'></option>
						<option value="UTF-8">UTF-8</option>
					</select>
				</td>
		 	</tr>
			<tr>
		  		<td><cf_get_lang dictionary_id='57468.Belge'></td>
		  		<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
			</tr>
			<cfset search_dep_id = listgetat(session.ep.user_location,1,'-')>
			<cfinclude template="../../stock/query/get_dep_names_for_inv.cfm">
			<tr>
		  		<td><cf_get_lang dictionary_id='57453.Şube'> *</td>
		  		<td>
					<input type="hidden" name="department_id" id="department_id" value="<cfoutput><cfif get_name_of_dep.recordcount>#search_dep_id#</cfif></cfoutput>">
		  			<input type="text" name="department" id="department" value="<cfoutput><cfif get_name_of_dep.recordcount>#get_name_of_dep.department_head#</cfif></cfoutput>" readonly style="width:200px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=formimport&field_name=department&field_id=department_id</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		 		</td>
			</tr>
			<tr>
		  		<td><cf_get_lang dictionary_id='57742.Tarih'> *</td>
		 		<td>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput type="text" name="processdate" value="#dateformat(now(),dateformat_style)#" required="Yes" message="#message#" validate="#validate_style#" maxlength="10" style="width:65px;">
					<cf_wrk_date_image date_field="processdate">
					<cfinput type="hidden" name="date_now" value="#dateformat(now(),dateformat_style)#">					
				</td>
			</tr>
			<tr>
				<td valign="top"><cf_get_lang dictionary_id='57629.Aciklama'></td>
				<td><textarea name="import_detail" id="import_detail" style="width:200px;height:80px"></textarea></td>
			</tr>
		</table>
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='form_chk()'></cf_popup_box_footer>
	</cfform> 
</cf_popup_box>
<script type="text/javascript">
function form_chk()
{	
	if (formimport.department_id.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id ='30126.Şube Seçiniz'> !");
		return false;
	}
	
	if(!date_check(document.formimport.processdate,document.formimport.date_now,"<cf_get_lang dictionary_id ='34040.Seçtiğiniz Tarih Bugünden Büyük Olmamalıdır'> !"))
	{
		return false;
	}	
	if (!chk_period(formimport.processdate,"İşlem")) return false;
	return true;		
}

</script>
