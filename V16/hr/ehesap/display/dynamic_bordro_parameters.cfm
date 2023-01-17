<!--- sayfanın parametreleri url den gönderilmemesi için temp tabloya yazıldı --->
<cfoutput>
<cfquery name="get_temp_table" datasource="#dsn#">
    IF object_id('tempdb..##url_list_table') IS NOT NULL
       BEGIN DROP TABLE ##url_list_table END
</cfquery>
<cfquery name="temp_table" datasource="#dsn#">
    CREATE TABLE ##url_list_table 
    ( 
        HIERARCHY nvarchar(100),
        SAL_YEAR_END int,
        SAL_MON_END int,
        SAL_YEAR int,
        SAL_MON int,
        KEYWORD nvarchar(100),
        UPPER_POSITION_CODE2 int,
        UPPER_POSITION2 nvarchar(100),
        UPPER_POSITION nvarchar(100),
        UPPER_POSITION_CODE int,
        SORT_TYPE int,
        PRINT_ROW_COUNT int,
        PUANTAJ_TYPE int,
        B_OBJ_SIRA_HIDDEN nvarchar(Max),
        B_OBJ_HIDDEN nvarchar(Max),
        DEPARTMENT nvarchar(Max),
        BRANCH_ID nvarchar(Max)
    )
</cfquery>
<cfquery name="Add_url_str" datasource="#dsn#">
    INSERT INTO ##url_list_table 
    (
        HIERARCHY,
        SAL_YEAR_END,
        SAL_MON_END,
        SAL_YEAR,
        SAL_MON,
        KEYWORD,
        UPPER_POSITION_CODE2,
        UPPER_POSITION2,
        UPPER_POSITION,
        UPPER_POSITION_CODE,
        SORT_TYPE,
        PRINT_ROW_COUNT,
        PUANTAJ_TYPE,
        B_OBJ_SIRA_HIDDEN,
        B_OBJ_HIDDEN,
        DEPARTMENT,
        BRANCH_ID
    )
    VALUES
    (
        <cfif len(hierarchy)>#hierarchy#<cfelse>NULL</cfif>,
        #sal_year_end#,
        #sal_mon_end#,
        #sal_year#,
        #sal_mon#,
        <cfif len(keyword)>'#keyword#'<cfelse>NULL</cfif>,
        <cfif len(UPPER_POSITION_CODE2)>#UPPER_POSITION_CODE2#<cfelse>NULL</cfif>,
        <cfif len(UPPER_POSITION2)>''#UPPER_POSITION2#'<cfelse>NULL</cfif>,
        <cfif len(UPPER_POSITION)>'#UPPER_POSITION#'<cfelse>NULL</cfif>,
        <cfif len(UPPER_POSITION_CODE)>#UPPER_POSITION_CODE#<cfelse>NULL</cfif>,
        <cfif len(SORT_TYPE)>#SORT_TYPE#<cfelse>NULL</cfif>,
        <cfif len(PRINT_ROW_COUNT)>#PRINT_ROW_COUNT#<cfelse>NULL</cfif>,
        <cfif len(PUANTAJ_TYPE)>#PUANTAJ_TYPE#<cfelse>NULL</cfif>,
        <cfif len(B_OBJ_SIRA_HIDDEN)>'#B_OBJ_SIRA_HIDDEN#'<cfelse>NULL</cfif>,
        <cfif len(B_OBJ_HIDDEN)>'#B_OBJ_HIDDEN#'<cfelse>NULL</cfif>,	
        <cfif isdefined("department") and len(DEPARTMENT)>'#DEPARTMENT#'<cfelse>NULL</cfif>,
        <cfif len(attributes.BRANCH_ID)>'#attributes.BRANCH_ID#'<cfelse>NULL</cfif>
    )
</cfquery>
</cfoutput>
