<cfquery name="GET_EXPENSE" datasource="#DSN2#">
	SELECT 
		* 
	FROM 
		EXPENSE_CENTER 
	ORDER BY 
		EXPENSE_CODE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT 
		* 
	FROM	
		EXPENSE_ITEMS
</cfquery>
<cfquery name="GET_INVOICE_WITH_EXPENSE" datasource="#DSN2#">
	SELECT
		*
	FROM
		INVOICE
	WHERE
		EXPENSE_CENTER IS NOT NULL
</cfquery>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_expense.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr height="35">
    <td class="headbold"><cf_get_lang_main no='86.Masraf Yönetimi'></td>
    <td  style="text-align:right;">
      <table>
        <tr>
          <td><cf_get_lang_main no='48.Filtre'>:</td>
          <cfform name="search_asset" action="#request.self#?fuseaction=finance.list_expense_management" method="post">
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#">
            </td>
            <td>
              <select name="expese_center" id="expese_center">
                <option value=""><cf_get_lang_main no='823.Masraf Merkezi'>
                <cfoutput query="get_expense">
                  <option value="#expense_id#">#expense# 
                </cfoutput>
              </select>
              <select name="expense_item" id="expense_item">
                <option value=""><cf_get_lang_main no='1139.Gider Kalemi'>
                <cfoutput query="get_expense_item">
                  <option value="#expense_item_id#">#expense_item_name# 
                </cfoutput>
              </select>
            <td>
			  <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
              <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
          </cfform>
        </tr>
      </table>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr height="22" class="color-header">
          <td class="form-title" width="150"><cf_get_lang_main no='823.Masraf Merkezi'></td>
          <td class="form-title" width="250"><cf_get_lang_main no='1139.Gider Kalemi'></td>
          <td class="form-title" width="250"><cf_get_lang_main no='1121.Belge Tipi'></td>
          <td class="form-title" width="150"><cf_get_lang no='223.Miktar'></td>
          <td class="form-title" width="150"><cf_get_lang_main no='77.Para Birimi'></td>
          <td class="form-title" width="150"><cf_get_lang_main no='330.Tarih'></td>
          <td class="form-title" width="150"><cf_get_lang_main no='487.Kaydeden'></td>
        </tr>
        <cfif get_invoice_with_expense.recordcount>
          <cfoutput query="get_invoice_with_expense">
          <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		  <cfquery name="get_invoice_expense_item" datasource="#DSN2#">
			  SELECT
				  *
			  FROM
				  EXPENSE_CENTER
			  WHERE
				  EXPENSE_ID=#GET_INVOICE_WITH_EXPENSE.EXPENSE_CENTER#
		  </cfquery>
            <td>#get_invoice_expense_item.expense#</td>
            <td>&nbsp;</td>
            <td>		
			<cfif invoice_cat eq 51><cf_get_lang_main no='351.Alınan Vade Farkı Faturası'>
			<cfelseif invoice_cat eq 54><cf_get_lang_main no='412.Parekende Satış İade Faturası'>
			<cfelseif invoice_cat eq 55><cf_get_lang_main no='356.Toptan Satış İade Faturası'>
			<cfelseif invoice_cat eq 59><cf_get_lang_main no='410.Mal Alım Faturası'>
			<cfelseif invoice_cat eq 60><cf_get_lang_main no='401.Alınan Hizmet Faturası'>
			<cfelseif invoice_cat eq 61><cf_get_lang_main no='402.Alınan Proforma Faturası'>
			<cfelseif invoice_cat eq 63><cf_get_lang_main no='399.Alınan Fiyat Farkı Faturası'>
			<cfelseif invoice_cat eq 64><cf_get_lang no='244.Müstahsil Makbuzu'>
			</cfif>
			</td>
            <td>#TLFormat(grosstotal)#</td>
            <td>#other_money#</td>
            <td>#dateformat(record_date,dateformat_style)#</td>
            <td>#get_emp_info(get_invoice_with_expense.RECORD_EMP,0,0)#</td>
            </cfoutput>
            <cfelse>
          </tr>
          <tr class="color-row">
            <td height="20" colspan="8"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td>
	  <cf_pages page="#attributes.page#"
		  maxrows="#attributes.maxrows#"
		  totalrecords="#attributes.totalrecords#"
		  startrow="#attributes.startrow#"
		  adres="finance.list_expense_managemtn">
		 </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
  <br/>
</cfif>

