<!--- STANDART TOPLU ODEME TALEBI 20121004 ST  --->
<cfquery name="Get_Company_Logo" datasource="#dsn#">
	SELECT 
    	EMAIL,
    	WEB,
        TEL,
        FAX,
        TAX_NO,
        TEL_CODE,
        ADDRESS,
        TAX_OFFICE,
       	COMPANY_NAME,
        ASSET_FILE_NAME3,      
        ASSET_FILE_NAME3_SERVER_ID
    FROM 
    	OUR_COMPANY 
    WHERE 
    	COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfquery name="GET_CLOSED_INVOICE" datasource="#DSN2#">
    SELECT DISTINCT
        CC.CLOSED_ID,
        CC.COMPANY_ID,
        CC.CONSUMER_ID,
        CC.EMPLOYEE_ID,
        CC.ACTION_DETAIL,
        CC.ACC_TYPE_ID,
        ISNULL(CC.PAYMENT_DIFF_AMOUNT_VALUE,0) PAYMENT_DIFF_AMOUNT_VALUE,
        ISNULL(CC.P_ORDER_DIFF_AMOUNT_VALUE,0) P_ORDER_DIFF_AMOUNT_VALUE,
        (SELECT SUM(ISNULL(CRR.OTHER_CLOSED_AMOUNT,0)) FROM CARI_CLOSED_ROW CRR WHERE CRR.CLOSED_ID = CC.CLOSED_ID) DEBT_AMOUNT_VALUE,
		ACC_TYPE_NAME,
        COM.FULLNAME,
        CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME,
        EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
        COM.MEMBER_CODE COM_MEMBERCODE,
        CON.MEMBER_CODE CON_MEMBERCODE,
        EMP.MEMBER_CODE EMP_MEMBERCODE,
        COM.TAXNO COM_TAXNO,
        CON.TAX_NO CON_TAXNO,
        CC.PAPER_DUE_DATE,
        CC.RECORD_DATE,
        CC.RECORD_EMP,
        CC.OTHER_MONEY,
        CC.PROCESS_STAGE,
        ISNULL(CC.IS_BANK_ORDER,0) IS_BANK_ORDER
    FROM
        CARI_CLOSED CC
        LEFT JOIN #dsn_alias#.COMPANY COM ON COM.COMPANY_ID = CC.COMPANY_ID
        LEFT JOIN #dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = CC.CONSUMER_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CC.EMPLOYEE_ID
        LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SAT ON SAT.ACC_TYPE_ID = CC.ACC_TYPE_ID
    WHERE 
        CC.CLOSED_ID IS NOT NULL
        AND CLOSED_ID IN(SELECT CCR.CLOSED_ID FROM CARI_CLOSED_ROW CCR WHERE CCR.CLOSED_ID = CC.CLOSED_ID AND CCR.ACTION_ID=0)
		<!--- yazışmalardan girildiğinde kendi kaydettiği talepleri görebilsin diye --->
		<cfif (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) or listfind(attributes.fuseaction,'correspondence','.')>
			AND CC.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_id) and len(attributes.member_name)>
			AND CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.consumer_id) and len(attributes.member_name)>
			AND CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		<cfelseif isdefined("attributes.member_name") and len(attributes.employee_id) and len(attributes.member_name)>
			AND CC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 1 and attributes.act_type eq 3>
			AND (CC.COMPANY_ID IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			OR CC.CONSUMER_ID IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1))
		<cfelseif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 0 and attributes.act_type eq 3>
			AND CC.COMPANY_ID NOT IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
			AND CC.CONSUMER_ID NOT IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
		</cfif>
		<cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
			AND
			(
				CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">)
				<cfif isnumeric(attributes.paper_no)>
					OR CC.CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_no#">
				</cfif>
				OR CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.ACTION_TABLE = 'INVOICE' AND CR.ACTION_ID IN(SELECT IR.INVOICE_ID FROM INVOICE_ROW IR WHERE IR.NAME_PRODUCT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">))
				OR CC.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">
			)
		</cfif>
		<cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
			AND IS_CLOSED = 1							
		<cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
			AND IS_DEMAND = 1
		<cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
			AND IS_ORDER = 1
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			AND CC.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.bank_order_status") and len(attributes.bank_order_status)>
			AND ISNULL(CC.IS_BANK_ORDER,0) = #attributes.bank_order_status#
		</cfif>
		<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		<cfelseif isdate(attributes.start_date)>
			AND CC.PAPER_DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		<cfelseif isdate(attributes.finish_date)>
			AND CC.PAPER_DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif isdate(attributes.act_start_date) and isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		<cfelseif isdate(attributes.act_start_date)>
			AND CC.PAPER_ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#">
		<cfelseif isdate(attributes.act_finish_date)>
			AND CC.PAPER_ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
		</cfif>
		<cfif isdate(attributes.record_start_date)  and not isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#">
		<cfelseif isdate(attributes.record_finish_date) and not isdate(attributes.record_start_date)>
			AND CC.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_finish_date)#">
		<cfelseif isdate(attributes.record_start_date) and isdate(attributes.record_finish_date)>
			AND CC.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add("d",1,attributes.record_finish_date)#">
		</cfif>
		<cfif attributes.act_type eq 3 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_CLOSED IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_CLOSED IS NULL
			</cfif>
		<cfelseif attributes.act_type eq 2 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
			<cfif attributes.closed_type_info eq 1>
				AND IS_ORDER IS NOT NULL
			<cfelseif attributes.closed_type_info eq 2>
				AND IS_ORDER IS NULL
			</cfif>
		</cfif>
		<cfif len(attributes.other_money)>
			AND OTHER_MONEY = '#attributes.other_money#'
		</cfif>
	UNION ALL
    SELECT DISTINCT
        CC.CLOSED_ID,
        CC.COMPANY_ID,
        CC.CONSUMER_ID,
        CC.EMPLOYEE_ID,
        CC.ACTION_DETAIL,
        CC.ACC_TYPE_ID,
        ISNULL(CC.PAYMENT_DIFF_AMOUNT_VALUE,0) PAYMENT_DIFF_AMOUNT_VALUE,
        ISNULL(CC.P_ORDER_DIFF_AMOUNT_VALUE,0) P_ORDER_DIFF_AMOUNT_VALUE,
        #dsn_alias#.IS_ZERO(ISNULL(CC.DEBT_AMOUNT_VALUE,0),ISNULL(CC.CLAIM_AMOUNT_VALUE,0)) DEBT_AMOUNT_VALUE,
        ACC_TYPE_NAME,
       	COM.FULLNAME,
		CON.CONSUMER_NAME+' '+CON.CONSUMER_SURNAME CONSUMER_NAME,
		EMP.EMPLOYEE_NAME+' '+EMP.EMPLOYEE_SURNAME EMPLOYEE_NAME,
        COM.MEMBER_CODE COM_MEMBERCODE,
        CON.MEMBER_CODE CON_MEMBERCODE,
        EMP.MEMBER_CODE EMP_MEMBERCODE,
        COM.TAXNO COM_TAXNO,
        CON.TAX_NO CON_TAXNO,
        CC.PAPER_DUE_DATE,
        CC.RECORD_DATE,
        CC.RECORD_EMP,
        CC.OTHER_MONEY,
        CC.PROCESS_STAGE,
        ISNULL(CC.IS_BANK_ORDER,0) IS_BANK_ORDER	
    FROM
        CARI_CLOSED CC
        LEFT JOIN #dsn_alias#.COMPANY COM ON COM.COMPANY_ID = CC.COMPANY_ID
        LEFT JOIN #dsn_alias#.CONSUMER CON ON CON.CONSUMER_ID = CC.CONSUMER_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON EMP.EMPLOYEE_ID = CC.EMPLOYEE_ID
        LEFT JOIN #dsn_alias#.SETUP_ACC_TYPE SAT ON SAT.ACC_TYPE_ID = CC.ACC_TYPE_ID
    WHERE 
        CC.CLOSED_ID IS NOT NULL
        AND CLOSED_ID NOT IN(SELECT CCR.CLOSED_ID FROM CARI_CLOSED_ROW CCR WHERE CCR.CLOSED_ID = CC.CLOSED_ID AND CCR.ACTION_ID=0)
    <cfif (isDefined("attributes.correspondence_info") and len(attributes.correspondence_info)) or listfind(attributes.fuseaction,'correspondence','.')>
        AND CC.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><!--- yazışmalardan girildiğinde kendi kaydettiği talepleri görebilsn diye --->
    </cfif>
    <cfif isdefined("attributes.member_name") and len(attributes.member_id) and len(attributes.member_name)>
        AND CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
    <cfelseif isdefined("attributes.member_name") and len(attributes.consumer_id) and len(attributes.member_name)>
        AND CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
    <cfelseif isdefined("attributes.member_name") and len(attributes.employee_id) and len(attributes.member_name)>
        AND CC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
    </cfif>
    <cfif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 1 and attributes.act_type eq 3>
        AND (CC.COMPANY_ID IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
        OR CC.CONSUMER_ID IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1))
    <cfelseif isdefined("attributes.bank_account_status") and len(attributes.bank_account_status) and attributes.bank_account_status eq 0 and attributes.act_type eq 3>
        AND CC.COMPANY_ID NOT IN (SELECT COMB.COMPANY_ID FROM #dsn_alias#.COMPANY_BANK COMB WHERE COMB.COMPANY_ACCOUNT_DEFAULT = 1)
        AND CC.CONSUMER_ID NOT IN (SELECT CONB.CONSUMER_ID FROM #dsn_alias#.CONSUMER_BANK CONB WHERE CONB.CONSUMER_ACCOUNT_DEFAULT = 1)
    </cfif>
    <cfif isdefined("attributes.bank_order_status") and len(attributes.bank_order_status)>
        AND ISNULL(CC.IS_BANK_ORDER,0) = #attributes.bank_order_status#
    </cfif>
    <cfif isdefined("attributes.paper_no") and len(attributes.paper_no)>
        AND
        (
            CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.PAPER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">)
            <cfif isnumeric(attributes.paper_no)>
                OR
                CC.CLOSED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paper_no#">
            </cfif>
            OR CC.CLOSED_ID IN (SELECT CLOSED_ID FROM CARI_CLOSED_ROW CCR,CARI_ROWS CR WHERE CCR.ACTION_ID = CR.ACTION_ID AND CCR.ACTION_TYPE_ID = CR.ACTION_TYPE_ID AND CR.ACTION_TABLE = 'INVOICE' AND CR.ACTION_ID IN(SELECT IR.INVOICE_ID FROM INVOICE_ROW IR WHERE IR.NAME_PRODUCT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">))
            OR CC.ACTION_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_no#%">
        )
    </cfif>
    <cfif attributes.act_type eq 1><!--- Kapama İşlemi İse --->
        AND IS_CLOSED = 1							
    <cfelseif attributes.act_type eq 2><!--- Ödeme talebi İse --->
        AND IS_DEMAND = 1
    <cfelseif attributes.act_type eq 3><!--- Ödeme emri İse --->
        AND IS_ORDER = 1
    </cfif>
    <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
        AND CC.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
    </cfif>
    <cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
        AND CC.PAPER_DUE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
    <cfelseif isdate(attributes.start_date)>
        AND CC.PAPER_DUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
    <cfelseif isdate(attributes.finish_date)>
        AND CC.PAPER_DUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
    </cfif>
    <cfif isdate(attributes.act_start_date) and isdate(attributes.act_finish_date)>
        AND CC.PAPER_ACTION_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
    <cfelseif isdate(attributes.act_start_date)>
        AND CC.PAPER_ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_start_date#">
    <cfelseif isdate(attributes.act_finish_date)>
        AND CC.PAPER_ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.act_finish_date#">
    </cfif>
    <cfif isdate(attributes.record_start_date)  and not isdate(attributes.record_finish_date)>
        AND CC.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#">
    <cfelseif isdate(attributes.record_finish_date) and not isdate(attributes.record_start_date)>
        AND CC.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_finish_date)#">
    <cfelseif isdate(attributes.record_start_date) and isdate(attributes.record_finish_date)>
        AND CC.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add("d",1,attributes.record_finish_date)#">
    </cfif>
    <cfif attributes.act_type eq 3 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
        <cfif attributes.closed_type_info eq 1>
            AND IS_CLOSED IS NOT NULL
        <cfelseif attributes.closed_type_info eq 2>
            AND IS_CLOSED IS NULL
        </cfif>
    <cfelseif attributes.act_type eq 2 and isdefined("attributes.closed_type_info") and len(attributes.closed_type_info)>
        <cfif attributes.closed_type_info eq 1>
            AND IS_ORDER IS NOT NULL
        <cfelseif attributes.closed_type_info eq 2>
            AND IS_ORDER IS NULL
        </cfif>
    </cfif>
    <cfif len(attributes.other_money)>
        AND OTHER_MONEY = '#attributes.other_money#'
    </cfif>
    ORDER BY CC.CLOSED_ID DESC
</cfquery><!--- <cfdump var="#GET_CLOSED_INVOICE#"> --->
<cfquery name="get_money_type" datasource="#dsn#">
	SELECT MONEY,RATE2 FROM SETUP_MONEY GROUP BY MONEY,RATE2
</cfquery>
<cfloop query="get_money_type">
	<cfset 'toplam_kapama#money#' = 0>
	<cfset 'toplam_talep#money#' = 0>
	<cfset 'toplam_emir#money#' = 0>
</cfloop>
<style>
	.bold{font-weight:bold;}
</style>
<table border="0" cellpadding="0" cellspacing="0" style="width:180mm;">
	<tr>
    	<td rowspan="20" style="width:10mm;">&nbsp;</td>
        <td style="height:10mm;">&nbsp;</td>
    </tr>
    <tr>
    	<td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
        	<tr>
            	<td>
                <cfif len(Get_Company_Logo.ASSET_FILE_NAME3)>
                <cf_get_server_file 
                    output_file="settings/#Get_Company_Logo.ASSET_FILE_NAME3#" 
                    output_server="#Get_Company_Logo.ASSET_FILE_NAME3_SERVER_ID#" 
                    output_type="5">
                </cfif>
                </td>
            </tr>
            <tr>
            	<td>
                <table>
                	<tr><td style="height:10mm;"><cf_get_lang no="Aşağıda bildirilen carilere ödemelerinin gerçekleştirilmek üzere gereğinin yapılmasının rica ederiz"></td></tr>
                </table>
                </td>
            </tr>
            <tr>
            	<td>
                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                	<tr class="bold">
                    	<td style="width:30mm;height:6mm;"><cf_get_lang no="1525.Üye Kodu"></td>
                        <td style="width:50mm;"><cf_get_lang_main no="246.Üye"> <cf_get_lang_main no="485.Adı"></td>
                        <td style="width:25mm;"><cf_get_lang_main no="340.Vergi No"></td>
                        <td style="width:25mm;"><cf_get_lang no="907.İşlem Dövizli Tutar"></td>
                        <td style="width:15mm;"><cf_get_lang_main no="77.Para Birimi"></td>
                    </tr>
                    <cfoutput query="GET_CLOSED_INVOICE">
                        
                        <tr>
                            <td style="height:6mm;">
								<cfif len(company_id)>
                                	#COM_MEMBERCODE#
                                <cfelseif len(consumer_id)>
                                	#CON_MEMBERCODE#
                                <cfelseif len(employee_id)>
                                	#EMP_MEMBERCODE#
                                </cfif>
                            </td>
                            <td>
                            <cfif len(company_id)>
								#FULLNAME#
							<cfelseif len(consumer_id)>
								#CONSUMER_NAME#
                            <cfelseif len(employee_id)>
								#EMPLOYEE_NAME#
                                <cfif len(acc_type_name)> - #ACC_TYPE_NAME# </cfif>
                            </cfif>
                            </td>
                            <td>
                            <cfif len(company_id)>
								#COM_TAXNO#
							<cfelseif len(consumer_id)>
                                #CON_TAXNO#
                            <cfelseif len(employee_id)>
                                &nbsp;
                            </cfif>
                            </td>
                            <td style="width:25mm;text-align:right;">
                            <table border="0" cellpadding="0" cellspacing="0" style="text-align:right;" style="width:25mm;">                            	
                            	<tr>
                                	<td style="width:20mm; text-align:right;">
                                    	<cfif attributes.act_type eq 1><!--- Kapama --->
                                        	#TLFormat(DEBT_AMOUNT_VALUE)#
                                        <cfelseif attributes.act_type eq 2><!--- Ödeme Talepleri --->
                                            #TLFormat(PAYMENT_DIFF_AMOUNT_VALUE)#
                                        <cfelse><!--- Ödeme Emirleri ---> 
                                        	#TLFormat(P_ORDER_DIFF_AMOUNT_VALUE)#
                                        </cfif>
                                    </td>
                                    <td>&nbsp;</td>
                                </tr>
                            </table>
                            </td>
                            <td style="text-align:center;">#OTHER_MONEY#</td>
							<cfset 'toplam_kapama#OTHER_MONEY#' = evaluate('toplam_kapama#OTHER_MONEY#') + DEBT_AMOUNT_VALUE>
                            <cfset 'toplam_talep#OTHER_MONEY#' = evaluate('toplam_talep#OTHER_MONEY#') + PAYMENT_DIFF_AMOUNT_VALUE>
                            <cfset 'toplam_emir#OTHER_MONEY#' = evaluate('toplam_emir#OTHER_MONEY#') + P_ORDER_DIFF_AMOUNT_VALUE>
                        </tr>
                    </cfoutput>
                    <tr><td style="height:5mm;">&nbsp;</td></tr>
                    <tr>
                    	<td colspan="3" style="height:6mm;text-align:right;" valign="top" class="bold"><cf_get_lang_main no="80.Toplam"> &nbsp;</td>                        
                       	<td colspan="2">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                        <cfif attributes.act_type eq 1><!--- Kapama --->
							<cfoutput query="get_money_type" group="money">
                            <cfif evaluate('toplam_kapama#money#') neq 0>
                                <tr>
                                    <td style="width:24mm;height:5mm;text-align:right;">#TLFormat(evaluate('toplam_kapama#money#'))# </td>
                                    <td style="width:3mm;">&nbsp;</td>
                                    <td style="text-align:center;">#money#</td>
                                </tr>
                             </cfif>
                            </cfoutput>
                        <cfelseif attributes.act_type eq 2><!--- Ödeme Talepleri --->
							<cfoutput query="get_money_type" group="money">
                            <cfif evaluate('toplam_talep#money#') neq 0>
                                <tr>
                                    <td style="width:24mm;height:5mm;text-align:right;">#TLFormat(evaluate('toplam_talep#money#'))# </td>
                                    <td style="width:3mm;">&nbsp;</td>
                                    <td style="text-align:center;">#money#</td>
                                </tr>
                            </cfif>
                            </cfoutput>
                        <cfelse><!--- Ödeme Emirleri --->
                        	<cfoutput query="get_money_type" group="money">
                            <cfif evaluate('toplam_emir#money#') neq 0>
                                <tr>
                                    <td style="width:24mm;height:5mm;text-align:right;">#TLFormat(evaluate('toplam_emir#money#'))# </td>
                                    <td style="width:3mm;">&nbsp;</td>
                                    <td style="text-align:center;">#money#</td>
                                </tr>
                            </cfif>
							</cfoutput>
                        </cfif>
                        </table>
                        </td>
                    </tr>
                </table>
                </td>
            </tr>
        </table>
        </td>
    </tr>
</table>
