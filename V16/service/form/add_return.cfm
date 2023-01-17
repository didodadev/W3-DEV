<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and len(attributes.invoice_year)>
	<cfset my_source = '#dsn#_#invoice_year#_#session.pp.our_company_id#'>
	<cfquery name="GET_SEARCH_RESULTS_" datasource="#my_source#">
		SELECT
			INVOICE_ROW.*
		FROM
			INVOICE,
			INVOICE_ROW
		WHERE
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
			INVOICE.INVOICE_NUMBER = '#attributes.invoice_no#'AND
			INVOICE.COMPANY_ID = #session.pp.company_id#
	</cfquery>
</cfif>
<cfquery name="get_period" datasource="#dsn#">
	SELECT
		PERIOD_YEAR,
		PERIOD_ID
	FROM
		SETUP_PERIOD
	WHERE
		OUR_COMPANY_ID = #session.pp.our_company_id#
	ORDER BY
		PERIOD_YEAR
</cfquery>
<cfparam name="attributes.invoice_year" default="#session.pp.period_year#">
<cfquery name="get_return_cat" datasource="#dsn3#">
	SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<br/>
<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
  <tr>
    <td class="headbold" height="35">&nbsp;Ürün İade</td>
  </tr>
</table>
<table cellpadding="0" cellspacing="0" width="98%" align="center" border="0">
	<tr>
		<td valign="top">
		<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
			<cfform action="#request.self#?fuseaction=#attributes.fuseaction#" method="post" name="search_serial">
			<tr class="color-border">
			 <td>
				<table cellpadding="2" cellspacing="1" width="100%" height="100%">
				<tr class="color-row">
				<td>
					<table>
						<tr>
						<td><cf_get_lang_main no="721.Fatura No"></td>
						<td width="250">
						<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="721.Fatura No"></cfsavecontent>
						<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no)>
							<cfinput type="text" name="invoice_no" value="#attributes.invoice_no#" required="yes" message="#message#" style="width:150px;" >
						<cfelse>
							<cfinput type="text" name="invoice_no" value="" required="yes" message="#message#" style="width:150px;" >
						</cfif>
						<cfif isdefined("attributes.invoice_year") and len(attributes.invoice_year)>
							<select name="invoice_year" id="invoice_year" style="width:50px">
								<cfoutput query="get_period">
									<option value="#PERIOD_YEAR#" <cfif isdefined("attributes.invoice_year") and len(attributes.invoice_year) and (attributes.invoice_year eq PERIOD_YEAR)>selected</cfif>>#PERIOD_YEAR#</option>
								</cfoutput>
							</select>
						</cfif>
						<cf_wrk_search_button>
						</td>
						<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and get_search_results_.recordcount eq 0>
						   <td class="txtbold">&nbsp;&nbsp;&nbsp;<font color="FF0000">Kayıtlı Bir Fatura Yok !</font></td>			   
						</cfif>
						</tr>  
					</table>
				</td>
				</tr>				
				</table>
			 </td>
			 </tr>
		</cfform>
		</table>
		<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and get_search_results_.recordcount>
		<br/>
		<table cellpadding="0" cellspacing="0" border="0" width="98%" align="center">
			<tr class="color-border">
				<td>
					<table cellpadding="2" cellspacing="1" width="100%" height="100%">
					<cfform action="#request.self#?fuseaction=service.emptypopup_add_return" method="post" name="add_return">
						<tr class="color-list">
						<td>
							<table>
								<tr class="color-header" height="22">
									<td class="form-title"></td>
									<td class="form-title">Ürün Adı</td>
									<td class="form-title">Fatura Miktarı</td>
									<td class="form-title">İade Miktarı</td>
									<td class="form-title">İade Nedeni</td>
									<td class="form-title">Açıklama</td>
									<td class="form-title">Ambalaj</td>
									<td class="form-title">Aksesuar</td>
								</tr>
								<cfquery name="get_period_id" dbtype="query">
									SELECT PERIOD_ID FROM get_period WHERE PERIOD_YEAR = #attributes.invoice_year#
								</cfquery>
								<input name="period_id" id="period_id" type="hidden" value="<cfoutput>#get_period_id.PERIOD_ID#</cfoutput>">
								<input name="invoice_year" id="invoice_year" type="hidden" value="<cfoutput>#attributes.invoice_year#</cfoutput>">
								<input name="invoice_id" id="invoice_id" type="hidden" value="<cfoutput>#get_search_results_.INVOICE_ID#</cfoutput>">
								<input name="invoice_row_list" id="invoice_row_list" type="hidden" value="<cfoutput>#valuelist(get_search_results_.INVOICE_ROW_ID)#</cfoutput>">
								<cfoutput query="get_search_results_">
								<tr>
									<input name="stock_id#INVOICE_ROW_ID#" id="stock_id#INVOICE_ROW_ID#" type="hidden" value="#STOCK_ID#">
									<td><input type="checkbox" name="is_check#INVOICE_ROW_ID#" id="is_check#INVOICE_ROW_ID#" value="#INVOICE_ROW_ID#"></td>
									<td>#get_product_name(stock_id:STOCK_ID,with_property:1)#</td>
									<td>#AMOUNT#</td>
									<td>
										<input type="text" name="amount#INVOICE_ROW_ID#" id="amount#INVOICE_ROW_ID#" value="0" onkeyup="return(FormatCurrency(this,event,0));">
									</td>
									<td>
										<select name="returncat#INVOICE_ROW_ID#" id="returncat#INVOICE_ROW_ID#" style="width:150px">
											<cfloop query="get_return_cat">
												<option value="#RETURN_CAT_ID#">#RETURN_CAT#</option>
											</cfloop>
										</select>
									</td>
									<td><input type="text" name="detail#INVOICE_ROW_ID#" id="detail#INVOICE_ROW_ID#" value=""></td>
									<td>
										<select name="package#INVOICE_ROW_ID#" id="package#INVOICE_ROW_ID#" style="width:100px">
											<option value="0">Seçiniz</option>
											<option value="1">Sağlam</option>
											<option value="2">Hasarlı</option>
										</select>
									</td>
									<td>
										<select name="accessories#INVOICE_ROW_ID#" id="accessories#INVOICE_ROW_ID#" style="width:100px">
											<option value="0">Seçiniz</option>
											<option value="1">Tam</option>
											<option value="2">Eksik/Hasarlı</option>
										</select>
									</td>
								</tr>
								</cfoutput>
							</table>
						</td>
						</tr>
						<tr class="color-row">
							<td><cf_workcube_buttons add_function='kontrol()'></td>
						</tr>
					</cfform>
					</table>
				</td>
			</tr>
		</table>
		</cfif>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
		kontrol_ = 0;
		<cfoutput query="get_search_results_">
			if(document.add_return.amount#INVOICE_ROW_ID#.value.length < 1)
				{
				document.add_return.amount#INVOICE_ROW_ID#.value = 0;
				x = 0;
				}
			else
				x = parseInt(document.add_return.amount#INVOICE_ROW_ID#.value);
			
			if(document.add_return.is_check#INVOICE_ROW_ID#.checked && x <= 0)
				{
				alert('#currentrow#. Satır İçin İade Miktarı Girmelisiniz!');
				return false;
				}
		</cfoutput>
		<cfoutput query="get_search_results_">
			if(document.add_return.is_check#INVOICE_ROW_ID#.checked)
				kontrol_ = 1;
		</cfoutput>
		 	if(kontrol_ == 0)
				{
				alert('Hiçbir İade İşlemi Yapmadınız!');
				return false;
				}
		return Unformatfields;
	}
	
	function Unformatfields()
	{
		<cfoutput query="get_search_results_">
			document.add_return.amount#INVOICE_ROW_ID#.value = filterNum(document.add_return.amount#INVOICE_ROW_ID#.value);
		</cfoutput>
		return true;
	}
</script>


