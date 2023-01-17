<!--- Cek Transfer Standart Şablonu --->
<cfquery name="GET_MONEY_RATE" datasource="#dsn2#">
	SELECT
		*
	FROM
		VOUCHER_PAYROLL_MONEY
	WHERE
		ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
		IS_SELECTED=1
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isdefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfelseif isdefined("SESSION.PP.COMPANY")>	
	    COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfif> 
</cfquery>
<cfquery name="GET_ACTION_DETAIL" datasource="#dsn2#">
	SELECT * FROM VOUCHER_PAYROLL WHERE	ACTION_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_VOUCHER_HISTORY" datasource="#dsn2#">
    SELECT 
        COUNT(VOUCHER_ID) AS KAYIT 
    FROM
        VOUCHER_HISTORY
    WHERE
        PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_VOUCHER_DETAIL" datasource="#dsn2#">
	SELECT
		VOUCHER.CURRENCY_ID,*		
	FROM
		VOUCHER_HISTORY,
		VOUCHER
	WHERE 
		VOUCHER_HISTORY.PAYROLL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND 
		VOUCHER.VOUCHER_ID = VOUCHER_HISTORY.VOUCHER_ID
</cfquery>
<cfquery name="GET_TO_CASHES" datasource="#dsn2#">
	SELECT * FROM CASH ORDER BY CASH_ID
</cfquery>
<cfset list_birim = ''>
<cfset list_birim = ListDeleteDupLicates(valuelist(GET_VOUCHER_DETAIL.CURRENCY_ID,','))>
<cfset toplam_tutar = 0>
<br>
<cfoutput query="GET_VOUCHER_DETAIL">
	<cfif (currentrow eq 1) or (GET_VOUCHER_DETAIL.currency_id eq GET_VOUCHER_DETAIL.currency_id[currentrow-1])>
		<cfset toplam_tutar = toplam_tutar + VOUCHER_VALUE>
	<cfelse>
		<cfset toplam_tutar = 0>
	</cfif>
</cfoutput>
<table border="0" cellpadding="0" cellspacing="0" style="width:180mm;">
	<tr>
    	<td style="width:10mm;" rowspan="30">&nbsp;</td>
        <td style="height:15mm;">&nbsp;</td>
    </tr>
    <tr>
        <td style="height:6mm;" align="center" class="headbold">Senet Transfer Bordrosu</td>
    </tr>
    <tr><td colspan="5" style="height:10mm;">&nbsp;</td></tr>
    <tr>
    	<td>
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
        	<tr>
            	<td>
                	<table border="1" cellpadding="0" cellspacing="0" width="100%">
                       <tr>
                            <td style="height:8mm; width:25mm;">&nbsp;<strong>Kasasından:</strong></td>
                            <td style="width:75mm;">&nbsp;
								<cfoutput query="GET_TO_CASHES">
									<cfif cash_id eq get_action_detail.payroll_cash_id>#CASH_NAME#</cfif>
								</cfoutput>
                            </td>
                            <td style="width:20mm;">&nbsp;<strong>Tarih:</strong></td>
                            <td style="width:25mm;" colspan="2">&nbsp;
								<cfoutput>#dateformat(get_action_detail.PAYROLL_REVENUE_DATE,dateformat_style)#</cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td style="height:8mm; width:25mm;">&nbsp;<strong>Kasasına:</strong></td>
                            <td style="width:75mm;">&nbsp;
								<cfoutput query="GET_TO_CASHES">
									<cfif cash_id eq get_action_detail.transfer_cash_id>#CASH_NAME#</cfif>
								</cfoutput>
                            </td>
                            <td style="width:20mm;">&nbsp;<strong>İşlem Tipi:</strong></td>
                            <td colspan="2">&nbsp; 
								<cfif GET_ACTION_DETAIL.payroll_type eq 136>Senet Transfer İşlemi (Çıkış)</cfif>
                                <cfif GET_ACTION_DETAIL.payroll_type eq 137>Senet Transfer İşlemi (Giriş)</cfif>
                            </td>
                        </tr>
                        <tr>
                        	<td style="height:10mm;">&nbsp;<strong>Açıklama</strong></td>
                            <td colspan="4">&nbsp;<cfoutput>#get_action_detail.action_detail#</cfoutput></td>
                        </tr>
					</table>
                </td>
            </tr>
            <tr><td colspan="5" style="height:5mm;">&nbsp;</td></tr>
            <tr>
            	<td>
                	<table border="1" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td style="height:8mm;" align="center">&nbsp;<strong>Portföy No</strong></td>
                            <td align="center"><strong>Senet No</strong></td>
                            <td align="center"><strong>Borçlu</strong></td>
                            <td align="center"><strong>Ödeme Yeri</strong></td>
                            <td align="center"><strong>Tutar</strong></td>
                        </tr>
						<cfoutput query="GET_VOUCHER_DETAIL">
                        <tr>
                        	<td style="height:8mm;" align="center">#VOUCHER_PURSE_NO#</td>
                            <td align="center">&nbsp;#VOUCHER_NO#</td>
                            <td align="center">&nbsp;#DEBTOR_NAME#</td>
                            <td align="center">&nbsp;#VOUCHER_CITY#</td>
                            <td style="width:33m;" align="center">#TLFormat(VOUCHER_VALUE)# #CURRENCY_ID#</td>
                        </tr>
                    	</cfoutput>
                        <tr>
                            <td style="height:8mm;" align="center"><strong>Teslim Eden</strong></td>
                            <td colspan="2">&nbsp;</td>
                            <td align="center"><strong>Teslim Alan</strong></td>
                            <td align="center"><strong>Toplam</strong></td>
                        </tr>
                        <tr>
                            <td style="height:12mm;">&nbsp;</td>
                            <td colspan="2">&nbsp;</td>
                            <td>&nbsp;</td>
                            <td align="center"><cfoutput>#TLFormat(toplam_tutar)#</cfoutput><br></td>
                        </tr>
                        <tr>
                            <td colspan="5" style="height:8mm;">
                                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                    <tr>
                                        <td align="right"><strong>Senet Sayısı :</strong>&nbsp; &nbsp;<cfoutput>#GET_VOUCHER_HISTORY.KAYIT#</cfoutput>&nbsp; &nbsp; </td>
                                    </tr>
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

