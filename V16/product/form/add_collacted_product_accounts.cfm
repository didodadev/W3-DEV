<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.has_account_code" default="">
<cfparam name="attributes.is_active" default="4">
<cfif isdefined("attributes.get_date") and len(attributes.get_date)>
	<cf_date tarih='attributes.get_date'> 
	<cfparam name="attributes.get_date" default="#attributes.get_date#">
<cfelse>
	<cfparam name="attributes.get_date" default="">
</cfif>	
<cfquery name="GET_PRODUCT_ACCOUNTS" datasource="#DSN3#">
	SELECT ACCOUNT_IADE,ACCOUNT_PUR_IADE,ACCOUNT_CODE,ACCOUNT_CODE_PUR,PRODUCT_ID,PERIOD_ID FROM PRODUCT_PERIOD
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td  height="35" class="headbold"><cf_get_lang dictionary_id='37300.Ürün Toplu Muh Kodu Düzenle'></td>
	<!-- sil -->
    <td>
      <table align="right">
        <cfform name="search_product" method="post" action="">
          <tr>
            <td><cf_get_lang dictionary_id='57544.Sorumlu'></td>
			 <td>
			 <cfinput type="text" name="employee" value="#attributes.employee#" style="width:80px;" maxlength="255" readonly>
             <input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
			 <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=search_product.employee_id&field_name=search_product.employee&select_list=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> </td>
             <td>
				<cfinput type="text" name="get_date" value="#dateformat(attributes.get_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;">
			  <cf_wrk_date_image date_field="get_date">
			 </td>
			<td>
			  <select name="is_active" id="is_active">
			  	<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
			  	<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
			  	<option value="3" <cfif attributes.is_active eq 3>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
			  </select>
			  </td>
			<td>
			  <select name="has_account_code" id="has_account_code">
			  	<option value=""><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></option>
			  	<option value="1" <cfif attributes.has_account_code is "1">selected</cfif>><cf_get_lang dictionary_id='37646.Tanımlı'></option>
			  	<option value="0" <cfif attributes.has_account_code is "0">selected</cfif>><cf_get_lang dictionary_id='58845.Tanımsız'></option>
			  </select>
			  </td>
            <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
    </td>
	<!-- sil -->
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" border="0" align="center" width="100%">
        <tr class="color-header" height="22">
          <td class="form-title" width="50"><cf_get_lang dictionary_id='57487.No'></td>
		  <td class="form-title"><cf_get_lang dictionary_id='57657.Ürün Adı'></td>
          <td class="form-title" width="100"><cf_get_lang dictionary_id='58800.Ürün Kodu'></td>
		  <td class="form-title" width="40">Per.KDV</td>
		  <TD class="form-title" width="40">Top.KDV</TD>
          <td class="form-title" width="120"><cf_get_lang dictionary_id='37403.Muhasebe Kod Satış'></td>
          <td class="form-title" width="120"><cf_get_lang dictionary_id='37402.Muhasebe Kod Alış'></td>
		  <td class="form-title" width="120"><cf_get_lang dictionary_id='37644.Muh. Kod Satış İade'></td>
          <td class="form-title" width="120"><cf_get_lang dictionary_id='37645.Muh. Kod Alış İade'></td>
        </tr>
        <cfif (attributes.is_active neq 4) or len(attributes.get_date)>
			<cfquery name="GET_PRODUCT" datasource="#DSN3#">
				SELECT * FROM PRODUCT
				WHERE
					PRODUCT.PRODUCT_ID IS NOT NULL
					<cfif len(attributes.employee) and len(attributes.employee_id)>AND PRODUCT.PRODUCT_MANAGER = #attributes.employee_id#</cfif>
					<cfif len(attributes.is_active) and (attributes.is_active eq 2)>AND PRODUCT.PRODUCT_STATUS=1
					<cfelseif len(attributes.is_active) and (attributes.is_active eq 3)>AND PRODUCT.PRODUCT_STATUS=0</cfif>
					<cfif len(attributes.get_date)>AND PRODUCT.RECORD_DATE >= #attributes.get_date#</cfif>
					<cfif len(attributes.has_account_code)>
						<cfif attributes.has_account_code eq 1>
						AND PRODUCT.PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE ACCOUNT_IADE IS NOT NULL AND ACCOUNT_PUR_IADE IS NOT NULL AND ACCOUNT_CODE IS NOT NULL AND ACCOUNT_CODE_PUR IS NOT NULL AND PERIOD_ID = #SESSION.EP.PERIOD_ID#)
						<cfelseif attributes.has_account_code eq 0>
						AND PRODUCT.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM PRODUCT_PERIOD WHERE ACCOUNT_IADE IS NOT NULL AND ACCOUNT_PUR_IADE IS NOT NULL AND ACCOUNT_CODE IS NOT NULL AND ACCOUNT_CODE_PUR IS NOT NULL AND PERIOD_ID = #SESSION.EP.PERIOD_ID#)
						</cfif>
					</cfif>
				ORDER BY PRODUCT.PRODUCT_ID
			</cfquery>
		<cfparam name="attributes.totalrecords" default=#get_product.recordcount#>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfif get_product.recordcount><!--- url_str# --->
		<cfform name="form_add_product_property" method="post" action="#request.self#?fuseaction=product.emptypopup_add_collacted_product_account&QRY_STR=#URLEncodedFormat(QUERY_STRING)#">
		<cfset row_count_ = 0>
		<cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset row_count_ = row_count_+1>
			<cfquery name="GET_PRODUCT_ACCOUNT" dbtype="query">
				SELECT ACCOUNT_CODE,ACCOUNT_CODE_PUR,ACCOUNT_IADE,ACCOUNT_PUR_IADE FROM GET_PRODUCT_ACCOUNTS WHERE PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID# AND PERIOD_ID = #SESSION.EP.PERIOD_ID#
			</cfquery>	
		  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
			<input type="hidden" name="account_code_name#row_count_#" id="account_code_name#row_count_#" value="#GET_PRODUCT_ACCOUNTS.ACCOUNT_CODE#">
			<input type="hidden" name="account_name_pur#row_count_#" id="account_name_pur#row_count_#" value="#GET_PRODUCT_ACCOUNTS.ACCOUNT_CODE_PUR#">
			<input type="hidden" name="account_iade_name#row_count_#" id="account_iade_name#row_count_#" value="#GET_PRODUCT_ACCOUNTS.ACCOUNT_CODE#">
			<input type="hidden" name="account_pur_iade_name#row_count_#" id="account_pur_iade_name#row_count_#" value="#GET_PRODUCT_ACCOUNTS.ACCOUNT_CODE_PUR#">
			<input type="hidden" name="product_id#row_count_#" id="product_id#row_count_#" value="#GET_PRODUCT.PRODUCT_ID#">
		  <td>#currentrow#</td>
		  <td>#product_name#</td>
		  <td>#product_code#</td>
		  <td align="center">#TAX#</td>
		  <TD align="center">#TAX_PURCHASE#</TD>
          <td nowrap><input type="text" name="account_code#row_count_#" id="account_code#row_count_#"  value="#GET_PRODUCT_ACCOUNT.ACCOUNT_CODE#" style="width:100px;">
		  <a href="javascript://" onClick="pencere_ac('#row_count_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		  <td nowrap><input type="text" name="account_code_pur#row_count_#" id="account_code_pur#row_count_#"  value="#GET_PRODUCT_ACCOUNT.ACCOUNT_CODE_PUR#"  style="width:100px;">
		  <a href="javascript://" onClick="pencere_ac2('#row_count_#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		 </td>
		 <td><input type="text" name="account_iade#row_count_#" id="account_iade#row_count_#"  value="#GET_PRODUCT_ACCOUNT.ACCOUNT_IADE#" style="width:100px;"><a href="javascript://" onClick="pencere_ac3('#row_count_#');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
		 <td><input type="text" name="account_pur_iade#row_count_#" id="account_pur_iade#row_count_#" value="#GET_PRODUCT_ACCOUNT.ACCOUNT_PUR_IADE#"  style="width:100px;"><a href="javascript://" onClick="pencere_ac4('#row_count_#');"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"></a></td>
		</cfoutput>
        <tr class="color-row">
             <td colspan="9" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' insert_info='Düzenle'></td>		
        </tr>
		<input type="hidden" name="row_count_" id="row_count_" value="<cfoutput>#row_count_#</cfoutput>">
		</cfform>
		</cfif>
	   <cfelse>
		<cfparam name="attributes.totalrecords" default=0>
		<cfset attributes.startrow=1>
       </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
     <table cellpadding="0" cellspacing="0" border="0" width="98%" height="35" align="center">
       <tr> 
         <td>
		<cfset adres = url.fuseaction>
		<cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>
			<cfset adres = '#adres#&employee_id=#attributes.employee_id#'>
		</cfif>
		<cfif isDefined('attributes.employee') and len(attributes.employee)>
			<cfset adres = '#adres#&employee=#attributes.employee#'>
		</cfif>
		<cfif isDefined('attributes.has_account_code') and len(attributes.has_account_code)>
			<cfset adres = '#adres#&has_account_code=#attributes.has_account_code#'>
		</cfif>
		<cfset adres = '#adres#&is_active=#attributes.is_active#'>
	  		<cf_pages page="#attributes.page#" 
	  			maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"> 
         </td>
		 <!-- sil -->
         <td align="right" style="text-align:right;"> <cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
         </td>
		 <!-- sil -->
       </tr>
     </table>
	 <br/>
