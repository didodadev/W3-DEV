<cf_get_lang_set module_name="stock">

<cfquery name="GET_ALL" datasource="#DSN#">
	SELECT 
		LOCATION_ID,
		DEPARTMENT_ID
	FROM 
		STOCKS_LOCATION
	WHERE 
		LOCATION_ID = #attributes.location_id# AND 
		DEPARTMENT_ID = #attributes.department_id#
</cfquery>
<!--- Diger lokasyonlarin priority si 0 laniyor. --->
<cfif isdefined("attributes.priority") and attributes.priority eq 1>
	<cfquery name="UPD_LOCATION" datasource="#DSN#">
		UPDATE
			STOCKS_LOCATION
		SET
			PRIORITY = 0
		WHERE
			DEPARTMENT_ID = #attributes.department_id#
	</cfquery>
</cfif>

<!--- // Diger lokasyonlarin priority si 0 laniyor. --->
<cfif not get_all.recordcount>
	<cfquery name="ADD_STOCK_LOCATION" datasource="#DSN#" result="MAX_ID">
		INSERT INTO 
			STOCKS_LOCATION
		(
			DEPARTMENT_ID,
			LOCATION_ID,
			<cfif len(attributes.company_id) and len(attributes.member_name)>COMPANY_ID,<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>CONSUMER_ID,</cfif>
			DEPARTMENT_LOCATION,
			COMMENT,
			STATUS,
			PRIORITY,
			LOCATION_TYPE,
			NO_SALE,
			DELIVERY,
			BELONGTO_INSTITUTION,
			IS_END_OF_SERIES,
			IS_QUALITY,
			IS_COST_ACTION
			<cfif len(attributes.WIDTH)>,WIDTH</cfif>
			<cfif len(attributes.HEIGHT)>,HEIGHT</cfif>
			<cfif len(attributes.DEPTH)>,DEPTH</cfif>
            ,IS_SCRAP
			,PRESSURE
			,TEMPERATURE
			,IS_RECYCLE_LOCATION
		)
	VALUES
		(
			#attributes.department_id#,
			#attributes.location_id#,
			<cfif len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#,<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#,</cfif>
			'#attributes.department_id#-#attributes.location_id#',
			'#attributes.comment#',
			<cfif isDefined("attributes.status")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.priority") and attributes.priority eq 1>1<cfelse>0</cfif>,
			#location_type#,
			<cfif isDefined("attributes.no_sale")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.delivery")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.belongto_institution")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.is_end_of_series")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.is_quality")>1<cfelse>0</cfif>,
			<cfif isDefined("attributes.is_cost_action")>1<cfelse>0</cfif>
			<cfif len(attributes.width)>,#attributes.width#</cfif>
			<cfif len(attributes.height)>,#attributes.height#</cfif>
			<cfif len(attributes.depth)>,#attributes.depth#</cfif>
			,<cfif isdefined("attributes.is_scrap")>1<cfelse>0</cfif>
			,<cfif isdefined("attributes.pressure") and len(attributes.pressure)>#attributes.pressure#<cfelse>NULL</cfif>
			,<cfif isdefined("attributes.temperature") and len(attributes.temperature)>#attributes.temperature#<cfelse>NULL</cfif>
			,<cfif isdefined("attributes.is_recycle")>1<cfelse>0</cfif>

		)
	</cfquery>
	<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
	<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
	<cfif get_measure.recordcount>
		<cfoutput query="get_measure">
			<cfquery name="ADD_STOCK_MEASUREMENT" datasource="#DSN#">
				INSERT INTO
				STOCK_LOCATION_MEASUREMENT
				(
					DEPARTMENT_ID
					,LOCATION_ID
					,MEASUREMENT_ID
					,MEASUREMENT_ROW_ID
					,MEASUREMENT_VALUE
					,MIN_VALUE
					,MAX_VALUE
					,IT_ASSET_ID
				)
				VALUES
				(
					#attributes.department_id#,
					#attributes.location_id#,
					#MEASUREMENT_ID#,
					<cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>,
					<cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
				)
			</cfquery>
		</cfoutput>
	</cfif>
    <cfset attributes.actionId = MAX_ID.IDENTITYCOL >
	<script type="text/javascript">
		location.href = document.referrer;
		window.close();
   </script>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='41.Seçtiğiniz Lokasyon Kodu Kullanılıyor !'>");
		history.back();
	</script>
	<cfabort>	
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
