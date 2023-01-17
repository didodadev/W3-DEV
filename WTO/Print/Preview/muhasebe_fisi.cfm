<!--- Standart Muhasebe Fisi --->
<cf_get_lang_set module_name="account"><!--- sayfanin en altinda kapanisi var --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
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
<cfquery name="CHECK" datasource="#DSN#">
    SELECT 
      ASSET_FILE_NAME2,
      ASSET_FILE_NAME2_SERVER_ID,
    COMPANY_NAME
    FROM 
      OUR_COMPANY 
    WHERE 
      <cfif isdefined("attributes.our_company_id")>
        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
      <cfelse>
        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
          COMP_ID = #session.ep.company_id#
        <cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>  
          COMP_ID = #session.pp.company_id#
        <cfelseif isDefined("session.ww.our_company_id")>
          COMP_ID = #session.ww.our_company_id#
        <cfelseif isDefined("session.cp.our_company_id")>
          COMP_ID = #session.cp.our_company_id#
        </cfif> 
      </cfif> 
  </cfquery>
<cfquery name="COMPANY_INFO" datasource="#DSN#">
	SELECT COMPANY_NAME, COMP_ID FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfset row_ = 25>
<cfset rowStart = 1>
<cfset rowEnd 	= row_>
<cfset pageCount = Ceiling( #Get_Card_Rows.recordCount# / rowEnd ) >
<cfloop index="i" from="1" to="#pageCount#">
    <table style="width:210mm">
        <tr>
            <td>
                <table width="100%">
                    <tr class="row_border">
                        <td class="print-head">
                            <table style="width:100%;">  
                                <tr>
                                    <td class="print_title"><cf_get_lang dictionary_id='59038.Senet Giriş Bordrosu'></td>
                                    <td style="text-align:right;">
                                        <cfif len(check.asset_file_name2)>
                                        <cfset attributes.type = 1>
                                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                                        </cfif>
                                    </td>
                                </tr>
                            </table> 
                        </td>
                    </tr>
                    <tr class="row_border">
                        <td>
                            <table>
                                <cfoutput>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang_main no='1195.FİRMA'> <cf_get_lang_main no='485.ADI'></b></td>
                                        <td>#company_info.company_name#</td>
                                        
                                    </tr>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang_main no='534.FİŞ NO'></b></td>
                                        <td>#get_card_rows.card_type_no#</td>
                                    </tr>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang no='86.FİŞ TÜRÜ'></b></td>
                                        <td>
                                        <cfif Get_Card_Rows.card_type eq 10>
                                        <cf_get_lang_main no='1344.Açılış Fişi'>
                                        <cfelseif Get_Card_Rows.card_type eq 11>
                                        <cf_get_lang_main no='1432.Tahsil Fişi'>
                                        <cfelseif Get_Card_Rows.card_type eq 12>
                                        <cf_get_lang_main no='1542.Tediye Fişi'>
                                        <cfelseif Get_Card_Rows.card_type eq 13>
                                        <cf_get_lang_main no='1040.Mahsup Fişi'>
                                        </cfif></td>
                                    </tr>
                                    <tr>
                                
                                        <td><b><cf_get_lang no='96.Yevmiye No'></b></td>
                                        <td>#get_card_rows.bill_no#</td>
                                    
                                    </tr>
                                    <cfif len(get_card_rows.document_type)>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang_main no='1121.Belge Tipi'></b></td>
                                        <td>#get_card_rows.document_type#</td>
                                    </tr>
                                    </cfif>
                                    <cfif len(get_card_rows.payment_type)>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang_main no='2260.Ödeme Şekli'></b></td>
                                        <td>#get_card_rows.payment_type#</td>
                                    </tr>
                                    </cfif>
                                    <tr>
                                        <td style="width:140px"><b><cf_get_lang_main no='330.Tarih'></b></td>
                                        <td>#dateformat(get_card_rows.action_date,dateformat_style)#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </td>
                    </tr>
                    <table>
                        <tr>
                            <td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY"'></b></td>
                        </tr> 
                    </table>
                    <table class="print_border" >
                        <tr >
                            <th><cf_get_lang no='37.Hesap Kodu'></th>
                            <th><cf_get_lang no='38.Hesap Adı'></th>
                            <th><b><cf_get_lang_main no='217.Açıklama'></th>
                            <th><b><cf_get_lang_main no='175.Borç'></th>
                            <th><b><cf_get_lang_main no='176.Alacak'></th>
                            <cfif Get_Card_Rows.is_other_currency neq 1>
                                &nbsp;
                            <cfelse>
                                <th><cf_get_lang_main no='1493.Sistem Döviz'></th>
                                <th><b><cf_get_lang_main no='265.Döviz'> <cf_get_lang_main no='1248.Değeri'></th>
                                <th><b><cf_get_lang_main no='77.Para Br'></th>
                            </cfif>		  
                        </tr>
                        <cfoutput>
                            <cfloop query="Get_Card_Rows" startrow="#rowStart#" endrow="#rowEnd#">
                                <tr >
                                    <td>
                                        <cfif ListLen(Get_Card_Rows.account_id,'.') gt 0>
                                            <cfloop index="j" from="1" to="#ListLen(Get_Card_Rows.account_id,'.')#">&nbsp;</cfloop>
                                        </cfif>
                                        #get_card_rows.account_id#</td>
                                    </td>
                                    <td>#get_card_rows.account_name#</td>
                                    <td>#get_card_rows.detail#</td>
                                    <td style="text-align:right">
                                    <cfif Get_Card_Rows.ba eq 0>
                                            #TLFormat(get_card_rows.amount)#
                                            <cfset total_a=total_a+amount>
                                    </cfif>
                                    </td>
                                    <td style="text-align:right">
                                    <cfif Get_Card_Rows.ba neq 0>
                                        #TLFormat(get_card_rows.amount)#
                                        <cfset total_b=total_b+amount>
                                    </cfif>
                                    </td>
                                    <cfif Get_Card_Rows.is_other_currency neq 1>
                                        
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
                    <br>
                    <table>
                        <tr>
                            <td style="width:140px"><b><cf_get_lang_main no='80.Toplam'><cf_get_lang_main no='176.Alacak'></b></td>
                            <td><cfoutput>#TLFormat(total_a)#</cfoutput></td>
                            </tr>
                            <tr>
                            <td style="width:140px"><b><cf_get_lang_main no='80.Toplam'><cf_get_lang_main no='175.Borç'></td>
                            <td><cfoutput>#TLFormat(total_b)#</cfoutput></td>
                            </tr>
                            <cfif Get_Card_Rows.is_other_currency neq 1>
                                &nbsp;
                            <cfelse>
                                <cfoutput query="GET_OTHER_MONEY_TOTALS">
                                    <cfif ba eq 1>
                                        <tr>
                                            <td style="width:140px">  <b>#other_currency#</b></td>
                                            <td>#TLFormat(other_amount_toplam)#<cf_get_lang_main no='176.Alacak'></td>
                                        </tr>
                                    <cfelse>
                                        <tr> 
                                            <td style="width:140px">  <b>#other_currency#</b></td>
                                            <td>#TLFormat(other_amount_toplam)#<cf_get_lang_main no='175.Borç'></td>
                                        </tr>
                                    </cfif>
                                </cfoutput>
                            </cfif>	
                        </tr>	  
                    </table>
                    <table>
                        <br>
                            <tr class="fixed">
                                <td style="font-size:9px!important;" style="height:50px;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
                            </tr>
                        </br>
                    </table>
                </table>
            </td>    
        </tr>
    </table>
</cfloop>  
    
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->