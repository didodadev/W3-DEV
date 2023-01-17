<cfparam name="attributes.invoice_year" default="#session_base.period_year#">
<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfif isdefined("session.pp")>
	<cfset period_company_ = session.pp.our_company_id>	
<cfelseif isdefined("session.cp")>
	<cfset period_company_ = session.cp.our_company_id>
<cfelseif isdefined("session.ep")>
	<cfset period_company_ = session.ep.company_id>
<cfelse>
	<cfset period_company_ = session.ww.our_company_id>
</cfif>	
		
<cfif (isdefined("attributes.invoice_no") and len(attributes.invoice_no) and len(attributes.invoice_year)) or (isdefined('attributes.is_form_submit') and attributes.is_form_submit eq 1)>
	<cfset my_source = '#dsn#_#attributes.invoice_year#_#period_company_#'>
	<cfquery name="GET_SEARCH_RESULTS_" datasource="#my_source#" maxrows="10">
		SELECT
			INVOICE_ROW.INVOICE_ROW_ID,
            INVOICE_ROW.STOCK_ID,
            INVOICE_ROW.AMOUNT,
            INVOICE.INVOICE_ID,
			INVOICE.INVOICE_DATE
		FROM
			INVOICE,
			INVOICE_ROW
		WHERE
        	<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			<cfelseif isdefined("session.pp.company_id")>
				INVOICE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
			<cfelse>
				INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			</cfif>
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
			<cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)>
				AND INVOICE.INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_no#">
			</cfif>
			<cfif isdefined("attributes.is_inventory") and attributes.is_inventory eq 1>
				AND INVOICE_ROW.PRODUCT_ID IN(SELECT P.PRODUCT_ID FROM #dsn3_alias#.PRODUCT P WHERE P.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND P.IS_INVENTORY=1)
			</cfif>
	</cfquery>
<cfif isdefined('attributes.is_all_invoices') and attributes.is_all_invoices eq 1>
	</cfif>
</cfif>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT
		PERIOD_YEAR,
		PERIOD_ID
	FROM
		SETUP_PERIOD
	WHERE
	<cfif isdefined("session.pp")>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_company_#">	
	<cfelseif isdefined("session.cp")>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_company_#">
	<cfelse>
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#period_company_#">
	</cfif>
	ORDER BY
		PERIOD_YEAR
</cfquery>
<cfif isdefined("session.pp")>
	<cfparam name="attributes.invoice_year" default="#session.pp.period_year#">	
<cfelseif isdefined("session.ep")>
	<cfparam name="attributes.invoice_year" default="#session.ep.period_year#">	
<cfelse>
	<cfparam name="attributes.invoice_year" default="#session.ww.period_year#">
</cfif>
<cfquery name="GET_RETURN_CAT" datasource="#DSN3#">
	SELECT RETURN_CAT_ID, RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<br/>
<cfform action="#request.self#?fuseaction=#attributes.fuseaction#" method="post" name="search_serial">
	<table>
		<tr style="height:30px;">
			<td colspan="2" class="formbold">
				<cf_get_lang no='612.İade etmek istediğiniz ürünü satın aldığınız fatura no yu girerek seçiniz'>.<br/>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='721.Fatura No'></td>
			<td nowrap="nowrap">
				<cfsavecontent variable="message"><cf_get_lang no ='1139.Fatura No Girmelisiniz'> !</cfsavecontent>
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>" class="add-return-class">
				</cfif>
				<input type="hidden" name="is_all_invoices" id="is_all_invoices" value="<cfif isdefined('attributes.is_all_invoices') and len(attributes.is_all_invoices)><cfoutput>#attributes.is_all_invoices#</cfoutput></cfif>" class="add-return-class">
				<input type="hidden" name="is_form_submit" id="is_form_submit" value="<cfif isdefined('attributes.is_all_invoices') and len(attributes.is_all_invoices)>1</cfif>" class="add-return-class">
				<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no)>
					<cfif isdefined('attributes.is_all_invoices') and attributes.is_all_invoices eq 1>
						<cfinput type="text" name="invoice_no" id="invoice_no" value="#attributes.invoice_no#" class="add-return-class" message="#message#" style="width:120px;" >
					<cfelse>
						<cfinput type="text" name="invoice_no" id="invoice_no" value="#attributes.invoice_no#" class="add-return-class" required="yes" message="#message#" style="width:120px;" >
					</cfif>
				<cfelse>
					<cfif isdefined('attributes.is_all_invoices') and attributes.is_all_invoices eq 1>
						<cfinput type="text" name="invoice_no" id="invoice_no" value="" class="add-return-class" message="#message#" style="width:150px;" >
					<cfelse>
						<cfinput type="text" name="invoice_no" id="invoice_no" value="" class="add-return-class" required="yes" message="#message#" style="width:150px;" >
					</cfif>
				</cfif>
				<cfif isdefined("attributes.invoice_year") and len(attributes.invoice_year)>
					<select name="invoice_year" id="invoice_year" class="add-return-class" style="width:50px">
						<cfoutput query="get_period">
							<option value="#period_year#" <cfif isdefined("attributes.invoice_year") and len(attributes.invoice_year) and (attributes.invoice_year eq period_year)>selected</cfif>>#period_year#</option>
						</cfoutput>
					</select>
				</cfif>
				<cfsavecontent variable="message"><cf_get_lang_main no ='153.ARA'></cfsavecontent>
				<cf_workcube_buttons is_cancel="0" insert_info="#message#">
				<cfif isdefined("attributes.invoice_no") and len(attributes.invoice_no) and get_search_results_.recordcount eq 0>
					<font color="FF8E01"><cf_get_lang no='613.Kayıtlı Bir Fatura Yok'> !</font>			   
				</cfif>
			</td>
		</tr>
	</table>
