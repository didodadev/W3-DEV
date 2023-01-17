<cfquery name="GET_SRC" datasource="#dsn#">
    SELECT 
    	REPORT_CAT
    FROM
    	SETUP_REPORT_CAT
    WHERE
    	REPORT_CAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.report_cat)#">
		<cfif isDefined('form.upper_cat_id') and len(form.upper_cat_id)>
	        AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.upper_cat_id#">
        </cfif>
</cfquery>	
<cfif GET_SRC.recordcount>
	<script type="text/javascript">
		alert("Aynı isimli kategori ekleyemezsiniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="ADD_SPECIAL_REPORT_CATEGORY" datasource="#DSN#" result="max_cat_id">
    INSERT INTO
        SETUP_REPORT_CAT
    (
        REPORT_CAT,
        DETAIL,
        RECORD_EMP,
        RECORD_IP,
        RECORD_DATE
    )
    VALUES
    (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_cat#">, 
        <cfif len(form.report_cat_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.report_cat_detail#"><cfelse>NULL</cfif>,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">, 
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">, 
        <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> 
    )
</cfquery>
<cfquery name="upd_cat_hirarchy" datasource="#dsn#">
    UPDATE SETUP_REPORT_CAT SET HIERARCHY = <cfif len(form.upper_cat_id)>'#form.upper_cat_id#.#max_cat_id.identitycol#'<cfelse>'#max_cat_id.identitycol#'</cfif> WHERE REPORT_CAT_ID = #max_cat_id.identitycol#
</cfquery>
<cflocation url="#request.self#?fuseaction=report.list_special_report_categories" addtoken="no">
