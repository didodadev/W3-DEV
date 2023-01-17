<cf_get_lang_set module_name="sales">
<cfparam name="attributes.start_date" default="#date_add('d',-1,now())#">
<cfparam name="attributes.finish_date" default="#date_add('d',1,now())#">

<table border="0" width="98%" cellpadding="0" cellspacing="0" align="center">
	<tr>
		<td height="35" class="headbold">İç Talepler</td>
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">	
	<tr>
		<td class="color-row">
		<table>
			<cfform name="add_internaldemand" method="post" action="" enctype="multipart/form-data">  
			  	<!--- <tr>
					<td>Müşteri *</td>
					<td><input type="hidden" name="ref_company_id" value="<cfif isdefined('attributes.cpid')><cfoutput>#attributes.cpid#</cfoutput></cfif>">
						<input type="hidden" name="ref_partner_id" value="">
						<input type="hidden" name="ref_consumer_id" value="">
						<input type="hidden" name="ref_employee_id" value="">
						<input type="hidden" name="ref_member_type" value="">
						<input type="text" name="ref_member_name" value="<cfif isdefined('attributes.cpid')><cfoutput>#get_comp_info.FULLNAME#</cfoutput></cfif>"  style="width:120px;">
						<a href="javascript://" onClick="get_turkish_letters_div('document.add_internaldemand.ref_member_name','turkish_letters_div');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
						<a href="javascript://" onClick="get_company_all_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle"></a>
					</td>
			  	</tr>
				<tr><td></td><td><div id="turkish_letters_div"></div></td></tr>
				<tr><td colspan="2"><div id="company_all_div"></div></td></tr> --->
				<tr>
					<td style="width:70px;">Talep Eden</td>
					<td style="width:200px;"><cfoutput>#session.pda.name# #session.pda.surname#</cfoutput></td>
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
					<td height="30">&nbsp;</td>
					<td align="right"><input type="button" onClick="kontrol_prerecord();" value="Listele"></td>
				</tr>
				
				<tr><td colspan="2"><div id="kontrol_prerecord_div"></div></td></tr>
			</cfform>
		</table>
		</td>
	</tr>
</table>
<br/>
<script type="text/javascript">
function kontrol_prerecord()
{
	goster(kontrol_prerecord_div);
	AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_internaldemand_div&start_date='+ add_internaldemand.start_date.value +'&finish_date=' + add_internaldemand.finish_date.value +'&div_name='+'kontrol_prerecord_div' +'&form_id=' + 'add_internaldemand','kontrol_prerecord_div');		
	return false;
}
//+ '&opportunity_type_id=' + document.add_internaldemand.opportunity_type_id[add_internaldemand.opportunity_type_id.selectedIndex].value  +'&opp_currency_id=' + document.add_internaldemand.opp_currency_id[add_internaldemand.opp_currency_id.selectedIndex].value

add_internaldemand.start_date.focus();

kontrol_prerecord();
</script>
<cf_get_lang_set module_name="sales"><!--- sayfanin en ustunde acilisi var --->
