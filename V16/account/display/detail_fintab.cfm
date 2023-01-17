<cfquery name="GET_RECORDS" datasource="#DSN3#">
	SELECT
		TABLE_NAME,
		USER_GIVEN_NAME,
		SOURCE,
		RECORD_DATE
	FROM
		SAVE_ACCOUNT_TABLES
	WHERE
		SAVE_ID = <cfqueryparam value = "#attributes.id#" CFSQLType = "cf_sql_integer">
</cfquery> 
<cfsavecontent variable="title_">
	<cfif GET_RECORDS.TABLE_NAME is 'SCALE_TABLE'>
		<cf_get_lang dictionary_id='54378.Mizan'>
	<cfelseif GET_RECORDS.TABLE_NAME is 'INCOME_TABLE'>
		<cf_get_lang dictionary_id='47263.Gelir Tablosu'>
	<cfelseif GET_RECORDS.TABLE_NAME is 'COST_TABLE'>
		<cf_get_lang dictionary_id='47359.Satılan Malların Maliyeti Tabloları'>
	<cfelseif GET_RECORDS.TABLE_NAME is 'BALANCE_TABLE'>
		<cf_get_lang dictionary_id='47270.Bilanço'>
	<cfelseif GET_RECORDS.TABLE_NAME is 'CASH_FLOW_TABLE'>
		<cf_get_lang dictionary_id='54453.Nakit Akış Tablosu Adı'>
	<cfelseif GET_RECORDS.TABLE_NAME is 'FUND_FLOW_TABLE'>
		<cf_get_lang dictionary_id='47272.Fon Akım Tablosu'>
	</cfif>	
</cfsavecontent>

<cf_box title="#dateformat(GET_RECORDS.RECORD_DATE,dateformat_style)# #getLang('','',59232)# #title_#:  #GET_RECORDS.USER_GIVEN_NAME#" uidrop="1" hide_table_column="1">
<cfoutput>#GET_RECORDS.SOURCE#</cfoutput>
</cf_box>

