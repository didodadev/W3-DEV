<cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
<cfsetting showdebugoutput="no">
<cfscript>
    function QueryRow(Query,Row) 
        {
        var tmp = QueryNew(Query.ColumnList);
        QueryAddRow(tmp,1);
        for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
        return tmp;
        }
    </cfscript>
<cfset toplu = 1>
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset attributes.group_id = "">
<cfinclude template="../query/get_puantaj_rows.cfm">
<cfif len(get_puantaj_rows.PUANTAJ_GROUP_IDS)>
    <cfset attributes.group_id = ValueList(get_puantaj_rows.PUANTAJ_GROUP_IDS,",")>
</cfif>
<cfinclude template="../query/get_program_parameter.cfm">
<cfset sayi = 0>
<cfset puantaj_list = "">
<cfset employee_list = "">
<cfoutput query="get_puantaj_rows">
    <cfset puantaj_list = listappend(puantaj_list,get_puantaj_rows.EMPLOYEE_PUANTAJ_ID,',')>
    <cfset employee_list = listappend(employee_list,get_puantaj_rows.EMPLOYEE_ID,',')>
</cfoutput>
<cfset puantaj_list=listsort(puantaj_list,"numeric","ASC",",")>
<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
<cfif listlen(puantaj_list)>
    <cfquery name="get_odeneks_all" datasource="#dsn#">
        SELECT 
            PUANTAJ_ID, 
            EMPLOYEE_PUANTAJ_ID, 
            COMMENT_PAY, 
            SSK, 
            TAX, 
            EXT_TYPE, 
            COMPANY_ID, 
            ACC_TYPE_ID,
            VERGI_ISTISNA_AMOUNT,
            VERGI_ISTISNA_TOTAL,
            PAY_METHOD,
            AMOUNT,
            AMOUNT_2,
            IS_INCOME,
            AMOUNT_PAY,
            COMMENT_TYPE
        FROM
            EMPLOYEES_PUANTAJ_ROWS_EXT 
        WHERE 
            EMPLOYEE_PUANTAJ_ID 
        IN 
            (#puantaj_list#) 
        ORDER BY 
            COMMENT_PAY
    </cfquery>
</cfif>
<cfif listlen(employee_list)>
    <cfquery name="get_ogis_all" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
        SELECT
            OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
            OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM,
            OGIR.EMPLOYEE_ID
        FROM
            EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
            EMPLOYEES_OZEL_GIDER_IND AS OGI
        WHERE
            OGIR.EMPLOYEE_ID IN (#employee_list#) AND
            OGI.PERIOD_YEAR = #attributes.SAL_YEAR# AND
            OGI.PERIOD_MONTH = #attributes.SAL_MON# AND
            OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
    </cfquery>

    <cfquery name="get_kumulatif_gelir_vergisi_all" datasource="#dsn#">
        SELECT 
            EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI,EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID ,EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI_MATRAH
        FROM 
            EMPLOYEES_PUANTAJ, EMPLOYEES_PUANTAJ_ROWS 
        WHERE 
            EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = #attributes.puantaj_type# AND
            EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
            EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year# AND 
            EMPLOYEES_PUANTAJ.SAL_MON < #attributes.SAL_MON# AND 
            EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#)
    </cfquery>
</cfif>

<!--- <link rel='stylesheet' href="../../../../css/assets/template/style.css" type='text/css'> --->

<div id="printBordro_">
    <cfloop query="get_puantaj_rows">
        <div <cfif currentrow neq 1>style="page-break-before: always"</cfif>>
            <cfset index_id = get_puantaj_rows.currentrow>
            <cfif index_id eq 1 or (index_id gt 1 and get_puantaj_rows.employee_id[index_id-1] neq get_puantaj_rows.employee_id[index_id])>
                <cfset attributes.employee_id = get_puantaj_rows.employee_id[index_id]>
                <cfquery name="GET_PUANTAJ_PERSONAL" dbtype="query">
                    SELECT 
                        *
                    FROM
                        get_puantaj_rows
                    WHERE
                        EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
                        AND PUANTAJ_ID = #get_puantaj_rows.PUANTAJ_ID#
                </cfquery>
                <cfif not GET_PUANTAJ_PERSONAL.recordcount>
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='53775.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap> <cf_get_lang dictionary_id='31712.veya Yetkiniz'></cfif> <cf_get_lang dictionary_id='58546.Yok'>!");
                        history.back();
                    </script>
                    <cfabort>
                </cfif>
                <cfquery name="get_ogis" dbtype="query"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
                    SELECT
                        OGI_DAMGA_TOPLAM,
                        OGI_ODENECEK_TOPLAM
                    FROM
                        get_ogis_all
                    WHERE
                        EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
                </cfquery>
                <cfif not get_ogis.recordcount>
                    <!--- 20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
                    <cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
                    <cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
                </cfif>
                <cfquery name="get_kumulatif_gelir_vergisi" dbtype="query">
                    SELECT SUM(GELIR_VERGISI) AS TOPLAM,SUM(GELIR_VERGISI_MATRAH) AS TOPLAM_MATRAH FROM get_kumulatif_gelir_vergisi_all WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
                </cfquery> 
                <cfquery name="get_odeneks" dbtype="query">
                    SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
                </cfquery>
                <cfquery name="get_kesintis" dbtype="query">
                    SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
                </cfquery>
                <cfquery name="get_vergi_istisnas" dbtype="query">
                    SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = #GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID# AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
                </cfquery>
                <cfquery name="get_kesintis_brut" datasource="#dsn#">
                    SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#" > AND FROM_SALARY = 1 AND EXT_TYPE IN (1,3) ORDER BY COMMENT_PAY
                </cfquery>
                <cfset icmal_type = "personal">
                
                <cfoutput query="get_puantaj_personal">
                    <cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
                    <cfset query_name = "temp_query_1">
                    <cfinclude template="view_icmal.cfm">
                </cfoutput>
                
            </cfif>
        </div>
    </cfloop>
</div>
<script>
    window.print();
</script>