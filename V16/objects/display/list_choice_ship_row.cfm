<!--- faturaya irsaliye seçme popupında belgenin urunlerini listeyerek seçim yapmak için kullanılıyor. --->
<cfsetting showdebugoutput="no">
<cfif not (isdefined("url.ship_id") and isnumeric(url.ship_id))>
	<script type="text/javascript">
		alert("İrsaliye Seçiniz!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif  isdefined("attributes.employee_id") and len(attributes.employee_id) and attributes.employee_id contains '_'>
	<cfset	attributes.employee_id = #ListGetAt(attributes.employee_id,1,'_')#>
</cfif>
<cfset action_url_str="">
<cfif isdefined("url.is_store")><!--- parametreler action sayfasına gonderiliyor, bu parametrelerle action sayfası yeniden list_choice_ship.cfm dosyasına yönlendiriliyor --->
	<cfset action_url_str = "#action_url_str#&is_store=#url.is_store#">
</cfif>
<cfif isdefined("attributes.ship_date_liste")>
	<cfset action_url_str = "#action_url_str#&ship_date_liste=#attributes.ship_date_liste#">
</cfif>
<cfif isdefined("attributes.ship_project_liste")>
	<cfset action_url_str = "#action_url_str#&ship_project_liste=#attributes.ship_project_liste#">
</cfif>
<cfif isdefined("url.from_ship")>
	<cfset action_url_str = "#action_url_str#&from_ship=#url.from_ship#">
</cfif>
<cfif isdefined('attributes.ship_period')>
	<cfset action_url_str = "#action_url_str#&ship_period=#attributes.ship_period#">
</cfif>
<cfif isdefined('attributes.ship_list_type')>
	<cfset action_url_str = "#action_url_str#&ship_list_type=#attributes.ship_list_type#">
</cfif>
<cfif isdefined('attributes.cat')>
	<cfset action_url_str = "#action_url_str#&cat=#attributes.cat#">
</cfif>
<cfif isdefined('attributes.stock_id')>
	<cfset action_url_str = "#action_url_str#&stock_id = #attributes.stock_id#">
</cfif>
<cfif isdefined('attributes.product_name')>
	<cfset action_url_str = "#action_url_str#&product_name=#attributes.product_name#">
</cfif>
<cfif isdefined('attributes.is_kesilmis')>
	<cfset action_url_str = "#action_url_str#&is_kesilmis=#attributes.is_kesilmis#">
</cfif>
<cfif isdefined('attributes.xml_show_spect')>
	<cfset action_url_str = "#action_url_str#&xml_show_spect=#attributes.xml_show_spect#">
</cfif>
<cfif isdefined('attributes.department_id')>
	<cfset action_url_str = "#action_url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined('attributes.keyword')>
	<cfset action_url_str = "#action_url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined('attributes.process_cat')>
	<cfset action_url_str = "#action_url_str#&process_cat=#attributes.process_cat#">
</cfif>
<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
	<cfset action_url_str = "#action_url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset action_url_str = "#action_url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined('attributes.employee_id') and len(attributes.employee_id)>
	<cfset action_url_str = "#action_url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif isdefined('attributes.sale_product')>
	<cfset action_url_str = "#action_url_str#&sale_product=#attributes.sale_product#">
</cfif>
<cfif isdefined('attributes.start_date')>
	<cfset action_url_str = "#action_url_str#&start_date=#attributes.start_date#">
</cfif>
<cfif isdefined('attributes.finish_date')>
	<cfset action_url_str = "#action_url_str#&finish_date=#attributes.finish_date#">
</cfif>
<cfif isdefined('attributes.id')>
	<cfset action_url_str = "#action_url_str#&id=#attributes.id#">
</cfif>
<cfif isdefined("attributes.is_store")>
	<cfset action_url_str = "#action_url_str#&is_store=#attributes.is_store#">
</cfif>
<cfset ship_period = listfirst(attributes.ship_period_,';')>
<cfset dsn2_ship = '#dsn#_#listlast(attributes.ship_period_,';')#_#session.ep.company_id#'>
<cfset dsn2_ship_alias = '#dsn#_#listlast(attributes.ship_period_,';')#_#session.ep.company_id#'>
<cfquery name="GET_SHIP_ROW_INFO_#attributes.form_crntrow#" datasource="#dsn2_ship#">
	SELECT
		#listfirst(attributes.ship_period,';')# PERIOD_ID,
		SHIP.SHIP_ID,
		SHIP.SHIP_NUMBER,
		SHIP.SHIP_TYPE,
		SHIP.SHIP_DATE,
		SHIP.COMPANY_ID,
		SHIP.CONSUMER_ID,
        SHIP.EMPLOYEE_ID,
		SR.SHIP_ROW_ID,
		SR.PRODUCT_ID,
		SR.STOCK_ID,
		ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
		SR.SPECT_VAR_NAME,
		SR.AMOUNT,
		S.STOCK_CODE,
		S.PRODUCT_NAME+S.PROPERTY AS PRODUCT_NAME,
		ISNULL(SR.WRK_ROW_ID,0) WRK_ROW_ID,
		SR.UNIT,
		SR.PRODUCT_NAME2,
		S.PRODUCT_CODE_2
	FROM
		SHIP,
		SHIP_ROW SR,
		#dsn3_alias#.STOCKS S
	WHERE
		SHIP.SHIP_ID=SR.SHIP_ID
		AND SR.STOCK_ID=S.STOCK_ID
		AND SHIP.SHIP_ID=#url.ship_id#
	ORDER BY
		SR.SHIP_ROW_ID DESC
</cfquery>
<cfset q_name="GET_SHIP_ROW_INFO_#attributes.form_crntrow#">
<cfif evaluate("#q_name#.recordcount")>
	<cfquery name="get_period_dsns" datasource="#dsn#">
		SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID =#session.ep.company_id# <!--- AND PERIOD_YEAR IN (#listlast(attributes.ship_period_,';')#,#listlast(attributes.ship_period_,';')+1#) konsinye irsaliyeleri daha sonraki tüm dönemlere cekilebiliyor, konsinye devir olmadıgından --->
	</cfquery>
	<cfquery name="get_all_ship_amount" datasource="#dsn#">
		SELECT
			SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
			SUM(A1.INVOICE_AMOUNT) AS INVOICE_AMOUNT,
			A1.SHIP_PERIOD,
			<!--- A1.DEFAULT_PERIOD, --->
			A1.STOCK_ID,
			A1.SPECT_VAR_ID,
			A1.SHIP_WRK_ROW_ID
		FROM
		(
		<cfloop query="get_period_dsns">
			SELECT
				SUM(SHIP_AMOUNT) AS SHIP_AMOUNT,
				SUM(INVOICE_AMOUNT) AS INVOICE_AMOUNT,
				SHIP_PERIOD,
				<!--- #get_period_dsns.period_id# DEFAULT_PERIOD, --->
				STOCK_ID,
				ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = GSRR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
				ISNULL(SHIP_WRK_ROW_ID,0) AS SHIP_WRK_ROW_ID
			FROM
				#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.GET_SHIP_ROW_RELATION GSRR
			WHERE
				SHIP_ID=#evaluate("#q_name#.SHIP_ID")#
				AND SHIP_PERIOD = #get_period_dsns.period_id#
				<!--- AND SHIP_PERIOD=#ship_period# --->
			GROUP BY
				SHIP_PERIOD,
				STOCK_ID,
				SPECT_VAR_ID,
				SHIP_WRK_ROW_ID
			<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
		</cfloop> ) AS A1
			GROUP BY
				A1.SHIP_PERIOD,
				<!--- A1.DEFAULT_PERIOD, --->
				A1.STOCK_ID,
				A1.SPECT_VAR_ID,
				A1.SHIP_WRK_ROW_ID
			ORDER BY STOCK_ID
	</cfquery>
	<cfscript>
		for(inv_k=1; inv_k lte get_all_ship_amount.recordcount; inv_k=inv_k+1)
		{
			'used_ship_amount_#get_all_ship_amount.SHIP_PERIOD[inv_k]#_#get_all_ship_amount.STOCK_ID[inv_k]#_#get_all_ship_amount.SPECT_VAR_ID[inv_k]#_#get_all_ship_amount.SHIP_WRK_ROW_ID[inv_k]#' = get_all_ship_amount.SHIP_AMOUNT[inv_k];
			'used_invoice_amount_#get_all_ship_amount.SHIP_PERIOD[inv_k]#_#get_all_ship_amount.STOCK_ID[inv_k]#_#get_all_ship_amount.SPECT_VAR_ID[inv_k]#_#get_all_ship_amount.SHIP_WRK_ROW_ID[inv_k]#' = get_all_ship_amount.INVOICE_AMOUNT[inv_k];
			//writeoutput("#get_all_ship_amount.STOCK_ID[inv_k]#_#get_all_ship_amount.SPECT_VAR_ID[inv_k]#_#get_all_ship_amount.SHIP_WRK_ROW_ID[inv_k]#<br/>");
		}
	</cfscript>
<cfelse>
	<cfset get_all_ship_amount.recordcount=0>
</cfif>
<cfset i = 1>
<cfoutput query="#q_name#" group ="unit">
	<cfset units[i] = replace("#unit#","/","") >
	<cfset "total_amount_#units[i]#" = 0 >
	<cfset i = i +1 >
</cfoutput>
<form <cfoutput>name="ship_detail_#attributes.form_crntrow#" id="ship_detail_#attributes.form_crntrow#"</cfoutput> action="<cfoutput>#request.self#?fuseaction=objects.popup_add_ship#action_url_str#</cfoutput>" method="post">
    <table cellpadding="1" cellspacing="1" border="0" width="100%">
        <tr height="25">
            <td class="formbold" colspan="9"><cfoutput>#evaluate("#q_name#.SHIP_NUMBER")#</cfoutput><cf_get_lang dictionary_id="59166.No'lu"> <cf_get_lang dictionary_id="57773.İrsaliye"> <cf_get_lang dictionary_id="57564.Ürünleri"> </td>
        </tr>
        <tr class="color-list">
            <td class="txtboldblue"><cf_get_lang dictionary_id="57518.Stok Kodu"></td>
            <cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td class="txtboldblue"><cf_get_lang dictionary_id="57657.Ürün"> <cf_get_lang dictionary_id="57979.Özel"> <cf_get_lang dictionary_id="49089.Kodu"></td></cfif>          
            <td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></td>  
            <cfif isdefined("attributes.xml_show_spect") and attributes.xml_show_spect eq 1><td class="txtboldblue"><cf_get_lang dictionary_id='57647.Spec'></td></cfif>      
            <cfif isdefined("attributes.xml_show_product_name2") and attributes.xml_show_product_name2 eq 1><td class="txtboldblue"><cf_get_lang dictionary_id='57629.Açıklama'> 2</td></cfif>      
            <td width="55" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="32724.İrsaliye Miktarı"></td>
            <td width="55" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="39235.Faturalanan Miktar"></td>
            <td width="55" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="34901.İade Miktarı"></td>
            <td width="55" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id="58444.Kalan"></td>
            <td width="20"></td>
        </tr>
        <input type="hidden" name="ship_list_type" id="ship_list_type" value="1"><!--- urun bazında--->
        <cfoutput>
        <input type="hidden" name="related_ship_" id="related_ship_" value="#url.ship_id#">
        <input type="hidden" name="invoice_date" id="invoice_date" value="#url.inv_date#">
        <input type="hidden" name="ship_period" id="ship_period" value="#attributes.ship_period_#">
        </cfoutput>
        <cfif evaluate("#q_name#.recordcount")>
			<cfset total_shelf_amount=0>
            <cfoutput query="#q_name#">
                <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=AMOUNT>
                <tr class="color-row">
                    <td>#STOCK_CODE#</td>	
                    <cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td>#PRODUCT_CODE_2#</td></cfif>	
                    <td>#PRODUCT_NAME#</td>
                    <cfif isdefined("attributes.xml_show_spect") and attributes.xml_show_spect eq 1><td>#spect_var_name#</td></cfif>      
                    <cfif isdefined("attributes.xml_show_product_name2") and attributes.xml_show_product_name2 eq 1><td>#product_name2#</td></cfif>
                    <td width="55" style="text-align:right;">#TLFormat(AMOUNT)#</td>
                    <td width="55" style="text-align:right;">
                        <cfif not (isdefined('is_finish_inv_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and evaluate('is_finish_inv_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') eq 1)>
                            <cfif (isdefined('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and len(evaluate('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'))) or (isdefined('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_0') and len(evaluate('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_0')))>
                                <cfif (isdefined('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and len(evaluate('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')))>
                                    <cfset temp_a=evaluate('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                <cfelse>
                                    <cfset temp_a=evaluate('used_invoice_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_0')>
                                </cfif>
                                <cfif temp_a gte evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    #TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'))#
                                    <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
                                        <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    <cfelse>
                                        <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')-temp_a>
                                    </cfif>
                                <cfelseif temp_a lt evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    #TLFormat(temp_a)#
                                    <cfif isdefined("attributes.process_type") and len(attributes.process_type)>
                                        <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    <cfelse>
                                        <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')-temp_a>
                                    </cfif>
                                    <cfset 'is_finish_inv_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=1>
                                </cfif>
                            </cfif>
                        </cfif>
                    </td>
                    <td width="55" style="text-align:right;">
                        <cfif not (isdefined('is_finish_ship_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and evaluate('is_finish_ship_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') eq 1) and (isdefined('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') gt 0)>
                            <cfif (isdefined('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and len(evaluate('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'))) or isdefined('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_0') and len(evaluate('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_0'))>
                                <cfquery name="tempB" dbtype="query">
                                	SELECT SUM(SHIP_AMOUNT) AS SHIP_AMOUNT FROM get_all_ship_amount WHERE STOCK_ID = #STOCK_ID# AND SHIP_PERIOD = #PERIOD_ID# AND SPECT_VAR_ID = #SPECT_VAR_ID# AND SHIP_WRK_ROW_ID = '#WRK_ROW_ID#'
                                </cfquery>
								
								<!---<cfset temp_b = 0>
                                <cfif (isdefined('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') and len(evaluate('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')))>
                                    <cfset temp_b=temp_b+evaluate('used_ship_amount_#PERIOD_ID#_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                </cfif>--->
                                <cfset temp_b = tempB.SHIP_AMOUNT>
                                <cfif temp_b gte evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    #TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'))#
                                    <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')-temp_b>
                                <cfelseif temp_b lt evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')>
                                    #TLFormat(temp_b)#
                                    <cfset 'is_finish_ship_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=1>
                                    <cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')-temp_b>
                                </cfif>
                            </cfif>
                        </cfif>
                    </td>
					<td nowrap style="text-align:right;">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz'></cfsavecontent>
						<input type="text" name="ship_add_amount_#SHIP_ID#_#SHIP_ROW_ID#" id="ship_add_amount_#SHIP_ID#_#SHIP_ROW_ID#" 
						onBlur="if(filterNum(this.value,4)=='' || filterNum(this.value,4)==0)this.value=1;if(filterNum(this.value,4)>
						 #evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')#)
						 {alert('Kalan Miktar #evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#')#\'dan Fazla Olmamalıdır!');
						 this.value=#TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'))#;}" 
						 onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="moneybox" 
						 value="<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') gt 0>
							#TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#'),4)#<cfelse>#TLFormat(0)#</cfif>" range="0,#AMOUNT#" style="width:100%" message="<cfoutput>#message#</cfoutput>">
							<cfset 'total_amount_#replace("#unit#","/","")#' = evaluate('total_amount_#replace("#unit#","/","")#') + AMOUNT>
                    </td>
					<td width="20" align="center" nowrap>
                        <input type="checkbox" name="company_ship" id="company_ship" value="#SHIP_ROW_ID#;<cfif len(COMPANY_ID) and COMPANY_ID neq 0>#COMPANY_ID#<cfelseif len(CONSUMER_ID) and CONSUMER_ID neq 0>#CONSUMER_ID#<cfelseif len(EMPLOYEE_ID) and EMPLOYEE_ID neq 0>#EMPLOYEE_ID#</cfif>" <cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#_#WRK_ROW_ID#') lte 0>disabled</cfif>>
                    </td>
                </tr>
            </cfoutput>
            <tr class="color-list">
                <cfset colspan_ = 2>
                <cfif isdefined("attributes.x_show_product_code_2") and attributes.x_show_product_code_2 eq 1>
                    <cfset colspan_ = colspan_ + 1>
                </cfif>
                <cfif isdefined("attributes.xml_show_product_name2") and attributes.xml_show_product_name2 eq 1>
                    <cfset colspan_ = colspan_ + 1>
                </cfif>
                <td class="txtboldblue" style="text-align:right;" colspan="<cfoutput>#colspan_#</cfoutput>" valign="top"><cf_get_lang dictionary_id="32823.Toplam Miktar"></td>
				<td style="text-align:right" valign="top">
					<cfset i = 1>
					<cfoutput query="#q_name#" group ="unit">
						#evaluate('total_amount_#units[i]#')# #unit# <br>
						<cfset i = i + 1>
					</cfoutput>
                </td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
				<td colspan="5" style="text-align:right;">
					<input type="submit" onClick="<cfoutput>control_ship_amounts('#attributes.form_crntrow#');</cfoutput>" value="<cfoutput><cf_get_lang dictionary_id='44630.Ekle'></cfoutput>">
                </td>
			</tr>			
        </cfif>
	</table>
</form>
<script type="text/javascript">
function control_ship_amounts(form_row_no)
{
	var ship_= eval('document.ship_detail_'+form_row_no+'.related_ship_').value;
	if(eval('document.ship_detail_'+form_row_no+'.company_ship')!= undefined)
		var checked_item_= eval('document.ship_detail_'+form_row_no+'.company_ship');
	/*else if(eval('document.ship_detail_'+form_row_no+'.consumer_ship') != undefined)
		var checked_item_= eval('document.ship_detail_'+form_row_no+'.consumer_ship');*/
	
	if(checked_item_.length != undefined)
	{
		for(var xx=0; xx < checked_item_.length; xx++)
		{
			if(checked_item_[xx].checked)
			{
				checked_ship_row_id_ = list_getat(checked_item_[xx].value,1,';');
				eval('document.ship_detail_'+form_row_no+'.ship_add_amount_'+ship_+'_'+checked_ship_row_id_).value=filterNum(eval('document.ship_detail_'+form_row_no+'.ship_add_amount_'+ship_+'_'+checked_ship_row_id_).value,4);
			}
		}
	}
	else if(checked_item_.checked)
	{
		checked_ship_row_id_ = list_getat(checked_item_.value,1,';');
		eval('document.ship_detail_'+form_row_no+'.ship_add_amount_'+ship_+'_'+checked_ship_row_id_).value=filterNum(eval('document.ship_detail_'+form_row_no+'.ship_add_amount_'+ship_+'_'+checked_ship_row_id_).value,4);
	}
	return true;
}
</script>
