<cfquery name="get_src" datasource="#dsn#">
    SELECT 
    	HIERARCHY
    FROM
    	SETUP_REPORT_CAT
    WHERE
    	REPORT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(attributes.report_cat_id)#">

</cfquery>	

<cfquery name="get_subcategories" datasource="#dsn#">
	SELECT
    	REPORT_CAT_ID
   	FROM
    	SETUP_REPORT_CAT
    WHERE
    	HIERARCHY LIKE '%#attributes.report_cat_id#.%'
</cfquery>

<cfif get_subcategories.recordcount>
	<script type="text/javascript">
		alert("Alt kategorisi olan kategorileri silemezsiniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="del_special_report_category" datasource="#dsn#">
    DELETE FROM
        SETUP_REPORT_CAT
    WHERE
        REPORT_CAT_ID = #attributes.REPORT_CAT_ID#
</cfquery>
    
<cflocation url="#request.self#?fuseaction=report.list_special_report_categories" addtoken="no">



