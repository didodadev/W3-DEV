<cfquery name="get_menu_css" datasource="#dsn#">
	SELECT CSS_FILE FROM MAIN_MENU_SETTINGS WHERE MENU_ID = #attributes.menu_id#
</cfquery>
<cfquery name="get_object_design" datasource="#dsn#">
	SELECT 
    	DESIGN_ID, 
        DESIGN_NAME, 
        DESIGN_DETAIL, 
        DESIGN_PATH, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
	    MAIN_SITE_OBJECT_DESIGN 
    ORDER BY 
    	DESIGN_NAME
</cfquery>
<link rel="stylesheet" href="<cfoutput>#get_menu_css.css_file#</cfoutput>" type="text/css">
<table width="200" align="center">
	<cfoutput query="get_object_design">
        <tr>
            <td width="190" align="center">
                <cfsavecontent variable="content_class_name">
                	<cfif isdefined("class_css_name") and len(class_css_name)>#class_css_name#</cfif>
                </cfsavecontent>
                <cfsavecontent variable="content_header">#design_name#</cfsavecontent>
                <cfsavecontent variable="content">#design_detail#</cfsavecontent>
                <cfinclude template="../../../#design_path#"><br/>
            </td>
        </tr>
    </cfoutput>
</table>
