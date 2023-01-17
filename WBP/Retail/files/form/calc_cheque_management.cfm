<cfset tarih_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfif dayofweek(tarih_) neq 7>
	<cfset tarih_ = dateadd('d',-dayofweek(tarih_),tarih_)>
</cfif>
<cf_grid_list>
    <thead>
        <tr>
            <th>H.<cf_get_lang dictionary_id='57501.Başlangıç'></th>
            <th>H.<cf_get_lang dictionary_id='57502.Bitiş'></th>
            <th><cf_get_lang dictionary_id='49812.Kredi Kartı Ödeme'> </th>
            <th><cf_get_lang dictionary_id='58007.Çek'></th>
            <th><cf_get_lang dictionary_id='58008.Senet'></th>
            <th><cf_get_lang dictionary_id='48821.Banka Talimatları'></th>
            <th><cf_get_lang dictionary_id='63494.Gider Planı'></th>
            <th><cf_get_lang dictionary_id='38687.Kredi'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='63495.Haftalık Ödeme'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='63496.Tablo Rakamı'></th>
            <th style="text-align:right;"><cf_get_lang dictionary_id='39895.Toplam Ödeme'></th>
        </tr>
    </thead>
    <tbody>

    <cfset g_type_0 = 0>
    <cfset g_type_1 = 0>
    <cfset g_type_2 = 0>
    <cfset g_type_3 = 0>
    <cfset g_type_4 = 0>
    <cfset g_type_5 = 0>


    <cfoutput>
    <cfloop from="0" to="51" index="aaa">
    <cfset tarih_ilk_ = dateadd('d',(aaa*7),tarih_)>
    <cfset tarih_son_ = dateadd('d',(aaa*7)+6,tarih_)>

    <cfset attributes.start_date = tarih_ilk_>
    <cfset attributes.finish_date = tarih_son_>
    <cfquery name="get_rows" datasource="#dsn3#">
        SELECT
            SUM(AMOUNT) AS TOTAL_AMOUNT,
            TYPE_CODE
        FROM
        (
            SELECT
                    COMPANY_ID,
                    COMPANY_NAME,
                    CREDITCARD_ID AS ISLEM_ID,
                    TYPE_CODE,
                    TYPE_,
                    ODEME_TARIHI,
                    BANKA,
                    CREDIT_CARD,
                    DETAIL,
                    '' ISLEM_NO,
                    SUM(INSTALLMENT_AMOUNT - CLOSED_AMOUNT) AS AMOUNT                
            FROM
                    (
                    SELECT
                        '' AS COMPANY_ID,
                        '' AS COMPANY_NAME,
                        CAST(CCE.ACCOUNT_ID AS NVARCHAR) + ';' + CCE.ACTION_CURRENCY_ID + ';' + CAST(CC.CREDITCARD_ID AS NVARCHAR) AS CREDITCARD_ID,
                        0 AS TYPE_CODE,
                        'KREDİ KARTI ÖDEME' AS TYPE_,
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) ODEME_TARIHI,
                        (SELECT	A.ACCOUNT_NAME+' - '+BB.BANK_BRANCH_NAME 
                            FROM ACCOUNTS A INNER JOIN	BANK_BRANCH BB ON BB.BANK_BRANCH_ID = A.ACCOUNT_BRANCH_ID
                            WHERE A.ACCOUNT_ID = CCE.ACCOUNT_ID
                        ) BANKA,    
                        (SELECT CC.CREDITCARD_NUMBER FROM CREDIT_CARD CC WHERE CC.CREDITCARD_ID = CCR.CREDITCARD_ID) CREDIT_CARD,
                        '' AS DETAIL,
                        CCR.INSTALLMENT_AMOUNT,
                        ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CCR.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
                    FROM
                        CREDIT_CARD_BANK_EXPENSE_ROWS CCR,
                        CREDIT_CARD_BANK_EXPENSE CCE,
                        CREDIT_CARD CC
                    WHERE
                        CC.CREDITCARD_ID = CCE.CREDITCARD_ID AND
                        CCE.CREDITCARD_EXPENSE_ID = CCR.CREDITCARD_EXPENSE_ID AND
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) <= #attributes.finish_date# AND
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) >= #attributes.start_date#
                    ) KK
            WHERE
                    (INSTALLMENT_AMOUNT - CLOSED_AMOUNT) > 0
            GROUP BY
                    COMPANY_ID,
                    COMPANY_NAME,
                    CREDITCARD_ID,
                    TYPE_CODE,
                    TYPE_,
                    ODEME_TARIHI,
                    BANKA,
                    CREDIT_CARD,
                    DETAIL
            UNION ALL
                SELECT
                    COMPANY_ID,
                    COMPANY_NAME,
                    CREDITCARD_ID AS ISLEM_ID,
                    TYPE_CODE,
                    TYPE_,
                    #attributes.start_date# AS ODEME_TARIHI,
                    BANKA,
                    CREDIT_CARD,
                    DETAIL,
                    '' ISLEM_NO,
                    SUM(INSTALLMENT_AMOUNT - CLOSED_AMOUNT) AS AMOUNT                
            FROM
                    (
                    SELECT
                        '' AS COMPANY_ID,
                        '' AS COMPANY_NAME,
                        CAST(CCE.ACCOUNT_ID AS NVARCHAR) + ';' + CCE.ACTION_CURRENCY_ID + ';' + CAST(CC.CREDITCARD_ID AS NVARCHAR) AS CREDITCARD_ID,
                        0 AS TYPE_CODE,
                        'KREDİ KARTI ÖDEME (GEÇMİŞ)' AS TYPE_,
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) ODEME_TARIHI,
                        (SELECT	A.ACCOUNT_NAME+' - '+BB.BANK_BRANCH_NAME 
                            FROM ACCOUNTS A INNER JOIN	BANK_BRANCH BB ON BB.BANK_BRANCH_ID = A.ACCOUNT_BRANCH_ID
                            WHERE A.ACCOUNT_ID = CCE.ACCOUNT_ID
                        ) BANKA,    
                        (SELECT CC.CREDITCARD_NUMBER FROM CREDIT_CARD CC WHERE CC.CREDITCARD_ID = CCR.CREDITCARD_ID) CREDIT_CARD,
                        '' AS DETAIL,
                        CCR.INSTALLMENT_AMOUNT,
                        ISNULL((SELECT SUM(CLOSED_AMOUNT) FROM CREDIT_CARD_BANK_EXPENSE_RELATIONS WHERE CREDIT_CARD_BANK_EXPENSE_RELATIONS.CC_BANK_EXPENSE_ROWS_ID = CCR.CC_BANK_EXPENSE_ROWS_ID),0) CLOSED_AMOUNT
                    FROM
                        CREDIT_CARD_BANK_EXPENSE_ROWS CCR,
                        CREDIT_CARD_BANK_EXPENSE CCE,
                        CREDIT_CARD CC
                    WHERE
                        CC.CREDITCARD_ID = CCE.CREDITCARD_ID AND
                        CCE.CREDITCARD_EXPENSE_ID = CCR.CREDITCARD_EXPENSE_ID AND
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) >= #attributes.start_date# AND
                        DATEADD(day,ISNULL(CC.PAYMENT_DAY,0),CCR.ACC_ACTION_DATE) <= #attributes.finish_date#
                    ) KK
            WHERE
                    (INSTALLMENT_AMOUNT - CLOSED_AMOUNT) > 0
            GROUP BY
                    COMPANY_ID,
                    COMPANY_NAME,
                    CREDITCARD_ID,
                    TYPE_CODE,
                    TYPE_,
                    ODEME_TARIHI,
                    BANKA,
                    CREDIT_CARD,
                    DETAIL
            UNION ALL
                SELECT
                    '' AS COMPANY_ID,
                    '' AS COMPANY_NAME,
                    CAST(C.CHEQUE_ID AS NVARCHAR)  AS ISLEM_ID,
                    1 AS TYPE_CODE,
                    'ÇEK ÖDEME' AS TYPE_,
                    C.CHEQUE_DUEDATE ODEME_TARIHI,
                    (SELECT A.ACCOUNT_NAME FROM ACCOUNTS A WHERE A.ACCOUNT_ID = C.ACCOUNT_ID)+' - '+ BANK_BRANCH_NAME BANKA,
                    '' CREDIT_CARD,
                    (SELECT CO.FULLNAME FROM #dsn_alias#.COMPANY CO WHERE CO.COMPANY_ID = C.COMPANY_ID) DETAIL,
                    C.CHEQUE_NO ISLEM_NO,
                    OTHER_MONEY_VALUE AMOUNT
                FROM
                    #dsn2_alias#.CHEQUE C
                WHERE
                    C.CHEQUE_DUEDATE >= #attributes.start_date# AND
                    C.CHEQUE_DUEDATE <= #attributes.finish_date# AND
                    C.CHEQUE_STATUS_ID <> 7
            UNION ALL
                SELECT
                    '' AS COMPANY_ID,
                    '' AS COMPANY_NAME,
                    CAST(V.VOUCHER_ID AS NVARCHAR)  AS ISLEM_ID,
                    5 AS TYPE_CODE,
                    'SENET ÖDEME' AS TYPE_,
                    V.VOUCHER_DUEDATE ODEME_TARIHI,
                    '' BANKA,
                    '' CREDIT_CARD,
                    (SELECT CO.FULLNAME FROM #dsn_alias#.COMPANY CO WHERE CO.COMPANY_ID = V.COMPANY_ID) DETAIL,
                    V.VOUCHER_NO ISLEM_NO,
                    OTHER_MONEY_VALUE AMOUNT
                FROM
                    #dsn2_alias#.VOUCHER V
                WHERE
                    V.VOUCHER_DUEDATE >= #attributes.start_date# AND
                    V.VOUCHER_DUEDATE <= #attributes.finish_date# AND
                    V.VOUCHER_STATUS_ID <> 7
            UNION ALL
                SELECT 
                    C.COMPANY_ID,
                    C.FULLNAME AS COMPANY_NAME,
                    NULL AS ISLEM_ID,
                    2 AS TYPE_CODE,
                    'BANKA TALİMATLARI' TYPE_,
                    BON.PAYMENT_DATE ODEME_TARIHI,
                    A.ACCOUNT_NAME BANKA,
                    '' CREDIT_CARD,
                    C.FULLNAME DETAIL,
                    BON.SERI_NO ISLEM_NO,
                    BON.ACTION_VALUE AMOUNT
                FROM 
                    #dsn2_alias#.BANK_ORDERS BON,
                    ACCOUNTS AS A,
                    #dsn_alias#.COMPANY C
                WHERE 		
                    C.COMPANY_ID = BON.COMPANY_ID AND
                    A.ACCOUNT_ID = BON.ACCOUNT_ID AND
                    (BON.IS_PAID = 0 OR BON.IS_PAID IS NULL) AND
                    BON.BANK_ORDER_TYPE = 250 AND
                    BON.PAYMENT_DATE <= #attributes.finish_date# AND
                    BON.PAYMENT_DATE >= #attributes.start_date#
            UNION ALL
                SELECT
                    '' AS COMPANY_ID,
                    '' AS COMPANY_NAME,
                    NULL AS ISLEM_ID,
                    3 AS TYPE_CODE,
                    'GİDER PLANI' TYPE_,
                    START_DATE ODEME_TARIHI,
                    '' BANKA,
                    '' CREDIT_CARD,
                    PERIOD_DETAIL DETAIL,
                    '' ISLEM_NO,
                    PERIOD_VALUE AMOUNT
                FROM
                    SCEN_EXPENSE_PERIOD_ROWS
                WHERE
                    TYPE = 0 AND
                    START_DATE <= #attributes.finish_date# AND
                    START_DATE >= #attributes.start_date#
        UNION
                SELECT
                    C.COMPANY_ID,
                    C.FULLNAME AS COMPANY_NAME,
                    CAST(CR.CREDIT_CONTRACT_ID AS NVARCHAR) AS ISLEM_ID,
                    4 AS TYPE_CODE,
                    'KREDİ ÖDEMELERİ' AS TYPE_,
                    CR.PROCESS_DATE AS ODEME_TARIHI,
                    BANK_NAME AS BANKA,
                    '' CREDIT_CARD,
                    CR.DETAIL,
                    CREDIT_NO AS ISLEM_NO,
                    TOTAL_PRICE AS AMOUNT
                FROM
                    CREDIT_CONTRACT_ROW CR,
                    CREDIT_CONTRACT CC,
                    #dsn_alias#.COMPANY C
                WHERE
                    CC.COMPANY_ID = C.COMPANY_ID AND
                    CR.CREDIT_CONTRACT_TYPE = 1 AND
                    CR.CREDIT_CONTRACT_ID = CC.CREDIT_CONTRACT_ID AND
                    CR.IS_PAID = 0 AND 
                    ISNULL(CR.IS_PAID_ROW,0) = 0 AND
                    CR.PROCESS_DATE >= #attributes.start_date# AND
                    CR.PROCESS_DATE <= #attributes.finish_date#
        ) B
        WHERE
            TYPE_CODE IS NOT NULL
        GROUP BY
            TYPE_CODE
    </cfquery>

    <cfset type_0 = 0>
    <cfset type_1 = 0>
    <cfset type_2 = 0>
    <cfset type_3 = 0>
    <cfset type_4 = 0>
    <cfset type_5 = 0>

    <cfif get_rows.recordcount>
        <cfquery name="get_rows0" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 0
        </cfquery>
        <cfif get_rows0.recordcount and len(get_rows0.TOTAL)>
            <cfset type_0 = get_rows0.TOTAL>
        </cfif>
        
        <cfquery name="get_rows1" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 1
        </cfquery>
        <cfif get_rows1.recordcount and len(get_rows1.TOTAL)>
            <cfset type_1 = get_rows1.TOTAL>
        </cfif>
        
        <cfquery name="get_rows2" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 2
        </cfquery>
        <cfif get_rows2.recordcount and len(get_rows2.TOTAL)>
            <cfset type_2 = get_rows2.TOTAL>
        </cfif>
        
        <cfquery name="get_rows3" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 3
        </cfquery>
        <cfif get_rows3.recordcount and len(get_rows3.TOTAL)>
            <cfset type_3 = get_rows3.TOTAL>
        </cfif>
        
        <cfquery name="get_rows4" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 4
        </cfquery>
        <cfif get_rows4.recordcount and len(get_rows4.TOTAL)>
            <cfset type_4 = get_rows4.TOTAL>
        </cfif>
        
        <cfquery name="get_rows5" dbtype="query">
            SELECT SUM(TOTAL_AMOUNT) AS TOTAL FROM get_rows WHERE TYPE_CODE = 5
        </cfquery>
        <cfif get_rows5.recordcount and len(get_rows5.TOTAL)>
            <cfset type_5 = get_rows5.TOTAL>
        </cfif>
    </cfif>


    <cfset g_type_0 = g_type_0 + type_0>
    <cfset g_type_1 = g_type_1 + type_1>
    <cfset g_type_2 = g_type_2 + type_2>
    <cfset g_type_3 = g_type_3 + type_3>
    <cfset g_type_4 = g_type_4 + type_4>
    <cfset g_type_5 = g_type_5 + type_5>
        <tr>
            <td>#dateformat(tarih_ilk_,'dd/mm/yyyy')#</td>
            <td>#dateformat(tarih_son_,'dd/mm/yyyy')#</td>
            <td style="text-align:right;">#tlformat(type_0)#</td>
            <td style="text-align:right;">#tlformat(type_1)#</td>
            <td style="text-align:right;">#tlformat(type_5)#</td>
            <td style="text-align:right;">#tlformat(type_2)#</td>
            <td style="text-align:right;">#tlformat(type_3)#</td>
            <td style="text-align:right;">#tlformat(type_4)#</td>
            <td style="text-align:right;" id="week_real_#aaa#"><cfif get_rows.recordcount and len(get_rows.TOTAL_AMOUNT)>#tlformat(type_0+type_1+type_2+type_3+type_4+type_5)#</cfif></td>
            <td style="text-align:right;" id="week_add_#aaa#">0</td>
            <td style="text-align:right;" id="week_total_#aaa#"><cfif get_rows.recordcount and len(get_rows.TOTAL_AMOUNT)>#tlformat(type_0+type_1+type_2+type_3+type_4+type_5)#<cfelse>0</cfif></td>
        </tr>
    </cfloop>
        <tr class="formbold">
            <td>&nbsp;</td>
            <td>&nbsp;</td>
            <td style="text-align:right;">#tlformat(g_type_0)#</td>
            <td style="text-align:right;">#tlformat(g_type_1)#</td>
            <td style="text-align:right;">#tlformat(g_type_5)#</td>
            <td style="text-align:right;">#tlformat(g_type_2)#</td>
            <td style="text-align:right;">#tlformat(g_type_3)#</td>
            <td style="text-align:right;">#tlformat(g_type_4)#</td>
            <td style="text-align:right;" id="week_real_t">#tlformat(g_type_0+g_type_1+g_type_2+g_type_3+g_type_4+g_type_5)#</td>
            <td style="text-align:right;" id="week_add_t">0</td>
            <td style="text-align:right;" id="week_total_t">#tlformat(g_type_0+g_type_1+g_type_2+g_type_3+g_type_4+g_type_5)#</td>
        </tr>
    </cfoutput>
    </tbody>
</cf_grid_list>
<cfoutput>
<script>
function hesapla_table()
{
	<cfloop from="0" to="51" index="aaa">
		<cfset tarih_ilk_ = dateadd('d',(aaa*7),tarih_)>
		<cfset tarih_son_ = dateadd('d',(aaa*7)+6,tarih_)>
		
		week_#aaa#_start_tarih_ = '#dateformat(tarih_ilk_,"dd/mm/yyyy")#';
		week_#aaa#_start_ = #(year(tarih_ilk_) * 365) + (month(tarih_ilk_) * 30) + (day(tarih_ilk_))#;
		week_#aaa#_finish_ = #(year(tarih_son_) * 365) + (month(tarih_son_) * 30) + (day(tarih_son_))#;
	</cfloop>
	
	for (var cc=0; cc <= 51; cc++) //ul içindeki lileri döndürüyoruz
	{
		document.getElementById('week_add_' + cc).innerHTML = 0;	
	}
	
	
	g_toplam = 0;
	for (var khm=1; khm <= <cfoutput>#attributes.row_count#</cfoutput>; khm++) //ul içindeki lileri döndürüyoruz
	{
		amount_ = parseFloat(filterNum(document.getElementById('bakiye' + khm).value));
		tarih_ = document.getElementById('odeme_gunu_tarih' + khm).value;

		for (var hh=0; hh <= 51; hh++) //ul içindeki lileri döndürüyoruz
		{
			week_start_ = eval("week_" + hh + "_start_tarih_");
			if(tarih_ == week_start_) //tarih_deger_ >= week_start_ && tarih_deger_ <= week_finish_
			{
				rakam_1 = parseFloat(filterNum(document.getElementById('week_real_' + hh).innerHTML));
				rakam_ = parseFloat(filterNum(document.getElementById('week_add_' + hh).innerHTML));
				rakam_ = rakam_ + amount_;
				document.getElementById('week_add_' + hh).innerHTML = commaSplit(rakam_);
				document.getElementById('week_total_' + hh).innerHTML = commaSplit(rakam_ + rakam_1);
				g_toplam = g_toplam + amount_;
			}
		}
			
	}
	rakam_1 = parseFloat(filterNum(document.getElementById('week_real_t').innerHTML));
	rakam_2 = g_toplam;
	document.getElementById('week_total_t').innerHTML = commaSplit(rakam_1 + rakam_2);
	document.getElementById('week_add_t').innerHTML = commaSplit(g_toplam);
}
hesapla_table();
</script>
</cfoutput>