</cfif>
<script type="text/javascript">
function pencere_ac(row)
{
	temp_account_code = eval('form_add_product_property.account_code'+row);
	if (temp_account_code.value.length != 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_code' + row + '&field_name=form_add_product_property.account_code_name' + row + '&account_code=' + temp_account_code.value, 'list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_code' + row + '&field_name=form_add_product_property.account_code_name' + row + '', 'list');
}
function pencere_ac2(row)
{
	temp_account_code = eval('form_add_product_property.account_code_pur'+row);
	if (temp_account_code.value.length != 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_code_pur' + row + '&field_name=form_add_product_property.account_code_name' + row + '&account_code=' + temp_account_code.value, 'list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_code_pur' + row + '&field_name=form_add_product_property.account_code_name' + row + '', 'list');
}

function pencere_ac3(row)
{
	temp_account_code = eval('form_add_product_property.account_iade'+row);
	if (temp_account_code.value.length != 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_iade' + row + '&field_name=form_add_product_property.account_iade_name' + row + '&account_code=' + temp_account_code.value, 'list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_iade' + row + '&field_name=form_add_product_property.account_iade_name' + row + '', 'list');
}

function pencere_ac4(row)
{
	temp_account_code = eval('form_add_product_property.account_pur_iade'+row);
	if (temp_account_code.value.length != 0)
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_pur_iade' + row + '&field_name=form_add_product_property.account_pur_iade_name' + row + '&account_code=' + temp_account_code.value, 'list');
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add_product_property.account_pur_iade' + row + '&field_name=form_add_product_property.account_pur_iade_name' + row + '', 'list');
}
</script>
