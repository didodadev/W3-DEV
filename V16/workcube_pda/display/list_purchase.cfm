<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="30" class="headbold">İrsaliyeler</td>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
	<tr>
		<td class="color-row">
		<table>
			<cfform name="add_purchase" method="post" action="" enctype="multipart/form-data">  
			  	<tr>
					<td style="width:70px;">İrsaliye Tipi</td>
					<td style="width:200px;">
						<cfoutput>
						<select name="ship_type" style="width:150px;">
                        	<option value="">Hepsi</option>
                        	<option value="0">Alış</option>
                        	<option value="1">Satış</option>
                        </select>
						</cfoutput>
					</td>
			  	</tr>
			  	<tr>
					<td>Cari Hesap *</td>
					<td><input type="hidden" name="company_id" id="company_id">
						<input type="hidden" name="partner_id" id="partner_id" value="">
						<input type="hidden" name="partner_name" id="partner_name" value="">
						<input type="hidden" name="member_type" id="member_type" value="">
						<input type="hidden" name="consumer_id" id="consumer_id" value="">
						<input type="text" name="comp_name" id="comp_name" value="" style="width:150px;">
						<a href="javascript://" onClick="get_turkish_letters_div('document.add_purchase.comp_name','open_all_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="get_company_all_div('open_all_div');"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					</td>
			  	</tr>
				<tr>
					<td colspan="2"><div id="open_all_div"></div></td>
				</tr>
				<tr>
					<td>Tarih</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang no='211.Lütfen Geçerli Bir Tarih Giriniz !'></cfsavecontent>
		  				<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		 				<cf_wrk_date_image date_field="start_date">
			
						<cfsavecontent variable="message"><cf_get_lang no='211.Lütfen Geçerli Bir Tarih Giriniz !'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
		  				<cf_wrk_date_image date_field="finish_date">
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><input type="button" onClick="kontrol_prerecord();" value="Listele"></td>
				</tr>
				<tr>
					<td colspan="2"><div id="kontrol_prerecord_div"></div></td>
				</tr>
			</cfform>
		</table>
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
function kontrol_prerecord()
{
	if((document.getElementById("company_id").value == '' || document.getElementById("comp_name").value == '') && (document.getElementById("start_date").value == '' || document.getElementById("finish_date").value == ''))
	{
		alert("Cari Hesap veya Tarih Alanlarından Birini Seçmelisiniz!");
		return false;
	}
	goster(kontrol_prerecord_div);
	AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_purchase_div&company_id='+ add_purchase.company_id.value + '&partner_id='+ add_purchase.partner_id.value  +'&start_date='+ add_purchase.start_date.value +'&finish_date=' + add_purchase.finish_date.value +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_purchase','kontrol_prerecord_div');		
	return false;
}
add_purchase.comp_name.focus();

<cfif isdefined('attributes.cpid')>
	kontrol_prerecord();
</cfif>
</script>
<cf_get_lang_set module_name="sales"><!--- sayfanin en ustunde acilisi var --->
<cfinclude template="../form/basket_js_functions.cfm">
