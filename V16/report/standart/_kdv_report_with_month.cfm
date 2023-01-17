<!--- Rapor : Aylık Ayrıntılı KDV Raporu
	Açıklama : Yıl içindeki o döneme kadar olan ayların Ay bazında Aylık Ayrıntılı KDV Raporu
	Liste Alanları : KDV Oranı, Matrah Hesaplanan Kdv, Hesaplanan Kdv, Matrah Alış İade, Alış İade Kdv,  
					   Matrah İndirilecek KDV, İndirilecek KDV, Matrah Satış İade, Satış İade Kdv, Bakiye  --->

<!--- KDV AYRINTILI RAPOR
	Bakiye: (Hesaplanan+aliş iade)-(İndirilicek + Satış iade)	
	Gider odeme her zaman inidirilecek kdv olarak yazilir.
	
	Gider odeme CAT_ID = 36
	Alim Faturalari : 51,59,60,63,65
	Satış Faturalari : 50,52,53,56,58,66
	Alım İade Faturaları : 62
	Satış İade Faturaları : 54,55
	
	! ! ! 
	arzu ya : hani banka gider ödeme, ayrıca kodlara bakalım ve eğer burada değil ama başka yerlerde gerekirse 
	invoice tablosundaki PURCHASE_SALES doğru set ediliyorsa işlem tipi kontrolüne bile gerek olmadan bazı değerler bulunabilir
	HS20040713
	! ! !
	
	Eksiklikler:
	-> Muhasebe doneminin yili icin her ay icin ayri ayri getirecek.
	
    Duzenleme : FBS 20110616 Tevkifat hesaplamalari dikkate alinacak sekilde duzenlendi
    
    48: Verilen kur farkı faturası
    50: Verilen vade farkı faturası
