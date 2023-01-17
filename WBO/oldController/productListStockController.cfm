<!--- Stoklarım --->
<cfparam name="attributes.keyword" default="">
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="authority_station_id_list" default="0">
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID,
		EXIT_DEP_ID 
	FROM 
		#dsn3_alias#.WORKSTATIONS W
	WHERE 
		W.ACTIVE = 1 AND
		W.EXIT_DEP_ID IS NOT NULL AND
		W.EMP_ID LIKE '%,#session.ep.userid#,%'
	ORDER BY 
		STATION_NAME
</cfquery>
<cfset authority_station_id_list = ValueList(get_w.station_id,',')>
<cfset exit_dep_id_list = ValueList(get_w.exit_dep_id,',')>
<cfif isdefined("attributes.is_form_submitted") and len(exit_dep_id_list)>
	<cfquery name="get_stocks" datasource="#dsn3#">
		SELECT
			PU.MAIN_UNIT,
			S.PRODUCT_ID,
			S.STOCK_CODE_2,
			S.PRODUCT_NAME,
			S.STOCK_ID,
			S.BARCOD,
			S.STOCK_CODE,
			S.PROPERTY,
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK
		FROM 
			STOCKS S,
			PRODUCT_UNIT PU,
			#dsn2_alias#.STOCKS_ROW SR
		WHERE
			S.PRODUCT_STATUS = 1 AND 
			S.IS_INVENTORY = 1 AND 
			PU.IS_MAIN = 1 AND
			S.STOCK_STATUS = 1 AND
			SR.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_ID = PU.PRODUCT_ID AND
			SR.STORE IN (#exit_dep_id_list#)
            <cfif isdefined('keyword') and len(keyword)>
            AND (S.STOCK_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            OR S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
            </cfif>
		GROUP BY
			PU.MAIN_UNIT,
			S.PRODUCT_ID,
			S.PRODUCT_NAME,
			S.STOCK_CODE_2,
			S.STOCK_ID,
			S.BARCOD,
			S.STOCK_CODE,
			S.PROPERTY
		ORDER BY S.PRODUCT_NAME, S.PROPERTY
	</cfquery>
<cfelse>
	<cfset get_stocks.recordcount = 0>
</cfif>
<cfif get_stocks.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_stocks.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted');</cfscript>
<style>
	.box_yazi {font-size:16px;border-color:#666666;font:bold} 
	.box_yazi_td {font-size:14px;border-color:#666666;} 
</style>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'production.list_stocks';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production/display/list_stocks.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	

</cfscript>
