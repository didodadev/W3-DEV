<cfsetting showdebugoutput="no">
<cfquery name="GET_MY_SITE" datasource="#DSN#" maxrows="1">
	SELECT 
    	MENU_ID,
        GENERAL_WIDTH,
        GENERAL_WIDTH_TYPE,
        GENERAL_ALIGN 
    FROM 
    	MAIN_MENU_SETTINGS 
    WHERE 
    	IS_ACTIVE = 1 AND 
        SITE_TYPE = 4 AND 
        SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_HOST#"> 
    ORDER BY 
    	MENU_ID DESC
</cfquery>
<cfif not get_my_site.recordcount>
	Pda Portal Tanımı Yapılmamış
	<cfexit method="exittemplate">
<cfelse>
	<cfquery name="GET_SITE_PAGES" datasource="#DSN#">
		SELECT 
			MSLS.*,
			MSL.LEFT_WIDTH,
			MSL.RIGHT_WIDTH,
			MSL.CENTER_WIDTH,
			MSL.MARGIN
		FROM 
			MAIN_SITE_LAYOUTS_SELECTS MSLS,
			MAIN_SITE_LAYOUTS MSL
		WHERE 
			MSLS.FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listlast(attributes.fuseaction,'.')#"> AND
			MSLS.FACTION = MSL.FACTION AND
			MSLS.MENU_ID = MSL.MENU_ID AND
			MSL.MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_my_site.menu_id#">
	</cfquery>
	<cfif get_site_pages.recordcount>
		<cfset property_row_id_list = valuelist(get_site_pages.row_id)>
		<cfquery name="GET_ROW_PROPERTIES" datasource="#DSN#">
			SELECT ROW_ID, PROPERTY_NAME, PROPERTY_VALUE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID IN (#property_row_id_list#)
		</cfquery>
		<cfquery name="GET_1" dbtype="query">
            SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 1 ORDER BY ORDER_NUMBER
        </cfquery>
        <cfquery name="GET_2" dbtype="query">
            SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 2 ORDER BY ORDER_NUMBER
        </cfquery>
        <cfquery name="GET_3" dbtype="query">
            SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 3 ORDER BY ORDER_NUMBER
        </cfquery>
        <cfquery name="GET_4" dbtype="query">
            SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 4 ORDER BY ORDER_NUMBER
        </cfquery>
        <cfset cols_ = 0>
		<cfif get_1.recordcount>
            <cfset cols_ = cols_ + 1>
        </cfif>
        <cfif get_2.recordcount>
            <cfset cols_ = cols_ + 1>
        </cfif>
        <cfif get_3.recordcount>
            <cfset cols_ = cols_ + 1>
        </cfif>
		<table id="dynamic_table_main" border="0" cellpadding="0" cellspacing="0" <cfoutput><cfif not (fusebox.fuseaction contains 'popup_') and len(get_my_site.general_width)>style="width:#get_my_site.general_width##get_my_site.general_width_type#;"<cfelse>width="100%"</cfif> align="#get_my_site.general_align#"</cfoutput>>
			<cfif get_4.recordcount>
                <tr>	
                    <td colspan="<cfoutput>#cols_#</cfoutput>" style="vertical-align:top;">
						<cfoutput query="get_4">
							<cfset this_row_id_ = row_id>
							<cfset this_design_id_ = design_id>
							<cfif listfindnocase(property_row_id_list,row_id)>
								<cfquery name="GET_THIS_PROPERTIES" dbtype="query">
									SELECT PROPERTY_NAME,PROPERTY_VALUE FROM GET_ROW_PROPERTIES WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
								</cfquery>
								<cfloop query="get_this_properties">
									<cfset '#property_name#' = property_value>
								</cfloop>
							</cfif>
							<cfinclude template="../#object_folder#/#object_file_name#">
						</cfoutput>
                    </td>
                </tr>
            </cfif>
            <tr>
				<cfif get_1.recordcount>
					<td valign="top" width="<cfoutput>#get_site_pages.left_width#</cfoutput>" class="dynamic_page_left_back">
						<cfoutput query="get_1">
							<cfset this_row_id_ = row_id>
							<cfset this_design_id_ = design_id>
							<cfif listfindnocase(property_row_id_list,row_id)>
								<cfquery name="GET_THIS_PROPERTIES" dbtype="query">
									SELECT PROPERTY_NAME,PROPERTY_VALUE FROM GET_ROW_PROPERTIES WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
								</cfquery>
								<cfloop query="get_this_properties">
									<cfset '#property_name#' = property_value>
								</cfloop>
							</cfif>
							<cfinclude template="../#object_folder#/#object_file_name#">
						</cfoutput>
					</td>
				</cfif>
				<cfif get_2.recordcount>
					<td valign="top" width="<cfoutput>#get_site_pages.center_width#</cfoutput>" class="dynamic_page_left_back">
						<cfoutput query="get_2">
							<cfset this_row_id_ = row_id>
							<cfset this_design_id_ = design_id>
							<cfif listfindnocase(property_row_id_list,row_id)>
								<cfquery name="GET_THIS_PROPERTIES" dbtype="query">
									SELECT PROPERTY_NAME,PROPERTY_VALUE FROM GET_ROW_PROPERTIES WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
								</cfquery>
								<cfloop query="get_this_properties">
									<cfset '#property_name#' = property_value>
								</cfloop>
							</cfif>
							<cfinclude template="../#object_folder#/#object_file_name#">
						</cfoutput>
					</td>
				</cfif>
				<cfif get_3.recordcount>
					<td class="dynamic_page_left_back" style="vertical-align:top;width:<cfoutput>#get_site_pages.right_width#</cfoutput>px">
						<cfoutput query="get_3">
							<cfset this_row_id_ = row_id>
							<cfset this_design_id_ = design_id>
							<cfif listfindnocase(property_row_id_list,row_id)>
								<cfquery name="GET_THIS_PROPERTIES" dbtype="query">
									SELECT PROPERTY_NAME,PROPERTY_VALUE FROM GET_ROW_PROPERTIES WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
								</cfquery>
								<cfloop query="get_this_properties">
									<cfset '#property_name#' = property_value>
								</cfloop>
							</cfif>
							<cfinclude template="../#object_folder#/#object_file_name#">
						</cfoutput>
					</td>
				</cfif>
			</tr>
		</table>
	<cfelse>
		<cf_get_lang_main no ='614.Bu Action İçin Sayfa Tanımı Yapılmamış'>
	</cfif>
</cfif>

