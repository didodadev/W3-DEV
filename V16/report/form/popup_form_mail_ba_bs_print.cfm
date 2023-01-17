<cf_xml_page_edit fuseact="report.report_ba_bs_print">
<cfif isdefined('attributes.is_submit') and attributes.is_submit eq 1>
	<cfset Limit_ = 5000>
	<cfset bs_process_types = "6,48,50,52,53,56,57,58,62,66,531,532,561,121">
    <cfset ba_process_types = "12,49,51,54,55,59,60,61,63,64,65,68,591,592,601,690,691">
    <cfif len(attributes.process_type_ba) and len(attributes.process_type_bs)>
		<cfset attributes.process_type = attributes.process_type_ba&','&attributes.process_type_bs>
    <cfelseif len(attributes.process_type_ba)>
        <cfset attributes.process_type=attributes.process_type_ba>
    <cfelseif len(attributes.process_type_bs)>
        <cfset attributes.process_type=attributes.process_type_bs>
    </cfif>
    <cfif isdate(attributes.startdate)><cf_date tarih = "attributes.startdate"></cfif>
    <cfif isdate(attributes.finishdate)><cf_date tarih = "attributes.finishdate"></cfif>
	<cfquery name="GET_BA_BS" datasource="#DSN2#">
        SELECT 
            COMPANY_ID,
            CONSUMER_ID,
            EMAIL,
            FULLNAME,
            MEMBER_CODE,
            TAXOFFICE,
            TAXNO,
            TELCODE,
            TEL,
            FAX,
            TC_IDENTY_NO,
            CITY_ID,
            COUNTRY_ID,
            SUM(PAPER_COUNT_BA) BA_PAPER_COUNT,
            SUM(PAPER_COUNT_BS) BS_PAPER_COUNT,
            <cfif isDefined("BA_OTVTOTAL") and len(BA_OTVTOTAL)>
                SUM(BA_TOTAL+BA_OTVTOTAL) BA_TOTAL,
            <cfelse>
                SUM(BA_TOTAL) BA_TOTAL,
            </cfif>
            SUM(BS_TOTAL+BS_OTVTOTAL) BS_TOTAL,
            SUM(TAX_TOTAL) TAX_TOTAL,
            SUM(OTV_TOTAL) OTV_TOTAL
        FROM
        (
            SELECT
                COMPANY_ID,
                CONSUMER_ID,
                EMAIL,
                FULLNAME,
                MEMBER_CODE,
                TAXOFFICE,
                TAXNO,
                TELCODE,
                TEL,
                FAX,
                TC_IDENTY_NO,
                CITY_ID,
                COUNTRY_ID,
                COUNT(BA_COUNT) PAPER_COUNT_BA,
                COUNT(BS_COUNT) PAPER_COUNT_BS,
                SUM(BA_NETTOTAL-BA_DISCOUNT) BA_TOTAL,
                SUM(BS_NETTOTAL-BS_DISCOUNT) BS_TOTAL,
                SUM(TAX_TOTAL) TAX_TOTAL,
                SUM(BS_OTVTOTAL) BS_OTVTOTAL,
                SUM(BA_OTVTOTAL) BA_OTVTOTAL,
                SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL
            FROM
            (
                SELECT
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,				
                    I.COMPANY_ID,
                    NULL CONSUMER_ID,
                    C.FULLNAME,
                    C.MEMBER_CODE,
                    C.TAXOFFICE,
                    C.TAXNO,
                    C.COMPANY_TELCODE TELCODE,
                    C.COMPANY_TEL1 TEL,
                    C.COMPANY_FAX FAX,
                    (SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
                    C.CITY CITY_ID,
                    C.COUNTRY COUNTRY_ID,
                    C.COMPANY_EMAIL AS EMAIL,
                    SUM(I.TAXTOTAL)/COUNT(IR.INVOICE_ID) TAX_TOTAL,
                    <!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL
                FROM
                    INVOICE I,
                    INVOICE_ROW IR,
                    #dsn_alias#.COMPANY C
                WHERE
                    I.COMPANY_ID = C.COMPANY_ID AND
                    IR.INVOICE_ID = I.INVOICE_ID AND
                    C.COMPANY_EMAIL IS NOT NULL AND
                    C.COMPANY_EMAIL <> '' AND
                    I.IS_IPTAL = 0
                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
                        AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                    </cfif>
                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                        AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                    </cfif>
                    <cfif isdefined('attributes.company') and len(attributes.company)>
                        <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                            AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                        <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                            AND 1=0
                        </cfif>
                    </cfif>
                    <cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
                        AND I.COMPANY_ID IN (#attributes.row_company#)
                    <cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
                        AND 1=0
                    </cfif>
                    AND I.PROCESS_CAT IN (#attributes.process_type#)
                GROUP BY
                    I.INVOICE_CAT,
                    I.INVOICE_ID,
                    I.COMPANY_ID,
                    C.FULLNAME,
                    C.MEMBER_CODE,
                    C.TAXOFFICE,
                    C.TAXNO,
                    C.COMPANY_TELCODE,
                    C.COMPANY_TEL1,
                    C.COMPANY_FAX,
                    C.MANAGER_PARTNER_ID,
                    C.CITY,
                    C.COUNTRY,
                    I.SA_DISCOUNT,
                    C.COMPANY_EMAIL
            UNION ALL
                SELECT
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.INVOICE_ID ELSE NULL END AS BS_COUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN NULL ELSE I.INVOICE_ID END AS BA_COUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(IR.NETTOTAL) ELSE 0 END AS BS_NETTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(IR.NETTOTAL) END AS BA_NETTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN I.SA_DISCOUNT ELSE 0 END AS BS_DISCOUNT,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE I.SA_DISCOUNT END AS BA_DISCOUNT,				
                    NULL,
                    I.CONSUMER_ID,
                    C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
                    C.MEMBER_CODE,
                    C.TAX_OFFICE TAXOFFICE,
                    C.TAX_NO TAXNO,
                    C.MOBIL_CODE TELCODE,
                    C.MOBILTEL TEL,
                    C.CONSUMER_FAX FAX,
                    C.TC_IDENTY_NO,
                    C.HOME_CITY_ID CITY_ID,
                    C.HOME_COUNTRY_ID COUNTRY_ID,
                    C.CONSUMER_EMAIL AS EMAIL,
                    SUM(I.TAXTOTAL)/COUNT(I.INVOICE_ID) TAX_TOTAL,
                    <!--- SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) OTV_TOTAL --->
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) ELSE 0 END AS BS_OTVTOTAL,
                    CASE WHEN I.INVOICE_CAT IN (#bs_process_types#) THEN 0 ELSE SUM(ISNULL(I.OTV_TOTAL,0))/COUNT(IR.INVOICE_ID) END AS BA_OTVTOTAL
                FROM
                    INVOICE I,
                    INVOICE_ROW IR,
                    #dsn_alias#.CONSUMER C
                WHERE
                    I.CONSUMER_ID = C.CONSUMER_ID AND
                    IR.INVOICE_ID = I.INVOICE_ID AND
                    C.CONSUMER_EMAIL IS NOT NULL AND
                    C.CONSUMER_EMAIL <> '' AND
                    I.IS_IPTAL = 0
                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
                        AND I.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                    </cfif>
                    <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                        AND I.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                    </cfif>
                    <cfif isdefined('attributes.company') and len(attributes.company)>
                        <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                            AND 1=0
                        <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                            AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                        </cfif>
                    </cfif>
                    <cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
                        AND I.CONSUMER_ID IN (#attributes.row_consumer#)
                    <cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
                        AND 1=0
                    </cfif>
                    AND I.PROCESS_CAT IN (#attributes.process_type#)
                GROUP BY
                    I.INVOICE_CAT,
                    I.INVOICE_ID,
                    I.CONSUMER_ID,
                    C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
                    C.MEMBER_CODE,
                    C.TAX_OFFICE,
                    C.TAX_NO,
                    C.MOBIL_CODE,
                    C.MOBILTEL,
                    C.CONSUMER_FAX,
                    C.TC_IDENTY_NO,
                    C.HOME_CITY_ID,
                    C.HOME_COUNTRY_ID,
                    I.SA_DISCOUNT,
                    C.CONSUMER_EMAIL
            ) T1
            GROUP BY
                COMPANY_ID,
                CONSUMER_ID,
                FULLNAME,
                MEMBER_CODE,
                TAXOFFICE,
                TAXNO,
                TELCODE,
                TEL,
                FAX,
                TC_IDENTY_NO,
                CITY_ID,
                COUNTRY_ID,
                EMAIL
        UNION ALL
            SELECT
                COMPANY_ID,
                CONSUMER_ID,
                EMAIL,
                FULLNAME,
                MEMBER_CODE,
                TAXOFFICE,
                TAXNO,
                TELCODE,
                TEL,
                FAX,
                TC_IDENTY_NO,
                CITY_ID,
                COUNTRY_ID,
                COUNT(BA_COUNT) PAPER_COUNT_BA,
                COUNT(BS_COUNT) PAPER_COUNT_BS,
                SUM(BA_NETTOTAL) BA_TOTAL,
                SUM(BS_NETTOTAL) BS_TOTAL,
                SUM(TAX_TOTAL) TAX_TOTAL,
                SUM(BS_OTVTOTAL) BS_OTVTOTAL,
                SUM(BA_OTVTOTAL) BA_OTVTOTAL,
                SUM(BS_OTVTOTAL+BA_OTVTOTAL) OTV_TOTAL
            FROM
                (
                    SELECT
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
                        E.CH_COMPANY_ID COMPANY_ID,
                        NULL CONSUMER_ID,
                        FULLNAME,
                        C.MEMBER_CODE,
                        C.TAXOFFICE TAXOFFICE,
                        C.TAXNO TAXNO,
                        C.COMPANY_TELCODE TELCODE,
                        C.COMPANY_TEL1 TEL,
                        C.COMPANY_FAX FAX,
                        (SELECT CP.TC_IDENTITY FROM #dsn_alias#.COMPANY_PARTNER CP WHERE CP.PARTNER_ID = C.MANAGER_PARTNER_ID) TC_IDENTY_NO,
                        C.CITY CITY_ID,
                        C.COUNTRY COUNTRY_ID,
                        C.COMPANY_EMAIL AS EMAIL,
                        SUM(E.KDV_TOTAL) TAX_TOTAL,
                        <!--- SUM(OTV_TOTAL) OTV_TOTAL --->
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL
                    FROM
                        EXPENSE_ITEM_PLANS E,
                        #dsn_alias#.COMPANY C
                    WHERE
                        E.CH_COMPANY_ID = C.COMPANY_ID
                        AND C.COMPANY_EMAIL IS NOT NULL
                        AND C.COMPANY_EMAIL <> ''
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
                            AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                        </cfif>
                        <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                        </cfif>	
                        <cfif isdefined('attributes.company') and len(attributes.company)>
                            <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                            <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                AND 1 = 0
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.row_company") and Len(attributes.row_company)>
                            AND E.CH_COMPANY_ID IN (#attributes.row_company#)
                        <cfelseif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
                            AND 1=0
                        </cfif>
                        AND E.PROCESS_CAT IN (#attributes.process_type#)
                    GROUP BY
                        E.ACTION_TYPE,
                        E.EXPENSE_ID,
                        E.CH_COMPANY_ID,
                        CH_CONSUMER_ID,
                        FULLNAME,
                        C.MEMBER_CODE,
                        C.TAXOFFICE,
                        C.TAXNO,
                        C.COMPANY_TELCODE,
                        C.COMPANY_TEL1,
                        C.COMPANY_FAX,
                        C.MANAGER_PARTNER_ID,
                        C.CITY,
                        C.COUNTRY,
                        C.COMPANY_EMAIL
                UNION ALL
                    SELECT
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN E.EXPENSE_ID ELSE NULL END AS BS_COUNT,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN NULL ELSE E.EXPENSE_ID END AS BA_COUNT,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(TOTAL_AMOUNT) ELSE 0 END AS BS_NETTOTAL,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(TOTAL_AMOUNT) END AS BA_NETTOTAL,
                        NULL CH_COMPANY_ID,
                        E.CH_CONSUMER_ID CONSUMER_ID,
                        C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
                        C.MEMBER_CODE,
                        C.TAX_OFFICE TAXOFFICE,
                        C.TAX_NO TAXNO,
                        C.MOBIL_CODE TELCODE,
                        C.MOBILTEL TEL,
                        C.CONSUMER_FAX FAX,
                        C.TC_IDENTY_NO,
                        C.HOME_CITY_ID CITY_ID,
                        C.HOME_COUNTRY_ID COUNTRY_ID,
                        C.CONSUMER_EMAIL AS EMAIL,
                        SUM(E.KDV_TOTAL) TAX_TOTAL,
                        <!--- SUM(OTV_TOTAL) OTV_TOTAL --->
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN SUM(OTV_TOTAL) ELSE 0 END AS BS_OTVTOTAL,
                        CASE WHEN E.ACTION_TYPE IN (#bs_process_types#) THEN 0 ELSE SUM(OTV_TOTAL) END AS BA_OTVTOTAL
                    FROM
                        EXPENSE_ITEM_PLANS E,
                        #dsn_alias#.CONSUMER C
                    WHERE
                        E.CH_CONSUMER_ID = C.CONSUMER_ID
                        AND C.CONSUMER_EMAIL IS NOT NULL
                        AND C.CONSUMER_EMAIL <> ''
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate)>
                            AND E.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
                        </cfif>
                        <cfif isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND E.EXPENSE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                        </cfif>
                        <cfif isdefined('attributes.company') and len(attributes.company)>
                            <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
                                AND 1=0
                            <cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                            </cfif>
                        </cfif>
                        <cfif isDefined("attributes.row_consumer") and Len(attributes.row_consumer)>
                            AND E.CH_CONSUMER_ID IN (#attributes.row_consumer#)
                        <cfelseif isDefined("attributes.row_company") and Len(attributes.row_company)>
                            AND 1=0
                        </cfif>
                        AND E.PROCESS_CAT IN (#attributes.process_type#)
                    GROUP BY
                        E.ACTION_TYPE,
                        E.EXPENSE_ID,
                        E.CH_CONSUMER_ID,
                        C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME,
                        C.MEMBER_CODE,
                        C.TAX_OFFICE,
                        C.TAX_NO,
                        C.MOBIL_CODE,
                        C.MOBILTEL,
                        C.CONSUMER_FAX,
                        C.TC_IDENTY_NO,
                        C.HOME_CITY_ID,
                        C.HOME_COUNTRY_ID,
                        C.CONSUMER_EMAIL
                )EXP1
            GROUP BY
                COMPANY_ID,
                CONSUMER_ID,
                FULLNAME,
                MEMBER_CODE,
                TAXOFFICE,
                TAXNO,
                TELCODE,
                TEL,
                FAX,
                TC_IDENTY_NO,
                CITY_ID,
                COUNTRY_ID,
                EMAIL
        ) BA_BS
        GROUP BY
            COMPANY_ID,
            CONSUMER_ID,
            FULLNAME,
            MEMBER_CODE,
            TAXOFFICE,
            TAXNO,
            TELCODE,
            TEL,
            FAX,
            TC_IDENTY_NO,
            CITY_ID,
            COUNTRY_ID,
            EMAIL
        <cfif isDefined("attributes.total") and len(attributes.total)>
        HAVING
            SUM(BS_TOTAL) > = #attributes.total# OR SUM(BA_TOTAL) > = #attributes.total#
        </cfif> 
        ORDER BY
            BA_TOTAL DESC,
            BS_TOTAL DESC,
            FULLNAME
    </cfquery>
    <style type="text/css">
		.table,td {font-family: Verdana, Arial, Helvetica, sans-serif;}
		.font_text {font-size:11px;}
	</style>
    <cfoutput query="get_ba_bs">
    	<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#email#" subject="#getLang('report',1651)#" type="html">
            <table style="width:200mm;height:280mm;" border="0">
                <tr valign="top">
                    <td style="width:5mm;">&nbsp;</td>
                    <td><cfinclude template="../../objects/display/view_company_logo.cfm"></td>
                </tr>
                <tr valign="top">
                    <td style="width:5mm;">&nbsp;</td>
                    <td>
                        <table border="0">
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id='49699.Sayın Yetkili'>
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    381 Sıra Nolu Vergi Usul Kanunu Genel Tebliği gereğince, 213 sayılı Vergi Usul
                                    Kanununun (1) 148, 149 ve Mükerrer 257 nci maddelerinin verdiği yetkiye dayanılarak,
                                    362 Sıra Nolu Vergi Usul Kanunu Genel Tebliği (2) ile bilanço esasına göre defter tutan
                                    mükelleflerin belirli bir haddi aşan mal ve hizmet alımlarını "Mal ve Hizmet Alımlarına İlişkin
                                    Bildirim Formu (Form Ba)" ile; mal ve hizmet satışlarını ise "Mal ve Hizmet Satışlarına İlişkin
                                    Bildirim Formu (Form Bs)" ile vergilendirme dönemini takip eden ayın birinci gününden
                                    itibaren son günü akşamına kadar tebliğ etmesi gerektiği açıklanmıştır.
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    2010 ve izleyen yılların aylık dönemlerine ilişkin mal ve/veya hizmet alışları ile mal
                                    ve/veya hizmet satışlarına uygulanacak had 396 sıra no.lu Tebliğ ile #TLFormat(Limit_,0)# TL olarak belirlenmiştir.
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    #startdate#&nbsp;-&nbsp;#finishdate#  itibarı ile firmanız ile aramızda  düzenlenen fatura adedi ve
                                    tutarları aşağıdaki gibidir.
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    Firma bilgileriniz ile birlikte fatura adet ve  tutarlarını kontrol edip, mutabık olmanız
                                    halinde kaşeleyip imzalayarak, mutabık  olmadığınız takdirde firma bilgileriniz ile hesap
                                    ekstrenizi tarafımıza mail  veya faks yoluyla iletmenizi rica ederiz.
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr class="font_text">
                                <td><p align="justify" style="line-height: 18px;">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id='48814.Saygılarımızla'>
                                    </p>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr>
                                <td>
                                    <table border="0">
                                        <tr class="font_text">
                                            <td width="150"><cf_get_lang dictionary_id='34550.Firma Ünvanı'></td>
                                            <td>: #fullname#</td>
                                        </tr>
                                        <tr class="font_text">
                                            <td><cf_get_lang dictionary_id='58762.Vergi Dairesi'></td>
                                            <td>: #taxoffice#</td>
                                        </tr>
                                        <tr class="font_text">
                                            <td><cf_get_lang dictionary_id='56085.Vergi Numarası'></td>
                                            <td>: #taxno#</td>
                                        </tr>
                                        <tr class="font_text">
                                            <td><cf_get_lang dictionary_id='57499.Telefon'></td>
                                            <td>: <cfif Len(tel)>(#telcode#) #tel#<cfelse>&nbsp;</cfif></td>
                                        </tr>
                                        <tr class="font_text">
                                            <td><cf_get_lang dictionary_id='48358.Faks'></td>
                                            <td>: <cfif Len(fax)>#fax#<cfelse>&nbsp;</cfif></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr style="height:15px;"><td>&nbsp;</td></tr>
                            <tr><td class="formbold">#dateformat(attributes.startdate,dateformat_style)# - #dateformat(attributes.finishdate,dateformat_style)# <cf_get_lang dictionary_id='60649.Dönemi BA-BS Raporu'></td></tr>
                            <tr>
                                <td>
                                    <table border="0" width="100%" align="center">
                                        <tr align="left" class="font_text">
                                            <td width="25%"><u><cf_get_lang dictionary_id='34017.BA Belge Adedi'></u></td>
                                            <td width="25%"><u>BA <cf_get_lang dictionary_id='57673.Tutar'></u></td>
                                            <td width="25%"><u><cf_get_lang dictionary_id='33977.BS Belge Adedi'></u></td>
                                            <td width="25%"><u>BS <cf_get_lang dictionary_id='57673.Tutar'></u></td>
                                        </tr>
                                        <tr align="left" class="font_text">
                                            <td>#ba_paper_count#</td>
                                            <td>#TLFormat(ba_total)#</td>
                                            <td>#bs_paper_count#</td>
                                            <td >#TLFormat(bs_total)#</td>
                                        </tr>
                                        <tr><td height="50">&nbsp;</td></tr>
                                        <tr class="font_text">
                                            <td colspan="3">&nbsp;</td>
                                            <td><cf_get_lang dictionary_id='58957.İmza'></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <cfif isdefined("x_mail_info") and x_mail_info eq 0><!--- kullanıcı bilgisi--->
                        <td>
                        <table bgcolor="FFFFFF" align="<cfoutput>#get_template_dimension.template_align#" style="width:#get_template_dimension.template_width##get_template_dimension.template_unit#</cfoutput>"> 
                            <tr> 
                                <td width="20mm">&nbsp;</td>
                                <td align="<cfoutput>#get_template_dimension.template_align#</cfoutput>">
                                <hr noshade style="height:1px;">
                                    <cfquery name="Get_Employees" datasource="#dsn#">
                                        SELECT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_EMAIL,EXTENSION FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
                                    </cfquery>
                                    <cfquery name="Our_Company" datasource="#dsn#">
                                        SELECT 
                                            COMPANY_NAME NAME_,
                                            TEL_CODE TELCODE_,
                                            TEL TEL1_,
                                            TEL2 TEL2_,
                                            TEL3 TEL3_,
                                            FAX FAX_,
                                            ADDRESS ADDRESS_,
                                            EMAIL EMAIL_,
                                            WEB WEB_
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
                                    <table>
                                        <tr>
                                            <td colspan="2"><b>#Our_Company.NAME_#</b></td>
                                        </tr>
                                        <tr>
                                            <td colspan="2"><b>#session.ep.name# #session.ep.surname#</b></td>
                                        </tr>
                                        <tr>
                                            <td><cfif len(Our_Company.tel1_) or len(Our_Company.tel2_) or  len(Our_Company.tel3_)><b><cf_get_lang dictionary_id='87.Tel'>:</b> (#Our_Company.telcode_#) - #Our_Company.tel1_# &nbsp; #Our_Company.tel2_# &nbsp; #Our_Company.tel3_#</cfif>
												<cfif Len(Get_Employees.EXTENSION)><cf_get_lang dictionary_id='51669.Dahili'>:#Get_Employees.EXTENSION#</cfif>&nbsp;
                                            </td>
                                            <td><cfif len(Our_Company.fax_)><b><cf_get_lang dictionary_id='57488.Fax'>:</b> (#Our_Company.telcode_#) - #Our_Company.fax_#</cfif>&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" style="width:350px;">#Our_Company.address_#</td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">#Get_Employees.employee_email#</td>
                                        </tr>
                                        <tr>
                                            <td><a href="http://#Our_Company.web_#">#Our_Company.web_#</a></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        </td>
                    <cfelse><!--- sirket bilgisi --->
                        <td><cfinclude template="../../objects/display/view_company_info.cfm"></td>
                    </cfif>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                </tr>
            </table>
        </cfmail>
    </cfoutput>
    <script type="text/javascript">
		alert("49454.Mail gönderilmiştir !");
		window.close();
	</script>
<cfelse>
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='40372.BA - BS Raporları'></cfsavecontent>
	<cf_popup_box title="#title#">
    	<cfform name="form_mail" method="post" action="#request.self#?fuseaction=report.popup_report_ba_bs_mail&is_submit=1">
        	<cfif isDefined("attributes.company") and len(attributes.company)>
            	<input type="hidden" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>" />
            </cfif>
            <cfif isDefined("attributes.company_id") and len(attributes.company_id)>
            	<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>" />
            </cfif>
            <cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
            	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>" />
            </cfif>
        	<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
            	<input type="hidden" name="finishdate" id="finishdate" value="<cfoutput>#attributes.finishdate#</cfoutput>" />
            </cfif>
            <cfif isDefined("attributes.process_type") and len(attributes.process_type)>
            	<input type="hidden" name="process_type" id="process_type" value="<cfoutput>#attributes.process_type#</cfoutput>" />
            </cfif>
            <input type="hidden" name="process_type_ba" id="process_type_ba" value="<cfoutput>#attributes.process_type_ba#</cfoutput>" />
            <input type="hidden" name="process_type_bs" id="process_type_bs" value="<cfoutput>#attributes.process_type_bs#</cfoutput>" />
            <cfif isDefined("attributes.row_company") and len(attributes.row_company)>
            	<input type="hidden" name="row_company" id="row_company" value="<cfoutput>#attributes.row_company#</cfoutput>" />
            </cfif>
            <cfif isDefined("attributes.row_consumer") and len(attributes.row_consumer)>
            	<input type="hidden" name="row_consumer" id="row_consumer" value="<cfoutput>#attributes.row_consumer#</cfoutput>" />
            </cfif>
        	<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
            	<input type="hidden" name="startdate" id="startdate" value="<cfoutput>#attributes.startdate#</cfoutput>" />
            </cfif>
            <cfif isDefined("attributes.total") and len(attributes.total)>
            	<input type="hidden" name="total" id="total" value="<cfoutput>#attributes.total#</cfoutput>" />
            </cfif>
        	<table>
                <tr>
                	<td width="100%">&nbsp;</td>
                    <td align="right" nowrap><cf_workcube_buttons insert_info='Mail Gönder'></td>
                </tr>
            </table>
        </cfform>
   	</cf_popup_box>
</cfif>
