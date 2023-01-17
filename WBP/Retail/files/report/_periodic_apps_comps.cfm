<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.search_type_id" default="">

<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(now())#-1-1')>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = now()>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_search_types" datasource="#dsn_dev#">
	SELECT PC.TYPE_NAME,PC.TYPE_ID FROM SEARCH_TABLE_PROCESS_TYPES PC ORDER BY PC.TYPE_NAME
</cfquery>

<cfquery name="get_comp" datasource="#dsn#">
SELECT
    *
FROM
	(
        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and attributes.project_id neq 0>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(PP.PROJECT_ID AS NVARCHAR) AS COMP_CODE,
                PP.PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME TEDARIKCI_ADI,
                PP.PROJECT_HEAD AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC,
                PRO_PROJECTS PP
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                PP.PROJECT_ID = #attributes.project_id# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID = PP.COMPANY_ID
        <cfelse>
        	SELECT
                CAST(C.COMPANY_ID AS NVARCHAR) + '_' + CAST(0 AS NVARCHAR) AS COMP_CODE,
                0 AS PROJECT_ID,
                C.COMPANY_ID,
                C.NICKNAME AS TEDARIKCI_ADI,
                '' AS PROJE_ADI,
                C.MEMBER_CODE,
                C.CITY,
                CC.COMPANYCAT
            FROM
                COMPANY C,
                COMPANY_CAT CC
            WHERE
                C.COMPANY_ID = #attributes.cpid# AND
                C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
                C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
        </cfif>
        ) 
        T1
ORDER BY
    T1.TEDARIKCI_ADI ASC,
    T1.PROJE_ADI ASC
</cfquery>

