<!--- Standart Muhasebe Fisi --->
<cf_get_lang_set module_name="account"><!--- sayfanin en altinda kapanisi var --->
<cfset total_a=0>
<cfset total_b=0>
<cfquery name="Get_Card_Rows" datasource="#DSN2#">
	SELECT
		ACR.BA,
		ACR.DETAIL,
		ACR.ACCOUNT_ID,
		ACR.AMOUNT,
		ACR.AMOUNT_CURRENCY,
		ACR.AMOUNT_2,
		ACR.AMOUNT_CURRENCY_2,
		ISNULL(ACR.OTHER_AMOUNT,ACR.AMOUNT) OTHER_AMOUNT,
		ISNULL(ACR.OTHER_CURRENCY,ACR.AMOUNT_CURRENCY) OTHER_CURRENCY,
		AC.ACTION_DATE,
		AC.BILL_NO,
		AC.CARD_DETAIL,
		AC.CARD_TYPE,
		AC.CARD_TYPE_NO,
		AC.IS_COMPOUND,
		AC.CARD_ID,
		AC.IS_OTHER_CURRENCY,
		AC.RECORD_EMP,
		AP.ACCOUNT_NAME,
        ACDT.DETAIL DOCUMENT_TYPE,
        ACPT.PAYMENT_TYPE
	FROM
		ACCOUNT_CARD_ROWS ACR,
		ACCOUNT_CARD AC
        	LEFT JOIN #dsn_alias#.ACCOUNT_CARD_DOCUMENT_TYPES ACDT ON ACDT.DOCUMENT_TYPE_ID = AC.CARD_DOCUMENT_TYPE
            LEFT JOIN #dsn_alias#.ACCOUNT_CARD_PAYMENT_TYPES ACPT ON ACPT.PAYMENT_TYPE_ID = AC.CARD_PAYMENT_METHOD,
		ACCOUNT_PLAN AP
	WHERE
	<cfif (isdefined("attributes.action_type") and len(attributes.action_type) and attributes.action_type neq 0) and (isdefined("attributes.action_id") and len(attributes.action_id))>
        AC.ACTION_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
		AC.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
        <cfif isdefined("attributes.card_id") and len(attributes.card_id)>
            AC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.card_id#"> AND
        </cfif>
    <cfelseif isDefined("attributes.action_id") and Len(attributes.action_id)>
		AC.CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
    <cfelse>
   		1 = 0 AND
    </cfif>	
		ACR.CARD_ID = AC.CARD_ID AND
		ACR.ACCOUNT_ID = AP.ACCOUNT_CODE
	ORDER BY 
		BA ASC,AMOUNT DESC		
</cfquery>
<cfif get_card_rows.is_other_currency eq 1>
    <cfquery name="Get_Other_Money_Totals" dbtype="query">
        SELECT
            SUM(OTHER_AMOUNT) OTHER_AMOUNT_TOPLAM,
            OTHER_CURRENCY,
            BA
        FROM
            GET_CARD_ROWS
        WHERE
            CARD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Card_Rows.CARD_ID#">
        GROUP BY
            OTHER_CURRENCY,
            BA
        ORDER BY
            BA
    </cfquery>
</cfif>
<cfquery name="COMPANY_INFO" datasource="#DSN#">
	SELECT COMPANY_NAME, COMP_ID FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset row_ = 25>
