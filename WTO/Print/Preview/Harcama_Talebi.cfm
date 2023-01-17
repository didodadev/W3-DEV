<!--- Harcama Talebi FBS 20080604 --->
<cfquery name="Our_Company" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		COMPANY_NAME,
		TEL_CODE,
		TEL,TEL2,
		TEL3,
		TEL4,
		FAX,
		TAX_OFFICE,
		TAX_NO,
		ADDRESS,
		WEB,
		EMAIL
	FROM 
	    OUR_COMPANY 
	WHERE 
	   <cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.PP.COMPANY#">
	</cfif>
</cfquery>
<cfquery name="Get_Money" datasource="#dsn2#">
	SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfif not Get_Money.RecordCount>
	<cfquery name="Get_Money" datasource="#dsn#">
		SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
	</cfquery>
</cfif>

<!--- Harcama talebi --->
<cfquery name="Get_Requests" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS
    	LEFT JOIN #dsn_alias#.SETUP_DOCUMENT_TYPE ON EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE=SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID
    	WHERE EXPENSE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<!--- Ödeme Yöntemi --->
<cfif isdefined("Get_Requests.paymethod_id") and len(Get_Requests.paymethod_id)>
    <cfquery name="Get_Paymethod" datasource="#dsn#">
        SELECT * FROM SETUP_PAYMETHOD  WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Requests.paymethod_id#"> ORDER BY PAYMETHOD
    </cfquery>
</cfif>

<!--- Talep Satirlari --->
<cfquery name="Get_Requests_rows" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<!--- Bagli irsaliyeler --->
<cfquery name="Get_Kontrol" datasource="#dsn2#">
	SELECT REQUEST_ID,PAPER_NO FROM EXPENSE_ITEM_PLANS WHERE REQUEST_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>

<cfif len(Get_Requests.emp_id) eq 0 >
	<cfoutput>Kayıt Yok</cfoutput>
	<cfabort/>
</cfif>
<cfquery name="Get_Upper_Position" datasource="#dsn#">
	SELECT UPPER_POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Requests.emp_id#"> AND IS_MASTER = 1
</cfquery>

<cfif len(Get_Upper_Position.UPPER_POSITION_CODE)>
    <cfquery name="Get_Chief1_Name" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #get_upper_position.UPPER_POSITION_CODE#
    </cfquery>
</cfif>
<cfif Get_Requests.RecordCount eq 0>
	<cfset sayfa_sayisi = 1>
<cfelse>
	<cfset sayfa_sayisi = ceiling(Get_Requests.RecordCount / 30)>
</cfif>
<cfset satir_start = 1>
<cfset satir_end = 30>

<cfloop query="Get_Requests_rows">
	<cfset 'toplam_kdv#kdv_rate#' = 0>
</cfloop>