<cfquery name="get_donemsel_rows" datasource="#dsn_dev#">
	SELECT
    	'0' AS TYPE,
        RECORD_DATE,
        (SELECT D.DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID = PROCESS_ROWS.DEPARTMENT_ID) AS DEPARTMENT_HEAD,
        (SELECT PC.TYPE_NAME FROM SEARCH_TABLE_PROCESS_TYPES PC WHERE PC.TYPE_ID = PROCESS_ROWS.PROCESS_TYPE) AS TIP,
        COST AS BRUT,
        PROCESS_DETAIL,
        QUANTITY,
        PERIOD,
        PROCESS_STARTDATE,
        PROCESS_FINISHDATE,
        ACTION_STARTDATE,
        ACTION_FINISHDATE,
        PAYMENT_DATE,
        PAID_DATE,
        COST,
        ISNULL(COST_PAID,0) ODENEN
    FROM
    	PROCESS_ROWS
    WHERE
    	<cfif listlen(attributes.search_type_id)>
        PROCESS_TYPE IN (#attributes.search_type_id#) AND
        </cfif>
        <cfif listlen(attributes.search_department_id)>
        DEPARTMENT_ID IN (#attributes.search_department_id#) AND
        </cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        PROJECT_ID = #attributes.project_id# AND
        </cfif>
    	COMPANY_ID = #attributes.cpid# AND
        COST > 0
	ORDER BY 
    	PROCESS_STARTDATE ASC
</cfquery>

<cfquery name="get_ff_rows" datasource="#dsn_dev#">
	SELECT 
    	'2' AS TYPE,
        INVOICE_DATE AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        CASE 
        	WHEN FF_TYPE = 0 THEN 'Fiyat Farkı'
            WHEN FF_TYPE = 1 THEN 'Kasa Çıkışı'
            ELSE 'Diğer' END AS TIP,
        SUM(FF_GROSS * AMOUNT) AS BRUT,
        '' AS PROCESS_DETAIL,
        SUM(AMOUNT) AS QUANTITY,
        1 AS PERIOD,
        INVOICE_DATE AS PROCESS_STARTDATE,
        INVOICE_DATE AS PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        PAID_DATE,
        SUM(FF_NET) AS COST,
        SUM(FF_PAID) AS ODENEN
    FROM 
    	INVOICE_FF_ROWS 
    WHERE 
    	COMP_CODE = '#get_comp.COMP_CODE#'
    GROUP BY
    	INVOICE_DATE,
        FF_TYPE,
        PAID_DATE
</cfquery>

<cfquery name="get_ciro_rows" datasource="#dsn_dev#">
	SELECT 
    	'1' AS TYPE,
        MIN(INVOICE_DATE) AS RECORD_DATE,
        '' AS DEPARTMENT_HEAD,
        '%' + CAST(REVENUE_RATE AS NVARCHAR) + ' CİRO PRİMİ' TIP,
        SUM(REVENUE_GROSS) AS BRUT,
        '' AS PROCESS_DETAIL,
        SUM(AMOUNT) AS QUANTITY,
        1 AS PERIOD,
        MIN(INVOICE_DATE) AS PROCESS_STARTDATE,
        MAX(INVOICE_DATE) AS PROCESS_FINISHDATE,
        GETDATE() AS ACTION_STARTDATE,
        GETDATE() AS ACTION_FINISHDATE,
        GETDATE() AS PAYMENT_DATE,
        PAID_DATE,
        SUM(REVENUE_NET) AS COST,
        SUM(REVENUE_PAID) AS ODENEN
    FROM 
    	INVOICE_REVENUE_ROWS 
    WHERE 
    	COMP_CODE = '#get_comp.COMP_CODE#'
    GROUP BY
        REVENUE_RATE,
        PAID_DATE
</cfquery>

<cfquery name="get_all_rows" dbtype="query">
	SELECT * FROM get_donemsel_rows
    UNION
    SELECT * FROM get_ff_rows
    UNION
    SELECT * FROM get_ciro_rows
ORDER BY
	TYPE ASC,
    PROCESS_STARTDATE ASC
</cfquery>

<table align="left" cellpadding="0" cellspacing="0">
<tr>
<td>

<cfsavecontent variable="header_"><cfoutput>#get_comp.TEDARIKCI_ADI# <cfif len(get_comp.PROJE_ADI)>(#get_comp.PROJE_ADI#)</cfif></cfoutput> Havuz İcmali</cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.periodic_apps_comps">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cfinput type="hidden" name="cpid" value="#attributes.cpid#">
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
    <cfinput type="hidden" name="project_id" value="#attributes.project_id#">
</cfif>
    <cf_big_list_search title="#header_#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>Departman</td>
                    <td>
                        <cf_multiselect_check 
                                query_name="get_departments_search"  
                                name="search_department_id"
                                option_text="Departman" 
                                width="180"
                                option_name="department_head" 
                                option_value="department_id"
                                value="#attributes.search_department_id#">
                    </td>
                    <td>Uygulama Tipi</td>
                    <td>
                        <cf_multiselect_check 
                                query_name="get_search_types"  
                                name="search_type_id"
                                option_text="Tip" 
                                width="180"
                                option_name="type_name" 
                                option_value="type_id"
                                value="#attributes.search_type_id#">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Başlangıç</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="startdate">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Bitiş</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="finishdate">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
    	<tr>
        	<th width="35">Sıra</th>
            <th>Kayıt Tar.</th>
            <th>Mağaza</th>
            <th>Uygulama Tipi</th>
            <th>Açıklama</th>
            <th>Adet</th>
            <th>Dönem</th>
            <th>Uygulama Baş.</th>
            <th>Uygulama Bit.</th>
            <th>Yapılış Baş.</th>
            <th>Yapılış Bit.</th>
            <th>Prim Ödeme T.</th>
            <th>Ödendiği T.</th>
            <th>Ciro</th>
            <th>Toplam</th>
            <th>Fatura Kesilmiş</th>
            <th>Bakiye</th>
            <th>Bitmemiş Dv. Uy.</th>
            <th>Bitmiş Fat. Kesilmemiş</th>
        </tr>
    </thead>
    <cfset rows_ = 0>
    <tbody>
           <cfoutput query="get_all_rows">
            <tr>
            	<td>#currentrow#</td>
                <td>#dateformat(record_date,'dd/mm/yyyy')#</td>
                <td>#DEPARTMENT_HEAD#</td>
                <td style="background-color:##bc8f8f;color:white;">#TIP#</td>
                <td>#PROCESS_DETAIL#</td>
                <td>#quantity#</td>
                <td>#period#</td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_STARTDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##90ff90;">#dateformat(PROCESS_FINISHDATE,'dd/mm/yyyy')#</td>
                <td style="background-color:##ffe4b5;"><cfif type eq 0>#dateformat(ACTION_STARTDATE,'dd/mm/yyyy')#</cfif></td>
                <td style="background-color:##ffe4b5;"><cfif type eq 0>#dateformat(ACTION_FINISHDATE,'dd/mm/yyyy')#</cfif></td>
                <td style="<cfif datediff('d',now(),PAYMENT_DATE) lte 0>color:red;</cfif>">#dateformat(PAYMENT_DATE,'dd/mm/yyyy')#</td>
                <td>#dateformat(PAID_DATE,'dd/mm/yyyy')#</td>
                <td style="text-align:right; background-color:##8fbc8f;"><cfif type eq 1>#tlformat(brut)#</cfif></td>
                <td style="text-align:right; background-color:##8fbc8f;">#tlformat(cost)#</td>
                <td style="text-align:right; background-color:##adff2f;">#tlformat(ODENEN)#</td>
                <td style="text-align:right; background-color:##afeeee;">#tlformat(cost - ODENEN)#</td>
                <td style="text-align:right; background-color:##ffedb5;">-</td>
                <td style="text-align:right; background-color:##fa8072;">-</td>
            </tr>
            </cfoutput>
    </tbody>
</cf_big_list>

</td>
</tr>
</table>