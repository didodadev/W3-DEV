<cfcomponent rest="true" restpath="/Protein">
	<cffunction name="get_product_cats"
				access="remote"
				httpmethod="GET"
				restpath="getXML/{xmlCode}"
				returntype="string"
				produces="text/xml">
		<cfargument name="xmlCode" required="yes" restargsource="path" default="" type="string">
		<cfset dsn = application.systemParam.systemParam().dsn>
		<cfset dsn_alias = "#dsn#">
		<cfset dsn3_alias = "#dsn#_1">
		<cfset dsn2_alias = "#dsn#_#year(now())#_1">
		<cfset dsn1_alias = "#dsn#_product">
		<cfset dsn1 = "#dsn#_product">
		<cfquery name="get_period" datasource="#dsn#">
			SELECT
				PERIOD_ID
			FROM
				SETUP_PERIOD
			WHERE
				PERIOD_YEAR = #year(now())# AND
				OUR_COMPANY_ID = 1
		</cfquery>		
		
		<cfset attributes.period_id = get_period.PERIOD_ID>
		<cfquery name="get_file" datasource="#dsn#">
			SELECT
				*
			FROM
				CREATED_XML_FILES
			WHERE
				FILE_NAME = '#arguments.xmlCode#.xml'
		</cfquery>
		
		<cfset product_list = "">		
		<cfif get_file.recordcount>
			<cfquery name="get_file_rows" datasource="#dsn#">
				SELECT
					*
				FROM
					CREATED_XML_FILES_ROWS
				WHERE
					XML_FILE_ID = #get_file.XML_FILE_ID#
			</cfquery>
			<cfset attributes.root = get_file.root>
			<cfset attributes.item = get_file.item>
			<cfset attributes.money_type = get_file.money_type>
			<cfif get_file_rows.recordcount>
				<cfoutput query="get_file_rows">
					<cfset 'attributes.#row_id#' = 1>
					<cfset 'attributes.#row_id#_text' = row_text_name>
				</cfoutput>
				<cfinclude template="/AddOns/protein/form/xml_data.cfm">
				<cfinclude template="/AddOns/protein/query/add_xml_file_inner.cfm">
			</cfif>
		</cfif>		
		<cfreturn product_list>
	</cffunction>
</cfcomponent>