</cfform>  

<cfif ((isdefined("attributes.invoice_no") and len(attributes.invoice_no)) or (isdefined('attributes.is_form_submit') and attributes.is_form_submit eq 1)) and get_search_results_.recordcount>
	<br/>
	<table>
		<tr style="height:30px;">
			<td class="formbold">
				İlgili Fatura : <cfoutput><cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)>#attributes.invoice_no#</cfif> - #dateformat(get_search_results_.invoice_date,'dd/mm/yyyy')#</cfoutput>
				<cfif isdefined("attributes.return_day_control") and isnumeric(attributes.return_day_control) and datediff("d",get_search_results_.invoice_date,now()) gt attributes.return_day_control>
					<font color="red">Ürün İade Süresi Geçmiştir. İade Yapamazsınız!</font>
				</cfif>
			</td>
		</tr>
	</table>
	<cfform action="#request.self#?fuseaction=objects2.emptypopup_add_return" method="post" name="add_return">
		<table cellpadding="2" cellspacing="1" class="color-border" style="width:100%;">
			<tr class="color-header" style="height:22px;">
				<td class="form-title"><input type="checkbox" name="hepsi" id="hepsi" value="1" onclick="check_all(this.checked);"></td>
				<td class="form-title"><cf_get_lang_main no='809.Ürün Adı'></td>
				<td class="form-title"><cf_get_lang no='578.Fatura Miktarı'></td>
				<td class="form-title"><cf_get_lang no='579.İade Edilen Miktarı'></td>
				<td class="form-title"><cf_get_lang no='580.İade Miktarı'></td>
				<td class="form-title"><cf_get_lang no='581.İade Nedeni'></td>
				<td class="form-title"><cf_get_lang_main no='217.Açıklama'></td>
				<td class="form-title"><cf_get_lang no='582.Ambalaj'></td>
				<cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>
					<td class="form-title"><cf_get_lang no='583.Aksesuar'></td>
				</cfif>
			</tr>
			<cfquery name="GET_PERIOD_ID" dbtype="query">
				SELECT PERIOD_ID FROM GET_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_year#">
			</cfquery>
			<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
			</cfif>
			<input type="hidden" name="period_id" id="period_id" value="<cfoutput>#get_period_id.period_id#</cfoutput>">
			<input type="hidden" name="paper_no" id="paper_no" value="<cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)><cfoutput>#attributes.invoice_no#</cfoutput></cfif>">
			<input type="hidden" name="invoice_year" id="invoice_year" value="<cfoutput>#attributes.invoice_year#</cfoutput>">
			<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#get_search_results_.invoice_id#</cfoutput>">
			<input type="hidden" name="invoice_row_list" id="invoice_row_list" value="<cfoutput>#valuelist(get_search_results_.invoice_row_id)#</cfoutput>">
			<cfoutput query="get_search_results_">
				<cfquery name="GET_IADE_" datasource="#DSN3#">
					SELECT
						ISNULL(SUM(SPRR.AMOUNT),0) AS AMOUNT
					FROM
						SERVICE_PROD_RETURN SPR,
						SERVICE_PROD_RETURN_ROWS SPRR
					WHERE
						SPR.RETURN_ID = SPRR.RETURN_ID AND
						SPR.RETURN_ID IS NOT NULL AND
						SPRR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> 
						<cfif isdefined('attributes.invoice_no') and len(attributes.invoice_no)>
							AND	SPR.PAPER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.invoice_no#">
						</cfif>
					GROUP BY
						SPRR.STOCK_ID
				</cfquery>
				<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
					<input name="stock_id#invoice_row_id#" id="stock_id#invoice_row_id#" type="hidden" value="#stock_id#">
					<td>
						<cfif get_iade_.amount lt amount><input type="checkbox" name="is_check#invoice_row_id#" id="is_check#invoice_row_id#" value="#invoice_row_id#"  onclick="check_row(this.checked,#invoice_row_id#);"></cfif>
					</td>
					<td>#get_product_name(stock_id:stock_id,with_property:1)#</td>
					<td><input type="hidden" name="invoice_amount#invoice_row_id#" id="invoice_amount#invoice_row_id#" value="#amount#"></td>
					<td><cfif get_iade_.recordcount>#get_iade_.amount#<cfelse>0</cfif><input type="hidden" name="return_amount#invoice_row_id#" id="return_amount#invoice_row_id#" value="<cfif get_iade_.recordcount>#get_iade_.amount#<cfelse>0</cfif>"></td>
					<td><input type="text" name="amount#invoice_row_id#" id="amount#invoice_row_id#" value="0" onkeyup="return(FormatCurrency(this,event,0));" class="add-return-class"></td>
					<td>
						<select name="returncat#invoice_row_id#" id="returncat#invoice_row_id#" class="add-return-class" style="width:150px">
							<cfloop query="get_return_cat">
								<option value="#return_cat_id#">#return_cat#</option>
							</cfloop>
						</select>
					</td>
					<td><input type="text" name="detail#invoice_row_id#" id="detail#invoice_row_id#" value="" class="add-return-class"></td>
					<td>
						<select name="package#invoice_row_id#" id="package#invoice_row_id#" class="add-return-class" style="width:100px">
							<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
							<option value="1"><cf_get_lang no='584.Sağlam'></option>
							<option value="2"><cf_get_lang no='585.Hasarlı'></option>
						</select>
					</td>
					<cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>
						<td>
							<select name="accessories#invoice_row_id#" id="accessories#invoice_row_id#" class="add-return-class" style="width:100px">
								<option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
								<option value="1"><cf_get_lang no='586.Tam'></option>
								<option value="2"><cf_get_lang no='587.Eksik'>/<cf_get_lang no='585.Hasarlı'></option>
							</select>
						</td>
					</cfif>
				</tr>
			</cfoutput>
			<tr class="color-row">
				<td align="right" style="text-align:right;" <cfif (isdefined("attributes.is_accessories_info") and attributes.is_accessories_info eq 1) or not isdefined("attributes.is_accessories_info")>colspan="9"<cfelse>colspan="8"</cfif>>
					<cfif isdefined("attributes.is_return_type") and attributes.is_return_type eq 1>
						İşlem Tipi
						<select name="return_type" id="return_type" style="width:70px;">
							<option value="1">İade</option>
							<option value="2">Değişim</option>
						</select>
					</cfif>
					<cfif isdefined("attributes.return_day_control") and isnumeric(attributes.return_day_control) and datediff("d",get_search_results_.invoice_date,now()) gt attributes.return_day_control>
					<cfelse>
						<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						<cf_workcube_buttons add_function='kontrol()'>
					</cfif>
				</td>
			</tr>
		</table>
	</cfform>