<style>
	.box_yazi {border : 0px none #e1ddda;border-width : 0px 0px 0px 0px;border-bottom-width : 0px;background-color : transparent;background-color:#FFFFFF;text-align: left;font:Arial, Helvetica, sans-serif;font-size:12px;} 
	table,td{font-size:11px;font-family:Arial, Helvetica, sans-serif;}
</style>

<cfloop from="1" to="#sayfa_sayisi#" index="j">
	<table border="0" cellspacing="0" cellpadding="0" style="width:200mm;height:287mm;">
		<tr>
			<td style="width:20mm;" rowspan="40">&nbsp;</td>
			<td style="height:10mm;">&nbsp;</td>
		</tr>
		<tr valign="top">
			<td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" style="width:180mm;">
                    <tr height="16">
                        <cfoutput query="our_company">
                            <td style="text-align:left" width="60%"><cf_get_server_file output_file="settings/#asset_file_name3#" output_server="#asset_file_name3_server_id#" output_type="5"></td>
                            <td style="text-align:right">
                                <b>#company_name#</b><br/>
                                #address#<br/>
                                <cf_get_lang_main no='87.Tel'>: #tel_code# #tel#<br/>
                                <cf_get_lang_main no='76.Fax'>: #tel_code# #fax#<br/>
                                #web#&nbsp;&nbsp;#email#
                            </td>
                        </cfoutput>
                    </tr>
                    <tr><td colspan="2" style="height:10mm;">&nbsp;</td></tr>
                </table>
                <table cellpadding="3" cellspacing="0" border="0" style="width:180mm;">
                    <cfoutput>
                    <tr>
                        <td style="height:15mm; text-align:left"><big><strong><cf_get_lang_main no='1575.Harcama Talebi'></strong></big></td>
                        <td style="width:45mm; text-align:left"><b><cf_get_lang_main no='75.No'></b> : #Get_Requests.paper_no#</td>
                        <td style="width:45mm; text-align:right"><b><cf_get_lang_main no='330.Tarih'></b> : #DateFormat(Get_Requests.expense_date,dateformat_style)#</td>
                    </tr>
                    <tr><td colspan="3" style="height:8mm;">&nbsp;</td></tr>
                    </cfoutput>
                </table>
                <table border="0" cellspacing="0" cellpadding="2"  style="width:180mm;">
                    <cfoutput>
                    <tr style="height:7mm;">
                        <td style="width:30mm;"><strong><cf_get_lang_main no='1461.Satıcı'></strong></td>
                        <td style="width:70mm;">: <cfif len(Get_Requests.sales_company_id)>#get_par_info(Get_Requests.sales_company_id,1,1,0)#</cfif></td>
                        <td style="width:30mm;"><strong><cf_get_lang dictionary_id='51313.Ödeme Yapan'></strong></td>
                        <td style="width:70mm;">: #get_emp_info(Get_Requests.emp_id,0,0)#</td>
                    </tr>
                    <tr style="height:7mm;">
                        <td style="width:30mm;"><strong><cf_get_lang_main no='166.Yetkili'></strong></td>
                        <td>: <cfif len(Get_Requests.sales_partner_id)>#get_par_info(Get_Requests.sales_partner_id,0,-1,0)#<cfelseif len(Get_Requests.sales_consumer_id)>#get_cons_info(Get_Requests.sales_consumer_id,0,0)#</cfif></td>
                        <td style="width:30mm;"><strong><cf_get_lang_main no='1104.Ödeme Yöntemi'></strong></td>
                        <td>: <cfif len(Get_Requests.paymethod_id)> #get_paymethod.paymethod#</cfif></td>
                    </tr>
                    <tr style="height:7mm;">
                        <td style="width:30mm;"><strong><cf_get_lang_main no='87.Telefon'></strong></td>
                        <td>: &nbsp;</td>
                        <td style="width:30mm;"><strong><cf_get_lang_main no='1166.Belge Türü'></strong></td>
                        <td>: #Get_Requests.document_type_name#</td>
                    </tr>
                    <tr style="height:7mm;">
                        <td style="width:30mm;"><strong><cf_get_lang_main no='217.Açıklama'></strong></td>
                        <td colspan="3" style="width:70mm;">: #Get_Requests.detail#</td>
                    </tr>
                    </cfoutput>
                </table>
			</td>
		</tr>
		<tr style="height:6mm;"><td>&nbsp;</td></tr>
		<tr valign="top">
			<td>
			<table border="0" cellspacing="0" cellpadding="2"  style="width:180mm;">
				<tr style="height:7mm; text-align:left">
					<td><strong><cf_get_lang_main no='217.Açıklama'></strong></td>
					<td><strong><cf_get_lang_main no='1048.Masraf Merkezi'></strong></td>
					<td><strong><cf_get_lang_main no='1139.Gider Kalemi'></strong></td>
					<td><strong><cf_get_lang_main no='867.Harcama Yapan'></strong></td>
					<td style="text-align:right"><strong><cf_get_lang_main no='80.Toplam'></strong></td>
					<td style="text-align:right"><strong><cf_get_lang_main no='644.Dövizli Tutar'></strong></td>
				</tr>
				<cfoutput query="Get_Requests_rows">
	                <!--- Masraf Merkezi --->
					<cfquery name="get_expense_center" datasource="#dsn2#">
						SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_center_id#">
					</cfquery>
                    
                    <!--- Gider kalemi --->
					<cfquery name="get_expense_item" datasource="#dsn2#">
						SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#expense_item_id#">
					</cfquery>
					<tr style="height:6mm;">
						<td style="width:20mm;">#left(detail,50)#</td>
						<td style="width:30mm;">#left(get_expense_center.expense,50)#</td>
						<td style="width:30mm;">#left(get_expense_item.expense_item_name,50)#</td>
						<td style="width:30mm;">
                        <cfif Get_Requests_Rows.Member_Type eq 'employee'>
                        	#get_emp_info(Get_Requests_rows.company_partner_id,0,0)#
                        <cfelseif Get_Requests_Rows.Member_Type eq 'partner'>
                        	#get_par_info(Get_Requests_Rows.Company_Partner_Id,0,0,0)#
                        <cfelseif Get_Requests_Rows.Member_Type eq 'consumer'>
                        	#get_cons_info(Get_Requests_Rows.Company_Partner_Id,1,0)#
                        <cfelse>&nbsp;
                        </cfif>
                        </td>
						<td style="width:25mm; text-align:right">#TLFormat(total_amount)# #money_currency_id#</td>
						<td style="width:25mm; text-align:right">#TLFormat(other_money_value)#</td>
                        <cfset 'toplam_kdv#KDV_RATE#' = evaluate('toplam_kdv#KDV_RATE#') + AMOUNT_KDV>
					</tr>
				</cfoutput>
			</table>
			</td>
		</tr>
		<tr style="height:6mm;"><td>&nbsp;</td></tr>
		<tr valign="top">
			<td style="width:180mm; text-align:right">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td style="text-align:left">
                    <table border="0" cellpadding="0" cellspacing="0">
                        <cfoutput>
                            <tr style="height:7mm;">
                                <td style="width:25mm;"><strong><cf_get_lang dictionary_id='51081.Talep Eden'> :</strong></td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr style="height:7mm;">
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr style="height:7mm;">
                                <td style="width:25mm;"><strong><cf_get_lang_main no='10.Notlar'> :</strong></td>
                                <td><input type="text" class="box_yazi" style="width:17mm; font-size:12px;"/></td>
                            </tr>
                        </cfoutput>
                    </table>
					</td>
					<td style="text-align:right">
						<table border="0" cellspacing="0" cellpadding="2">
							<tr style="height:7mm;">
								<td style="width:20mm;"><strong><cf_get_lang_main no='80.Toplam'></strong></td>
								<td style="width:30mm; text-align:right"><strong><cfoutput>#TLFormat(Get_Requests.other_money_amount)#<!---  #Get_Requests.other_money# ---></cfoutput></strong></td>
							</tr>
							<cfoutput query="Get_Requests_rows" group="kdv_rate">
								<cfif evaluate('toplam_kdv#kdv_rate#') gt 0>
                                    <tr>
                                        <td style="height:6mm;"><strong><cf_get_lang_main no='227.KDV'> % #KDV_RATE#</strong></td>
                                        <td style="text-align:right"><strong>#Tlformat(evaluate('toplam_kdv#KDV_RATE#'))#</strong></td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                            <tr style="height:7mm;">
								<td style="width:20mm;"><strong><cf_get_lang_main no='231.Kdv Toplam'></strong></td>
								<td style="width:30mm; text-align:right"><strong><cfoutput>#TLFormat(Get_Requests.other_money_kdv)# <!--- #Get_Requests.other_money# ---></cfoutput></strong></td>
							</tr>
							<tr style="height:7mm;">
								<td style="width:20mm;"><strong><cf_get_lang_main no='268.Genel Toplam'></strong></td>
								<td style="width:30mm; text-align:right"><strong><cfoutput>#TLFormat(Get_Requests.other_money_net_total)#<!---  #Get_Requests.other_money# ---></cfoutput></strong></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</td>
		</tr>
        <tr>
        	<td>
			<table border="0" cellpadding="0" cellspacing="0"  style="width:180mm;">
            	<tr><td colspan="3" style="height:5mm;">&nbsp;</td></tr>
                <tr style="height:7mm;">
                	<td><strong><cf_Get_lang_main no='88.ONAYLAR'></strong></td>
                </tr>
                <tr style="height:7mm;">
					<td style="width:50mm;"><strong><cf_get_lang_main no='1714.YÖNETİCİ'> <cf_get_lang_main no='88.ONAYI'></strong></td>
                    <td style="width:50mm;"><strong><cf_get_lang_main no='1714.YÖNETİCİ'> <cf_get_lang_main no='88.ONAYI'></strong></td>
				</tr>
				<cfif len (get_upper_position.UPPER_POSITION_CODE)>
				<tr style="height:7mm;">
					<td><cfoutput>#get_chief1_name.EMPLOYEE_NAME# #get_chief1_name.EMPLOYEE_SURNAME#</cfoutput></td>
                    <td>&nbsp;</td>
				</tr>
				</cfif>	
            </table>
            </td>
            <td style="width:10mm;"></td>
        </tr>
		<tr height="100%"><td>&nbsp;</td></tr>
	</table>
<cfset satir_start = satir_start + 30>
<cfset satir_end = satir_start + 29>
</cfloop>
