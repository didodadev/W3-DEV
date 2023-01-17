<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfquery name="GET_ORDER_LIST" datasource="#dsn3#">
	SELECT 
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.COMMETHOD_ID,
		ORDERS.GROSSTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.ORDER_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.PRIORITY_ID, 
		ORDERS.IS_PROCESSED, 
		ORDERS.IS_WORK, 
		EMP.EMPLOYEE_NAME, 
		EMP.EMPLOYEE_EMAIL, 
		EMP.EMPLOYEE_SURNAME
	FROM 
		ORDERS
		LEFT JOIN workcube_cf.EMPLOYEES AS EMP ON ORDERS.RECORD_EMP = EMP.EMPLOYEE_ID
	WHERE 
	ORDERS.PURCHASE_SALES = 1
	<cfif len(attributes.keyword)>
		AND ORDERS.ORDER_NUMBER LIKE '%#attributes.keyword#%'
	</cfif>
	ORDER BY ORDERS.ORDER_NUMBER DESC
</cfquery>
<cfquery name="GET_COMMETHOD" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_PRIORITY
	<cfif isDefined("GET_ORDER_LIST.PRIORITY_ID") and len(GET_ORDER_LIST.PRIORITY_ID)>
	WHERE 
		PRIORITY_ID = #GET_ORDER_LIST.PRIORITY_ID#
	</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#' >
<cfparam name="attributes.totalrecords" default='#get_order_list.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfset sayac = 0 >
<script type="text/javascript">
	function gonder(no,deger,type,pap_no,pap_type,details,year_s)
	{
		<cfif isDefined("attributes.field_id")>
			window.opener.document.<cfoutput>#attributes.field_id#</cfoutput>.value=no;
		</cfif>
		<cfif isDefined("attributes.field_name")>
			window.opener.document.<cfoutput>#attributes.field_name#</cfoutput>.value=deger;
		</cfif>
		<cfif isDefined("attributes.field_type")>
			window.opener.document.<cfoutput>#attributes.field_type#</cfoutput>.value=type;
		</cfif>
		<cfif isDefined("attributes.field_paper_no")>
			window.opener.document.<cfoutput>#attributes.field_paper_no#</cfoutput>.value=pap_no;
		</cfif>
		<cfif isDefined("attributes.field_paper")>
			window.opener.document.<cfoutput>#attributes.field_paper#</cfoutput>.value=pap_type;
		</cfif>
		<cfif isDefined("attributes.field_detail")>
			window.opener.document.<cfoutput>#attributes.field_detail#</cfoutput>.value=details;
		</cfif>		
		<cfif isDefined("attributes.field_date")>
			window.opener.document.<cfoutput>#attributes.field_date#</cfoutput>.value=year_s;
		</cfif>	
		<cfif isDefined("attributes.function_name")>
			window.opener.<cfoutput>#attributes.function_name#</cfoutput>;
		</cfif>
		window.close();
	}
</script>
<cfscript>
	url_string = '';
	if (isdefined('attributes.field_id')) url_string = '#url_string#&field_id=#attributes.field_id#';
	if (isdefined('attributes.field_name')) url_string = '#url_string#&field_name=#attributes.field_name#';
	if (isdefined('attributes.field_type')) url_string = '#url_string#&field_type=#attributes.field_type#';
	if (isdefined('attributes.field_paper_no')) url_string = '#url_string#&field_paper_no=#attributes.field_paper_no#';
	if (isdefined('attributes.field_paper')) url_string = '#url_string#&field_paper=#attributes.field_paper#';
	if (isdefined('attributes.field_detail')) url_string = '#url_string#&field_detail=#attributes.field_detail#';
	if (isdefined('attributes.field_date')) url_string = '#url_string#&field_date=#attributes.field_date#';
	if (isdefined('attributes.function_name')) url_string = '#url_string#&function_name=#attributes.function_name#';
</cfscript>
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center">
  <tr>
    <td class="headbold" height="35"><cf_get_lang dictionary_id='58207.Satış Siparişleri'></td>
    <td height="30"  class="headbold" style="text-align:right;">
      <!--- Arama --->
      <table style="text-align:right;">
        <cfform action="#request.self#?fuseaction=objects.#fusebox.fuseaction##url_string#" method="post">
          <tr>
            <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
            <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            <td>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				<select name="status" id="status">
					<option value="" <cfif attributes.status eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</td>
            <td><cf_wrk_search_button></td>
          </tr>
        </cfform>
      </table>
      <!--- Arama --->
    </td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="color-border">
    <td>
      <table width="100%" cellpadding="2" cellspacing="1">
        <tr class="color-header" height="22">
          <td class="form-title" align="center"><cf_get_lang dictionary_id='58211.Sipariş No'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57673.Tutar'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57611.Sipariş'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57574.Şirket'>-<cf_get_lang dictionary_id='57578.Yetkili'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57576.Çalışan'></td>
          <td class="form-title"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'>-<cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
          <td class="form-title"><cf_get_lang dictionary_id='57485.Öncelik'></td>
        </tr>
        <cfif get_order_list.recordcount>
          <cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td><a href="javascript://" class="tableyazi" onClick="gonder('#order_id#','#order_number#','3','#ORDER_NUMBER#','Satınalma Siparişi','#order_head#','#DATEFORMAT(now(),dateformat_style)#')">#order_number#</a></td>
              <td  style="text-align:right;">#TLFormat(grosstotal)# #session.ep.money#</td>
              <td>#order_head#</td>
			  <cfif len(get_order_list.partner_id)>
				<td>#get_par_info(get_order_list.partner_id,0,0,1)#</td>
			  <cfelseif len(get_order_list.consumer_id)>
				<td>#get_cons_info(consumer_id,1,1)#</td>
			  <cfelse>
				<td>&nbsp;</td>
			  </cfif>
              <td>#employee_name# #employee_surname#</td>
              <td>#dateformat(order_date,dateformat_style)# - #dateformat(DELIVERDATE,dateformat_style)#</td>
              <td><font color="#get_commethod.color#">#get_commethod.priority#</font></td>
            </tr>
          </cfoutput>
          <cfelse>
          <tr>
            <td colspan="9" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<cfif attributes.totalrecords gte attributes.maxrows>
<cfif len(attributes.keyword)>
	<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
</cfif>
  <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
    <tr>
      <td>
	  <cf_pages 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="objects.#fusebox.fuseaction##url_string#">
		</td>
      <td  style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