</cfif>

<cfif ((isdefined("attributes.invoice_no") and len(attributes.invoice_no)) or (isdefined('attributes.is_form_submit') and attributes.is_form_submit eq 1)) and get_search_results_.recordcount>
	<script type="text/javascript">
		function check_all(deger)
		{
			<cfif get_search_results_.recordcount>
				if(add_return.hepsi.checked)
				{
					<cfoutput query="get_search_results_">
						if(eval("document.getElementById('is_check" + #invoice_row_id# + "')"))
						{
							eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked = true;
							eval("document.getElementById('amount" + #invoice_row_id# + "')").value = parseFloat(eval("document.getElementById('invoice_amount" + #invoice_row_id# + "')").value-eval("document.getElementById('return_amount" + #invoice_row_id# + "')").value);
						}
					</cfoutput>
				}
				else
				{
					<cfoutput query="get_search_results_">
						if(eval("document.getElementById('is_check" + #invoice_row_id# + "')"))
						{
							eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked = false;
							eval("document.getElementById('amount" + #invoice_row_id# + "')").value = 0;
						}
					</cfoutput>		
				}
			</cfif>
		}
		function check_row(deger,row_id)
		{
			if(deger)
			{
				eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked = true;
				eval("document.getElementById('amount" + #invoice_row_id# + "')").value = parseFloat(eval("document.getElementById('invoice_amount" + #invoice_row_id# + "')").value-eval("document.getElementById('return_amount" + #invoice_row_id# + "')").value);
			}
			else
			{
				eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked = false;
				eval("document.getElementById('amount" + #invoice_row_id# + "')").value = 0;
			}
		}
		function kontrol()
		{
			process_cat_control();
			kontrol_ = 0;
			<cfoutput query="get_search_results_">
				if(eval("document.add_return.is_check" + #invoice_row_id#))
				{
					if(eval("document.getElementById('amount" + #invoice_row_id# + "')").value.length < 1)
					{
						eval("document.getElementById('amount" + #invoice_row_id# + "')").value = 0;
						x = 0;
					}
					else
						x = parseInt(eval("document.getElementById('amount" + #invoice_row_id# + "')").value);
					
					if(eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked && x <= 0)
					{
						alert('#currentrow#. <cf_get_lang no="588.Satır İçin İade Miktarı Girmelisiniz">!');
						return false;
					}
						
					if(eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked && x > #amount#)
					{
						alert('#currentrow#. <cf_get_lang no="589.Satır İçin Fazla İade Miktarı Giremezsiniz">!');
						return false;
					}
				}
			</cfoutput>
			<cfoutput query="get_search_results_">
				if(eval("document.getElementById('is_check" + #invoice_row_id# + "')"))
				{
					if(eval("document.getElementById('is_check" + #invoice_row_id# + "')").checked)
						kontrol_ = 1;
				}
			</cfoutput>
			if(kontrol_ == 0)
			{
				alert('<cf_get_lang no="590.Hiçbir İade İşlemi Yapmadınız">!');
				return false;
			}
			return Unformatfields;
		}		
		function Unformatfields()
		{
			<cfoutput query="get_search_results_">
				if(eval("document.getElementById('is_check" + #invoice_row_id# + "')"))
				{
					eval("document.getElementById('amount" + #invoice_row_id# + "')").value = filterNum(eval("document.getElementById('amount" + #invoice_row_id# + "')").value);
				}
			</cfoutput>
			return true;
		}
	</script>
</cfif>
