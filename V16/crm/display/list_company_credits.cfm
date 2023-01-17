<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		CC.*,
		OC.NICK_NAME
	FROM 
		COMPANY_CREDIT CC,
		OUR_COMPANY OC
	WHERE 
		CC.COMPANY_ID = #URL.COMPANY_ID#
		AND
		OC.COMP_ID = CC.OUR_COMPANY_ID
</cfquery>

<cfset acik_toplam=0>
<cfset vadeli_toplam=0>
<cfset grup_toplam=0>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td class="headbold" height="35"><cf_get_lang no='336.Üye Risk Durumları'> : <cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput></td>
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-header" height="22"> 
          <td class="form-title" width="100"><cf_get_lang no='335.Şirketimiz'></td>
		  <td width="150"  class="form-title" style="text-align:right;"><cf_get_lang no='232.Açık Hesap Limiti'></td>
          <td width="150"  class="form-title" style="text-align:right;"><cf_get_lang no='233.Vadeli Ödeme Aracı Limiti'></td>
		  <td  class="form-title" style="text-align:right;"><cf_get_lang no='337.Toplam Limit'></td>
		  <td width="15"><cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_comp_credit&cpid=#attributes.company_id#','medium');"><img src="/images/plus_square.gif" border="0"></a></cfoutput></td>
        </tr>
       <cfif GET_CREDIT_LIMIT.recordcount>
	    <cfoutput query="GET_CREDIT_LIMIT">    
        <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            <td>#NICK_NAME#</td>
			<td  style="text-align:right;">
			<cfset acik_toplam = acik_toplam + OPEN_ACCOUNT_RISK_LIMIT>
			#tlformat(OPEN_ACCOUNT_RISK_LIMIT)# #MONEY#
			</td>
            <td  style="text-align:right;">
			<cfset vadeli_toplam = vadeli_toplam + FORWARD_SALE_LIMIT>
			#tlformat(FORWARD_SALE_LIMIT)# #MONEY#
			</td>
            <td  style="text-align:right;">
			<cfset ara_toplam = OPEN_ACCOUNT_RISK_LIMIT + FORWARD_SALE_LIMIT>
			<cfset grup_toplam = grup_toplam + ara_toplam>
			#tlformat(ara_toplam)# #MONEY#</td>
			<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_comp_credit&COMPANY_CREDIT_ID=#COMPANY_CREDIT_ID#','medium');"><img src="/images/update_list.gif" border="0"></a></td>
          </tr>
        </cfoutput> 
		<cfoutput>
		<tr height="20" class="color-list">
            <td class="txtboldblue"><cf_get_lang no='338.Grup Toplam'></td>
			<td  class="txtboldblue" style="text-align:right;">#tlformat(acik_toplam)# #GET_CREDIT_LIMIT.money#</td>
            <td  class="txtboldblue" style="text-align:right;">#tlformat(vadeli_toplam)# #GET_CREDIT_LIMIT.money#</td>
            <td  class="txtboldblue" style="text-align:right;">#tlformat(grup_toplam)# #GET_CREDIT_LIMIT.money#</td>
			<td></td>
          </tr>
		 </cfoutput>
		<cfelse>
		 <tr height="20" class="color-row">
            <td colspan="5"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
          </tr>
		</cfif>
      </table>
    </td>
  </tr>
</table>