<cfset rowStart = 1>
<cfset rowEnd 	= row_>
<cfset pageCount = Ceiling( #Get_Card_Rows.recordCount# / rowEnd ) >
<table style="min-height:257mm;" class="book" align="center">
    <style>
	
	.book{
		margin: 10mm auto;
		}
    .page {
        width: 210mm;
        background: white;
	}
    .subpage {  
		display:inline-block;
		width: 170mm;
		min-height:257mm;
		max-height:287mm;
		padding-top:10mm;
	}
    
    @page {
        size: A4;
        margin: 0;
    }
    @media print {
        .page {
            margin: 0;
            border: initial;
            border-radius: initial;
            width: initial;
            min-height: initial;
            box-shadow: initial;
            background: initial;
            page-break-after: always;
        }
    }
	</style>
 	<cfloop index="i" from="1" to="#pageCount#">
        <tr class="page">		
        	<td class="subpage" style="text-align:center">
            	<table border="0" cellpadding="0" cellspacing="0" align="center">
                    <tr>
                        <td valign="top" align="center">
                            <table border="0" width="100%" align="center">
                                <cfoutput>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td style="text-align:center" class="headbold" colspan="3">&nbsp;</td>
                                    <td style="text-align:right">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="width:20mm;"><strong><cf_get_lang_main no='1195.FİRMA'> <cf_get_lang_main no='485.ADI'></strong></td>
                                    <td colspan="3" style="width:150mm;"><strong>: &nbsp;#company_info.company_name#</strong></td>
                                    <td style="text-align:right"><strong>#dateformat(get_card_rows.action_date,dateformat_style)#</strong></td>
                                </tr>
                                <tr>
                                    <td style="width:20mm;"><strong><cf_get_lang_main no='534.FİŞ NO'></strong></td>
                                    <td colspan="4"><strong>: &nbsp;#get_card_rows.card_type_no#</strong></td>
                                </tr>
                                <tr>
                                    <td style="width:20mm;"><strong><cf_get_lang no='86.FİŞ TÜRÜ'></strong></td>
                                    <td colspan="4">
                                    <cfif Get_Card_Rows.card_type eq 10>
                                      <strong>: &nbsp;<cf_get_lang_main no='1344.Açılış Fişi'></strong>
                                    <cfelseif Get_Card_Rows.card_type eq 11>
                                      <strong>: &nbsp;<cf_get_lang_main no='1432.Tahsil Fişi'></strong>
                                    <cfelseif Get_Card_Rows.card_type eq 12>
                                      <strong>: &nbsp;<cf_get_lang_main no='1542.Tediye Fişi'></strong>
                                    <cfelseif Get_Card_Rows.card_type eq 13>
                                      <strong>: &nbsp;<cf_get_lang_main no='1040.Mahsup Fişi'></strong>
                                    </cfif>
                                   <strong> <cf_get_lang_main no='75.No'> :</strong>
                                    <cfif len(Get_Card_Rows.card_type_no)><strong></strong><cfelse><strong>1</strong></cfif>
                                    <strong>- <cf_get_lang no='96.Yevmiye No'> : #get_card_rows.bill_no# - #dateformat(get_card_rows.action_date,dateformat_style)#</strong>
                                    </td>
                                </tr>
                                <cfif len(get_card_rows.document_type)>
                                <tr>
                                    <td style="width:20mm;"><strong><cf_get_lang_main no='1121.Belge Tipi'></strong></td>
                                    <td colspan="4"><strong>: &nbsp;#get_card_rows.document_type#</strong></td>
                                </tr>
                                </cfif>
                                <cfif len(get_card_rows.payment_type)>
                                <tr>
                                    <td style="width:20mm;"><strong><cf_get_lang_main no='2260.Ödeme Şekli'></strong></td>
                                    <td colspan="4"><strong>: &nbsp;#get_card_rows.payment_type#</strong></td>
                                </tr>
                                </cfif>
                                <tr><td colspan="5">&nbsp;</td></tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">
                            <table border="0" width="100%">
                                <tr bgcolor="CCCCCC">
                                    <td style="width:20mm;"><strong><cf_get_lang no='37.Hesap Kodu'></strong></td>
                                    <td style="width:32mm;"><strong><cf_get_lang no='38.Hesap Adı'></strong></td>
                                    <td style="width:50mm;"><strong><cf_get_lang_main no='217.Açıklama'></strong></td>
                                    <td style="width:10mm;text-align:right"><strong><cf_get_lang_main no='175.Borç'></strong></td>
                                    <td style="width:10mm;text-align:right"><strong><cf_get_lang_main no='176.Alacak'></strong></td>
                                    <cfif Get_Card_Rows.is_other_currency neq 1>
                                        <td style="width:57mm;">&nbsp;</td>
                                    <cfelse>
                                        <td style="text-align:right"><strong><cf_get_lang_main no='1493.Sistem Döviz'></strong></td>
                                        <td style="text-align:right"><strong><cf_get_lang_main no='265.Döviz'> <cf_get_lang_main no='1248.Değeri'></strong></td>
                                        <td style="text-align:right"><strong><cf_get_lang_main no='77.Para Br'></strong></td>
                                    </cfif>		  
                                </tr>
                                <cfoutput>
                                	<cfloop query="Get_Card_Rows" startrow="#rowStart#" endrow="#rowEnd#">
                                        <tr height="20">
                                            <td style="width:20mm;">
                                                <cfif ListLen(Get_Card_Rows.account_id,'.') gt 0>
                                                    <cfloop index="j" from="1" to="#ListLen(Get_Card_Rows.account_id,'.')#">&nbsp;</cfloop>
                                                </cfif>
                                                #get_card_rows.account_id#
                                            </td>
                                            <td style="width:32mm;">#get_card_rows.account_name#</td>
                                            <td style="width:50mm;">#get_card_rows.detail#</td>
                                            <td style="width:10mm;text-align:right">
                                            <cfif Get_Card_Rows.ba eq 0>
                                                 #TLFormat(get_card_rows.amount)#
                                                 <cfset total_a=total_a+amount>
                                            </cfif>
                                            </td>
                                            <td style="width:10mm;text-align:right">
                                            <cfif Get_Card_Rows.ba neq 0>
                                                #TLFormat(get_card_rows.amount)#
                                                <cfset total_b=total_b+amount>
                                            </cfif>
                                            </td>
                                            <cfif Get_Card_Rows.is_other_currency neq 1>
                                                <td style="width:57mm;">&nbsp;</td>
                                            <cfelse>
                                                <td style="text-align:right">#TLFormat(get_card_rows.amount_2)# #get_card_rows.amount_currency_2#</td>
                                                <td style="text-align:right">#TLFormat(get_card_rows.other_amount)#</td>
                                                <td style="text-align:right">#get_card_rows.other_currency#</td>
                                            </cfif>
                                        </tr>
                                    </cfloop>
                                    <cfset rowStart = rowStart + row_>
                                    <cfset rowEnd 	= rowStart + (row_-1)>
                                </cfoutput>		  
                            </table>
                        </td>
                    </tr>
                    <tr> 
                        <td valign="top" height="50">
                            <table border="0" width="100%">
                                <tr height="20">
                                    <td colspan="3" style="width:48mm; text-align:right;"><strong><cf_get_lang_main no='80.Toplam'></strong>&nbsp;</td>
                                    <td style="width:10mm;text-align:right"><cfoutput><strong>#TLFormat(total_a)#</strong></cfoutput></td>
                                    <td style="width:10mm;text-align:right"><cfoutput><strong>#TLFormat(total_b)#</strong></cfoutput></td>
                                    <cfif Get_Card_Rows.is_other_currency neq 1>
                                        <td style="width:57mm;">&nbsp;</td>
                                    <cfelse>
                                        <td style="text-align:right" colspan="2"></td>
                                        <td style="text-align:right">
                                             <cfoutput query="GET_OTHER_MONEY_TOTALS">
                                                <strong>#other_currency# : #TLFormat(other_amount_toplam)#</strong> <cfif ba eq 1><strong>(A)</strong><cfelse><strong>(B)</strong></cfif><br/>
                                            </cfoutput>
                                        </td>
                                    </cfif>	
                                </tr>	  
                            </table>
                            <table border="0" width="100%">
                                <tr><td style="height:20mm;"><strong><cf_get_lang_main no='487.Kaydeden'> : </strong><cfoutput>#get_emp_info(GET_CARD_ROWS.record_emp,0,0)#</cfoutput></td></tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>    
        </tr>
    </cfloop>  
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->