--->
<cf_xml_page_edit fuseact ="report.kdv_report_with_month">
    <cfparam name="attributes.module_id_control" default="20">
    <cfinclude template="report_authority_control.cfm">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.sal_year" default="#session.ep.period_year#">
    <cfparam name="attributes.sal_mon" default="#month(now())#">
    <cfparam name="attributes.process_type" default="">
    <cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
    <cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
    <!--- islem tipleri --->
    <cfset process_types = "48,49,50,51,52,53,54,55,56,58,59,60,62,63,64,65,66,68,69,120,531,532,561,591,592,601,690,691">
    <cfquery name="get_process_cat" datasource="#dsn3#">
        SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#process_types#) ORDER BY PROCESS_CAT
    </cfquery>
    
    <cfquery name="get_inv_pos_satis"  datasource="#DSN2#">
        SELECT
            IR.TAX,
            SUM(IR.TAXTOTAL) AS TAXTOTAL,
            SUM(IR.NETTOTAL) AS NETTOTAL ,
            I.INVOICE_CAT AS ACTION_TYPE
        FROM
            INVOICE_ROW_POS IR,INVOICE I
        WHERE
            IR.INVOICE_ID  = I.INVOICE_ID AND 
            <cfif len(attributes.process_type)>
                1=0 AND
            </cfif>
            I.INVOICE_CAT IN(67,69) AND 
            IR.TAX IS NOT NULL AND 
            (IR.NETTOTAL > 0 OR IR.TAXTOTAL > 0)
            <cfif isdefined("attributes.is_account")>
                AND 
                (
                    (
                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                    )
                OR
                    (
                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                    )
                )
            </cfif>
            AND AMOUNT > 0
         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
         </cfif>  
         <cfif isdate(attributes.start_date)>
            AND I.INVOICE_DATE >= #attributes.start_date#
         </cfif>
         <cfif isdate(attributes.finish_date)>
            AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
         </cfif>
        GROUP BY
            IR.TAX,I.INVOICE_CAT
    </cfquery>
    <cfquery name="get_inv_pos_iade"  datasource="#DSN2#">
        SELECT
            IR.TAX,
            SUM(IR.TAXTOTAL) AS TAXTOTAL,
            SUM(IR.NETTOTAL) AS NETTOTAL ,
            I.INVOICE_CAT AS ACTION_TYPE
        FROM
            INVOICE_ROW_POS IR,INVOICE I
        WHERE
            IR.INVOICE_ID  = I.INVOICE_ID AND 
            <cfif len(attributes.process_type)>
                1=0 AND
            </cfif>
            I.INVOICE_CAT IN(67) AND 
            IR.TAX IS NOT NULL AND 
            (IR.NETTOTAL > 0 OR IR.TAXTOTAL > 0)
            <cfif isdefined("attributes.is_account")>
                AND 
                (
                    (
                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                    )
                OR
                    (
                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                    )
                )
            </cfif>
            AND AMOUNT < 0
         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
         </cfif>  
         <cfif isdate(attributes.start_date)>
            AND I.INVOICE_DATE >= #attributes.start_date#
         </cfif>
         <cfif isdate(attributes.finish_date)>
            AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
         </cfif>
        GROUP BY
            IR.TAX,I.INVOICE_CAT
    </cfquery>
    <cfquery name="get_inv" datasource="#DSN2#">
        SELECT
            TAX,
            SUM(TAXTOTAL) TAXTOTAL,
            SUM(NETTOTAL) NETTOTAL,
            ACTION_TYPE
        FROM
        (
            SELECT
                IR.TAX,
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    SUM(IR.TAXTOTAL)
                ELSE
                    SUM(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100 - (((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL )*TAX/100*ISNULL(1-(I.TEVKIFAT_ORAN),0))) 
                END AS TAXTOTAL,
                CASE WHEN(IR.NETTOTAL = 0) THEN
                    SUM(IR.NETTOTAL)
                ELSE
                    SUM(((1- I.SA_DISCOUNT/#dsn_alias#.IS_ZERO((I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT),1)) * IR.NETTOTAL)) 
                END AS NETTOTAL,
                I.INVOICE_CAT AS ACTION_TYPE,
                IR.INVOICE_ROW_ID
            FROM
                INVOICE_ROW IR,INVOICE I
            WHERE
                IR.INVOICE_ID  = I.INVOICE_ID AND
                <cfif len(attributes.process_type)>
                    I.PROCESS_CAT IN (#attributes.process_type#) AND 
                <cfelse>
                    I.INVOICE_CAT IN (#process_types#) AND 
                </cfif>
                IR.TAX IS NOT NULL AND
                IR.NETTOTAL IS NOT NULL AND
                I.IS_IPTAL = 0	
            <cfif isdefined("attributes.is_account")>
                    AND 
                    (
                        (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                    OR
                        (
                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                        )
                    )
            </cfif>
             <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
                <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
             <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
                <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
             </cfif>	
             <cfif isdate(attributes.start_date)>
                AND I.INVOICE_DATE >= #attributes.start_date#
            </cfif>
            <cfif isdate(attributes.finish_date)>
                AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
            </cfif>		  
            GROUP BY
                IR.TAX,
                I.INVOICE_CAT,
                IR.NETTOTAL,
                IR.INVOICE_ROW_ID
        )T1
        GROUP BY
            TAX,
            ACTION_TYPE
    </cfquery>
    <cfquery name="get_gider"  datasource="#DSN2#">
        SELECT  
           CAST(ER.KDV_RATE AS FLOAT) AS TAX,
           SUM(ER.AMOUNT_KDV) AS TAXTOTAL,
           (SUM(ER.AMOUNT)*ER.QUANTITY) AS NETTOTAL,
           E.ACTION_TYPE AS ACTION_TYPE 
        FROM
           EXPENSE_ITEMS_ROWS ER,
           EXPENSE_ITEM_PLANS E 
        WHERE
           ER.EXPENSE_ID=E.EXPENSE_ID AND
           E.ACTION_TYPE IN (120,121) AND
           KDV_RATE IS NOT NULL
         <!---  <cfif len(attributes.process_type)>
                AND 1=0 
           </cfif>--->
         <cfif isdefined("attributes.is_account")>
                AND 
                (
                    (
                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE E.EXPENSE_ID =AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                    )
                OR
                    (
                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                    )
                )
         </cfif>
         <cfif isdefined("xml_process_cat") and len(xml_process_cat)>
            AND E.PROCESS_CAT NOT IN (#xml_process_cat#)
         </cfif>
         <cfif isdefined("xml_income_process_cat") and len(xml_income_process_cat)>
            AND E.PROCESS_CAT NOT IN (#xml_income_process_cat#)
         </cfif>
         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND DATEPART(MM,E.EXPENSE_DATE) =#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,E.EXPENSE_DATE) = #attributes.sal_year#</cfif>
         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
            <cfif len(attributes.sal_mon)>AND MONTH(E.EXPENSE_DATE) <=#attributes.sal_mon#</cfif>
            <cfif len(attributes.sal_year)>AND YEAR(E.EXPENSE_DATE) <= #attributes.sal_year#</cfif>
         </cfif>
        <cfif isdate(attributes.start_date)>
            AND E.EXPENSE_DATE >= #attributes.start_date#
        </cfif>
        <cfif isdate(attributes.finish_date)>
            AND E.EXPENSE_DATE < #DATEADD('d',1,attributes.finish_date)#
        </cfif>
        GROUP BY
            ER.KDV_RATE,E.ACTION_TYPE,ER.QUANTITY
    </cfquery>
    <cfquery name="get_all" dbtype="query">
            SELECT * FROM get_inv_pos_satis
        UNION ALL
            SELECT * FROM get_inv_pos_iade
        UNION ALL
            SELECT * FROM get_gider
        UNION ALL
            SELECT * FROM get_inv
    </cfquery>
    <cfquery name="get_only_tax"  datasource="#DSN2#">
        SELECT TAX FROM  SETUP_TAX 
    </cfquery>
    <cfform name="rapor" action="#request.self#?fuseaction=report.kdv_report_with_month" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39635.KDV-1 Beyan Hazırlama Raporu'></cfsavecontent>
    <cf_big_list_search title="#title#">
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td rowspan="4" valign="top" width="75"><cf_get_lang dictionary_id='57800.İşlem Tipi'></td>
                    <td rowspan="4" valign="top" width="185">
                        <select name="process_type" id="process_type" style="width:170px; height:60px;" multiple>
                            <cfoutput query="get_process_cat">
                                <option value="#PROCESS_CAT_ID#" <cfif listfind(attributes.process_type,PROCESS_CAT_ID,',')>selected</cfif>>#PROCESS_CAT#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td valign="top">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Lütfen Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" onChange="kontrol()" validate="#validate_style#" message="#message#" maxlength="10"  style="width:60px;" >
                        <cf_wrk_date_image date_field="start_date">
                        <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" onChange="kontrol()" validate="#validate_style#"  message="#message#" maxlength="10" style="width:60px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
                    <td valign="top">
                        <select name="sal_mon" id="sal_mon" <cfif len(attributes.start_date) or len(attributes.finish_date)>disabled</cfif> >
                            <cfloop from="1" to="12" index="i">
                                <cfoutput>
                                    <option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                                </cfoutput>
                            </cfloop>
                        </select>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58455.Yıl'></cfsavecontent>
                        <input type="text" name="sal_year" id="sal_year" value="<cfoutput>#attributes.sal_year#</cfoutput>" style="width:50px;" required="yes" validate="integer" range="1900,2100" maxlength="4" message="#message#" <cfif len(attributes.start_date) or len(attributes.finish_date)>disabled</cfif>>
                    </td>
                    <td valign="top"><cf_wrk_search_button is_excel="1" button_type="1"></td>
                </tr>
                <tr>
                    <td>
                        <input type="checkbox" id="is_tevkifat" name="is_tevkifat" value="1" <cfif isDefined('attributes.is_tevkifat') and attributes.is_tevkifat eq 1>checked</cfif> /> <cf_get_lang dictionary_id='60650.Tevkifat Bilgisi Gösterilsin'>
                    </td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
    </cfform>
    <cf_basket id="kdv_basket">
        
        <table class="detail_basket_list">
            <thead>
                <tr>
                    <th class="txtbold" colspan="10"><cf_get_lang dictionary_id ='58472.Dönem'>: <cfoutput>#SESSION.EP.COMPANY# <cfif not len(attributes.start_date) and not len(attributes.finish_date)>#attributes.sal_year# /
                        &nbsp;#listgetat(ay_list(),attributes.sal_mon,',')#</cfif></cfoutput>
                    </th>
                </tr>
                <tr>
                    <th><cf_get_lang dictionary_id ='40376.KDV Oranı'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40377.Matrah Hesaplanan Kdv'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='58399.Hesaplanan Kdv'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40379.Matrah Alış İade'></th>			
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40380.Alış İade Kdv'> </th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40381.Matrah İndirilecek KDV'></th>			
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40382.İndirilecek KDV'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40383.Matrah Satış İade'></th>			
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='40384.Satış İade Kdv'></th>
                    <th style="text-align:right;"><cf_get_lang dictionary_id ='57589.Bakiye'></th>
                </tr>
            </thead>
            <tbody>
                <cfset flt_indirilecek_tpl = 0 >
                <cfset flt_hesaplanan_tpl = 0 >
                <cfset flt_alim_tpl = 0 >
                <cfset flt_satis_tpl = 0 >
                <cfset flt_matrah_satis_tpl = 0 >
                <cfset flt_matrah_alim_tpl = 0 >
                <cfset flt_matrah_hesaplanan_tpl = 0 >
                <cfset flt_matrah_indirilecek_tpl = 0 >
                <cfoutput query="get_only_tax">
                    <cfset flt_indirilecek = 0 >
                    <cfset flt_hesaplanan = 0 >
                    <cfset flt_alim = 0 >
                    <cfset flt_satis = 0 >
                    <cfset flt_matrah_indirilecek = 0 >
                    <cfset flt_matrah_hesaplanan = 0 >
                    <cfset flt_matrah_alim = 0 >
                    <cfset flt_matrah_satis = 0 >
                    <cfquery name="get_value_hesaplanan" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL,SUM(NETTOTAL) AS NETTOTAL FROM get_all WHERE  TAX = #TAX#  AND ACTION_TYPE IN (50,52,53,56,58,66,67,69,531,532,561,48,121)
                    </cfquery>
                    <cfquery name="get_value_indirilecek" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL,SUM(NETTOTAL) AS NETTOTAL  FROM get_all WHERE  TAX = #TAX#  AND ACTION_TYPE IN (49,51,59,60,63,65,36,28,691,690,64,68,592,601,691,591,120)
                    </cfquery>
                    
                    <cfquery name="get_value_alim_iade" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL,SUM(NETTOTAL) AS NETTOTAL  FROM get_all WHERE  TAX = #TAX#  AND ACTION_TYPE IN (62)
                    </cfquery>
                    <cfquery name="get_value_satis_iade" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL ,SUM(NETTOTAL) AS NETTOTAL FROM get_all WHERE  TAX = #TAX# AND ACTION_TYPE IN (54,55,67) <!--- AND NETTOTAL < 0 --->
                    </cfquery>
                    <cfquery name="get_value_all" dbtype="query">
                        SELECT SUM(TAXTOTAL) AS TAXTOTAL,SUM(NETTOTAL) AS NETTOTAL  FROM get_all WHERE  TAX = #TAX# 
                    </cfquery>		
                    <cfscript>
                        if ( len(get_value_hesaplanan.TAXTOTAL) ) flt_hesaplanan = get_value_hesaplanan.TAXTOTAL;
                        if ( len(get_value_indirilecek.TAXTOTAL) ) flt_indirilecek = get_value_indirilecek.TAXTOTAL;
                        if ( len(get_value_alim_iade.TAXTOTAL) ) flt_alim = get_value_alim_iade.TAXTOTAL;
                        if ( len(get_value_satis_iade.TAXTOTAL) ) flt_satis = get_value_satis_iade.TAXTOTAL;
                        if ( len(get_value_hesaplanan.NETTOTAL) ) flt_matrah_hesaplanan = get_value_hesaplanan.NETTOTAL;
                        if ( len(get_value_indirilecek.NETTOTAL)) flt_matrah_indirilecek = get_value_indirilecek.NETTOTAL;
                        if ( len(get_value_satis_iade.NETTOTAL) ) flt_matrah_satis = get_value_satis_iade.NETTOTAL;
                        if ( len(get_value_alim_iade.NETTOTAL) ) flt_matrah_alim = get_value_alim_iade.NETTOTAL ;
                        flt_indirilecek_tpl = flt_indirilecek_tpl + flt_indirilecek;
                        flt_hesaplanan_tpl = flt_hesaplanan_tpl + flt_hesaplanan;
                        flt_alim_tpl = flt_alim_tpl + flt_alim;
                        flt_satis_tpl = flt_satis_tpl + flt_satis;
                        flt_matrah_satis_tpl = flt_matrah_satis_tpl + flt_matrah_satis;
                        flt_matrah_alim_tpl = flt_matrah_alim_tpl + flt_matrah_alim;
                        flt_matrah_hesaplanan_tpl = flt_matrah_hesaplanan_tpl + flt_matrah_hesaplanan;
                        flt_matrah_indirilecek_tpl = flt_matrah_indirilecek_tpl + flt_matrah_indirilecek;
                    </cfscript>
                    <tr>
                        <td>#tax#</td>
                        <td style="text-align:right;">&nbsp;#TlFormat(flt_matrah_hesaplanan)#</td>
                        <td style="text-align:right;">#TlFormat(flt_hesaplanan)#</td>
                        <td style="text-align:right;">&nbsp;#TlFormat(flt_matrah_alim)#</td>					
                        <td style="text-align:right;">#TlFormat(flt_alim)#</td>
                        <td style="text-align:right;">&nbsp;#TlFormat(flt_matrah_indirilecek)#</td>					
                        <td style="text-align:right;">#TlFormat(flt_indirilecek)#</td>
                        <td style="text-align:right;">&nbsp;#TlFormat(flt_matrah_satis)#</td>					
                        <td style="text-align:right;">#TlFormat(flt_satis)#</td>
                        <td style="text-align:right;">#TLFormat(Evaluate((flt_hesaplanan+flt_alim)-(flt_indirilecek+flt_satis)))#</td>												
                    </tr>
                </cfoutput>
            </tbody>
            <tfoot>
                <cfoutput>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id ='57492.Toplam'></td>
                        <td class="txtbold" style="text-align:right;">&nbsp;#TlFormat(flt_matrah_hesaplanan_tpl)#</td>
                        <td class="txtbold" style="text-align:right;">#TlFormat(flt_hesaplanan_tpl)#</td>
                        <td class="txtbold" style="text-align:right;">&nbsp;#TlFormat(flt_matrah_alim_tpl)#</td>			
                        <td class="txtbold" style="text-align:right;" >#TlFormat(flt_alim_tpl)#</td>
                        <td class="txtbold" style="text-align:right;">&nbsp;#TlFormat(flt_matrah_indirilecek_tpl)#</td>			
                        <td class="txtbold" style="text-align:right;" >#TlFormat(flt_indirilecek_tpl)#</td>
                        <td class="txtbold" style="text-align:right;">&nbsp;#TlFormat(flt_matrah_satis_tpl)#</td>			
                        <td class="txtbold" style="text-align:right;" >#TlFormat(flt_satis_tpl)#</td>
                        <td class="txtbold" style="text-align:right;" >
                            <cfset flt_tutar=Evaluate((flt_hesaplanan_tpl+flt_alim_tpl)-(flt_indirilecek_tpl+flt_satis_tpl))>
                            #TLFormat(flt_tutar)# 
                        </td>
                    </tr>
                </cfoutput>
                <cfif isDefined('attributes.is_tevkifat') and attributes.is_tevkifat eq 1>
                    <tr>
                    
                    </tr>
                    <!--- tevkifat değerlerini ve tutarlarını çekiyoruz --->
                    <cfquery name="get_tevkifat_all"  datasource="#DSN2#">
                    WITH CTE1 AS (
                        SELECT
                            SUM(IR.TAXTOTAL * I.TEVKIFAT_ORAN) AS BEYAN_EDILEN,
                            SUM(IR.TAXTOTAL * (1 - I.TEVKIFAT_ORAN)) AS TEVKIFAT_TUTARI,
                            TEVKIFAT_ORAN,
                            I.PROCESS_CAT ACTION_TYPE,
                            I.TEVKIFAT_ID
                        FROM
                            INVOICE_ROW_POS IR,INVOICE I
                        WHERE
                            IR.INVOICE_ID  = I.INVOICE_ID AND 
                            I.INVOICE_CAT IN(67,69) AND 
                            IR.TAX IS NOT NULL AND 
                            (IR.NETTOTAL > 0 OR IR.TAXTOTAL > 0)
                            <cfif isdefined("attributes.is_account")>
                                AND 
                                (
                                    (
                                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                    )
                                OR
                                    (
                                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                    )
                                )
                            </cfif>
                            AND AMOUNT > 0
                         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
                         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
                         </cfif>  
                         <cfif isdate(attributes.start_date)>
                            AND I.INVOICE_DATE >= #attributes.start_date#
                         </cfif>
                         <cfif isdate(attributes.finish_date)>
                            AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
                         </cfif>
                            AND I.TEVKIFAT_ORAN IS NOT NULL
                        GROUP BY
                            I.TEVKIFAT_ORAN,
                            I.PROCESS_CAT,
                            I.TEVKIFAT_ID
                            
                        UNION ALL
                            
                        SELECT
                            SUM(IR.TAXTOTAL * I.TEVKIFAT_ORAN) AS BEYAN_EDILEN,
                            SUM(IR.TAXTOTAL * (1 - I.TEVKIFAT_ORAN)) AS TEVKIFAT_TUTARI,
                            TEVKIFAT_ORAN,
                            I.PROCESS_CAT ACTION_TYPE,
                            I.TEVKIFAT_ID
                        FROM
                            INVOICE_ROW_POS IR,INVOICE I
                        WHERE
                            IR.INVOICE_ID  = I.INVOICE_ID AND 
                            I.INVOICE_CAT IN(67) AND 
                            IR.TAX IS NOT NULL AND 
                            (IR.NETTOTAL > 0 OR IR.TAXTOTAL > 0)
                            <cfif isdefined("attributes.is_account")>
                                AND 
                                (
                                    (
                                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                    )
                                OR
                                    (
                                        I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                    )
                                )
                            </cfif>
                            AND AMOUNT < 0
                         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
                         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
                         </cfif>  
                         <cfif isdate(attributes.start_date)>
                            AND I.INVOICE_DATE >= #attributes.start_date#
                         </cfif>
                         <cfif isdate(attributes.finish_date)>
                            AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
                         </cfif>
                            AND I.TEVKIFAT_ORAN IS NOT NULL
                        GROUP BY
                            I.TEVKIFAT_ORAN,
                            I.PROCESS_CAT,
                            I.TEVKIFAT_ID
                            
                        UNION ALL
                            
                        SELECT
                            SUM(TAXTOTAL * TEVKIFAT_ORAN) AS BEYAN_EDILEN,
                            SUM(TAXTOTAL * (1 - TEVKIFAT_ORAN)) AS TEVKIFAT_TUTARI,
                            TEVKIFAT_ORAN,
                            ACTION_TYPE,
                            TEVKIFAT_ID
                        FROM
                        (
                            SELECT
                                I.TEVKIFAT_ORAN,
                    SUM(IR.TAXTOTAL) AS TAXTOTAL,
                    SUM(((1 - I.SA_DISCOUNT / #dsn_alias#.IS_ZERO((I.NETTOTAL - I.TAXTOTAL + I.SA_DISCOUNT), 1)) * IR.NETTOTAL)) AS NETTOTAL,
                                I.PROCESS_CAT AS ACTION_TYPE,
                                IR.INVOICE_ROW_ID,
                                I.TEVKIFAT_ID
                            FROM
                                INVOICE_ROW IR,INVOICE I
                            WHERE
                                IR.INVOICE_ID  = I.INVOICE_ID AND
                                IR.TAX IS NOT NULL AND
                                IR.NETTOTAL IS NOT NULL AND
                                I.IS_IPTAL = 0	
                            <cfif isdefined("attributes.is_account")>
                                    AND 
                                    (
                                        (
                                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE I.INVOICE_ID =AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                        )
                                    OR
                                        (
                                            I.INVOICE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE I.INVOICE_ID = AC.ACTION_ID AND I.INVOICE_CAT = AC.ACTION_TYPE)
                                        )
                                    )
                            </cfif>
                             <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                                <cfif len(attributes.sal_mon)>AND DATEPART(MM,I.INVOICE_DATE) =#attributes.sal_mon#</cfif>
                                <cfif len(attributes.sal_year)>AND DATEPART(YYYY,I.INVOICE_DATE) = #attributes.sal_year#</cfif>
                             <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                                <cfif len(attributes.sal_mon)>AND MONTH(I.INVOICE_DATE) <=#attributes.sal_mon#</cfif>
                                <cfif len(attributes.sal_year)>AND YEAR(I.INVOICE_DATE) <= #attributes.sal_year#</cfif>
                             </cfif>	
                             <cfif isdate(attributes.start_date)>
                                AND I.INVOICE_DATE >= #attributes.start_date#
                            </cfif>
                            <cfif isdate(attributes.finish_date)>
                                AND I.INVOICE_DATE < #DATEADD('d',1,attributes.finish_date)#
                            </cfif>
                                AND I.TEVKIFAT_ORAN IS NOT NULL
                            GROUP BY
                                I.TEVKIFAT_ORAN,
                                I.PROCESS_CAT,
                                IR.NETTOTAL,
                                IR.INVOICE_ROW_ID,
                                I.TEVKIFAT_ID
                        )T1
                        GROUP BY
                            TEVKIFAT_ORAN,
                            ACTION_TYPE,
                            TEVKIFAT_ID
        
                    UNION ALL
                    
                        SELECT
                           SUM(ER.AMOUNT_KDV * E.TEVKIFAT_ORAN) AS BEYAN_EDILEN,
                           SUM(ER.AMOUNT_KDV * (1 - E.TEVKIFAT_ORAN)) AS TEVKIFAT_TUTARI,
                           TEVKIFAT_ORAN,
                           E.PROCESS_CAT ACTION_TYPE,
                           E.TEVKIFAT_ID
                        FROM
                           EXPENSE_ITEMS_ROWS ER,
                           EXPENSE_ITEM_PLANS E 
                        WHERE
                           ER.EXPENSE_ID=E.EXPENSE_ID AND
                           E.ACTION_TYPE IN (120,121) AND
                           KDV_RATE IS NOT NULL
                         <cfif isdefined("attributes.is_account")>
                                AND 
                                (
                                    (
                                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD AC WHERE E.EXPENSE_ID =AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                                    )
                                OR
                                    (
                                        E.EXPENSE_ID IN(SELECT AC.ACTION_ID FROM ACCOUNT_CARD_SAVE AC WHERE E.EXPENSE_ID = AC.ACTION_ID AND E.ACTION_TYPE = AC.ACTION_TYPE)
                                    )
                                )
                         </cfif>
                         <cfif isdefined("xml_process_cat") and len(xml_process_cat)>
                            AND E.PROCESS_CAT NOT IN (#xml_process_cat#)
                         </cfif>
                         <cfif isdefined("xml_income_process_cat") and len(xml_income_process_cat)>
                            AND E.PROCESS_CAT NOT IN (#xml_income_process_cat#)
                         </cfif>
                         <cfif DATABASE_TYPE IS "MSSQL" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND DATEPART(MM,E.EXPENSE_DATE) =#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND DATEPART(YYYY,E.EXPENSE_DATE) = #attributes.sal_year#</cfif>
                         <cfelseif DATABASE_TYPE IS "DB2" and (not len(attributes.start_date) and not len(attributes.finish_date))>
                            <cfif len(attributes.sal_mon)>AND MONTH(E.EXPENSE_DATE) <=#attributes.sal_mon#</cfif>
                            <cfif len(attributes.sal_year)>AND YEAR(E.EXPENSE_DATE) <= #attributes.sal_year#</cfif>
                         </cfif>
                        <cfif isdate(attributes.start_date)>
                            AND E.EXPENSE_DATE >= #attributes.start_date#
                        </cfif>
                        <cfif isdate(attributes.finish_date)>
                            AND E.EXPENSE_DATE < #DATEADD('d',1,attributes.finish_date)#
                        </cfif>
                            AND E.TEVKIFAT_ORAN IS NOT NULL
                        GROUP BY
                            E.TEVKIFAT_ORAN,
                            E.PROCESS_CAT,
                            E.TEVKIFAT_ID
                    )
                    SELECT
                        ISNULL(BEYAN_EDILEN,0) BEYAN_EDILEN,
                        ISNULL(TEVKIFAT_TUTARI,0) TEVKIFAT_TUTARI,
                        ST.STATEMENT_RATE TEVKIFAT_ORAN,
                        ST.STATEMENT_RATE_NUMERATOR,
                        ST.STATEMENT_RATE_DENOMINATOR,
                        CTE1.TEVKIFAT_ID
                    FROM
                        #dsn3_alias#.SETUP_TEVKIFAT ST
                            LEFT JOIN CTE1 ON CTE1.TEVKIFAT_ID = ST.TEVKIFAT_ID
                    WHERE 1 = 1
                        <cfif len(attributes.process_type)>
                            AND ACTION_TYPE IN (#attributes.process_type#)
                        </cfif>
                    </cfquery>
                    <cfset total_tevkifat = 0>
                    <cfoutput query="get_tevkifat_all">
                        <cfset total_tevkifat = total_tevkifat + TEVKIFAT_TUTARI>
                    </cfoutput>
                    <!--- // tevkifat değerlerini ve tutarlarını çekiyoruz --->
                    <tr>
                        <td class="txtbold" style="text-align:left;">
                            Tevkifat Oranı
                        </td>
                        <td class="txtbold" style="text-align:right;">
                            Beyan Edilen
                        </td>
                        <td class="txtbold" style="text-align:right;">
                            Tevkifat Tutarı
                        </td>
                    </tr>
                    <cfset total_beyan = 0>
                    <cfset total_tevkifat = 0>
                    <cfif get_tevkifat_all.recordcount>
                        <cfoutput query="get_tevkifat_all">
                            <tr>
                                <td style="text-align:left;background-color:white">
                                    #TEVKIFAT_ORAN# (#STATEMENT_RATE_NUMERATOR#/#STATEMENT_RATE_DENOMINATOR#)
                                </td>
                                <td style="text-align:right;background-color:white">
                                    #TLFormat(BEYAN_EDILEN)# <cfset total_beyan = total_beyan + BEYAN_EDILEN>
                                </td>
                                <td style="text-align:right;background-color:white">
                                    #TLFormat(TEVKIFAT_TUTARI)# <cfset total_tevkifat = total_tevkifat + TEVKIFAT_TUTARI>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td style="text-align:right;background-color:white" colspan="3">
                                <cf_get_lang dictionary_id='57484.Kayıt Yok'>!
                            </td>
                        </tr>
                    </cfif>
                    <cfoutput>
                        <tr>
                            <td class="txtbold" style="text-align:left;">
                                <cf_get_lang dictionary_id='57492.Toplam'>
                            </td>
                            <td class="txtbold" style="text-align:right;">
                                #TLFormat(total_beyan)#
                            </td>
                            <td class="txtbold" style="text-align:right;">
                                #TLFormat(total_tevkifat)#
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tfoot>
        </table>
    </cf_basket>
    <script type="text/javascript">
    function kontrol()
    {
        if(document.rapor.start_date.value != '' || document.rapor.finish_date.value != '')
        {
            document.rapor.sal_mon.disabled = true;
            document.rapor.sal_year.disabled = true;
        }
        else
        {
            document.rapor.sal_mon.disabled = false;
            document.rapor.sal_year.disabled = false;
        }
    }
    </script>  
    <cfsetting showdebugoutput="yes">