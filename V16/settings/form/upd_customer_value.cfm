<cfquery name="GET_CUSTOMER_VALUE" datasource="#dsn#" maxrows="1">
	SELECT
		CUSTOMER_VALUE_ID
	FROM
		CONSUMER
	WHERE
		CUSTOMER_VALUE_ID=#attributes.ID#
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE_COMP" datasource="#dsn#" maxrows="1">
	SELECT
		COMPANY_VALUE_ID
	FROM
		COMPANY
	WHERE
		COMPANY_VALUE_ID=#attributes.ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='1087.Müşteri Değeri Bilgisi Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_customer_value"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a>
	</td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
<tr class="color-row">
  <td width="200" valign="top"><cfinclude template="../display/list_customer_value.cfm">
  </td>
  <td valign="top">
	<table>
	  <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_customer_value" method="post" name="upd_customer_value">
		<cfquery name="GET_TYPE" datasource="#dsn#">
			SELECT
				*
			FROM
				SETUP_CUSTOMER_VALUE
			WHERE
				CUSTOMER_VALUE_ID=#attributes.ID#
		</cfquery>
		<input type="Hidden" name="TYPE_ID" id="TYPE_ID" value="<cfoutput>#URL.ID#</cfoutput>">
		<tr>
		  <td width="100"><cf_get_lang_main no='1140.Müşteri Değeri'> *</td>
		  <td>
			<cfsavecontent variable="message"><cf_get_lang no='1085.Müşteri Değeri Girmelisiniz'></cfsavecontent>
			<cfinput type="Text" name="customer_value" size="40" value="#GET_TYPE.CUSTOMER_VALUE#" maxlength="100" required="Yes" message="#message#" style="width:200px;">
		  </td>
		</tr>
		<tr>
		  <td><cf_get_lang_main no='217.Açıklama'></td>
		  <td>
			<cftextarea name="detail" cols="75" style="width:200px;"><cfoutput>#GET_TYPE.DETAIL#</cfoutput></cftextarea>
		  </td>
		</tr>
		<tr>
		  <td><cf_get_lang no='1770.Ciro Aralığı'></td>
		  <td width="200">
			<input type="text" name="customer_sale_start" id="customer_sale_start" style="width:88px;" value="<cfif len(get_type.customer_sale_start)><cfoutput>#Tlformat(get_type.customer_sale_start)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));" class="moneybox"> 
			<input type="text" name="customer_sale_finish" id="customer_sale_finish" style="width:88px;" value="<cfif len(get_type.customer_sale_finish)><cfoutput>#Tlformat(get_type.customer_sale_finish)#</cfoutput></cfif>" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
			<cfoutput>#session.ep.money#</cfoutput>
		  </td>
		</tr>
		<tr>
		   <tr>
		   <td></td>
		  <td>
			<cfif GET_CUSTOMER_VALUE.recordcount or GET_CUSTOMER_VALUE_COMP.recordcount>
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'> 
			<cfelse>
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_customer_value&type_id=#url.id#'>
			</cfif>
		  </td>
		</tr>
		<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
		<cfoutput>
			<cfif len(get_type.record_emp)>
				#get_emp_info(get_type.record_emp,0,0)#
				#dateformat(get_type.record_date,dateformat_style)#
			</cfif>
		</cfoutput>
		</td>
		</tr>
		<tr>
		<td colspan="2">
		<cfoutput>
			<cfif len(get_type.update_emp)>
				<cf_get_lang_main no='291.Son Güncelleme'> : 
				#get_emp_info(get_type.update_emp,0,0)#
				#dateformat(get_type.update_date,dateformat_style)#
			</cfif>
		</cfoutput>
		</td>
		</tr>
	  </cfform>
	</table>
  </td>
</tr>
</table>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_customer_value.detail.value.length>200)
			{
			alert("<cf_get_lang no='1086.Açıklama 200 karakterden uzun olamaz'>");
			return false;
			}
		return true;
	}
</script>

