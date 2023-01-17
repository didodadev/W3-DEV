<cf_get_lang_set module_name="stock">
<cfif not isDefined("attributes.dont")>
	<cfquery name="GET_ALL" datasource="#DSN#">
		SELECT 
			LOCATION_ID,
			DEPARTMENT_ID,
			ID
		FROM 
			STOCKS_LOCATION
		WHERE 
			LOCATION_ID = #LOCATION_ID# AND 
			DEPARTMENT_ID = #DEPARTMENT_ID#
	</cfquery>
	<!--- Diger lokasyonlarin priority si 0 laniyor. --->
	<cfif isdefined("attributes.priority") and attributes.priority eq 1>
		<cfquery name="UPD_LOCATION" datasource="#DSN#">
			UPDATE
				STOCKS_LOCATION
			SET
				PRIORITY = 0
			WHERE 
				DEPARTMENT_ID = #DEPARTMENT_ID#
		</cfquery>
	</cfif>
	<!--- // Diger lokasyonlarin priority si 0 laniyor. --->	
	<cfif get_all.recordcount eq 0>
		<cfquery name="UPD_STOCK_LOCATION" datasource="#DSN#">
			UPDATE 
				STOCKS_LOCATION
			SET
				DEPARTMENT_ID = #DEPARTMENT_ID#,
				LOCATION_ID = #LOCATION_ID#,
				<cfif isdefined("attributes.belongto_institution")>
					<cfif len(attributes.company_id) and len(attributes.member_name)>COMPANY_ID = #company_id#<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>CONSUMER_ID = #consumer_id#</cfif>,
				</cfif>
				DEPARTMENT_LOCATION = '#DEPARTMENT_ID#-#LOCATION_ID#',
				COMMENT ='#COMMENT#',
				LOCATION_TYPE = #LOCATION_TYPE#,
				STATUS = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>,
				PRIORITY = <cfif isdefined("attributes.priority")>1<cfelse>0</cfif>,
				IS_SCRAP = <cfif isdefined("attributes.is_scrap")>1<cfelse>0</cfif>,
				NO_SALE = <cfif isDefined("attributes.no_sale")>1<cfelse>0</cfif>,
				BELONGTO_INSTITUTION = <cfif isDefined("attributes.belongto_institution")>1<cfelse>0</cfif>,
				IS_END_OF_SERIES = <cfif isDefined("attributes.is_end_of_series")>1<cfelse>0</cfif>,
				IS_QUALITY = <cfif isDefined("attributes.is_quality")>1<cfelse>0</cfif>,
				WIDTH = <cfif len(attributes.width)>#attributes.width#<cfelse>NULL</cfif>,
				HEIGHT = <cfif len(attributes.height)>#attributes.height#<cfelse>NULL</cfif>,
				DEPTH = <cfif len(attributes.depth)>#attributes.depth#<cfelse>NULL</cfif>,
				DELIVERY = <cfif isdefined('attributes.delivery')>1<cfelse>0</cfif>,
				IS_COST_ACTION = <cfif isdefined('attributes.is_cost_action')>1<cfelse>0</cfif>,
				PRESSURE = <cfif isdefined("attributes.pressure") and len(attributes.pressure)>#attributes.pressure#<cfelse>NULL</cfif>,
				TEMPERATURE = <cfif isdefined("attributes.temperature") and len(attributes.temperature)>#attributes.temperature#<cfelse>NULL</cfif>,
				IS_RECYCLE_LOCATION = <cfif isDefined("attributes.is_recycle")>1<cfelse>0</cfif>
			WHERE
				DEPARTMENT_LOCATION LIKE '#attributes.DEP_LOC_ID#'
		</cfquery>
		
		<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
		<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>

		<cfif get_measure.recordcount>
			<cfoutput query="get_measure">
				<cfif isdefined("attributes.measure_existent_#MEASUREMENT_ID#")>
					<cfset get_measure_control = getComponent.STOCK_LOCATION_MEASUREMENT(stock_location_id : evaluate("attributes.measure_existent_#MEASUREMENT_ID#"))>
				<cfelse>
					<cfset get_measure_control = { recordcount:0 }>
				</cfif>
				<cfif get_measure_control.recordcount>
					<cfquery name="UPD_STOCK_MEASUREMENT" datasource="#DSN#">
						UPDATE 
							STOCK_LOCATION_MEASUREMENT
						SET 
							DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
							,LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
							,MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
							,MEASUREMENT_ROW_ID = <cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif> 
							,MEASUREMENT_VALUE = <cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
							,MIN_VALUE = <cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							,MAX_VALUE = <cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							,IT_ASSET_ID = <cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						WHERE 
							STOCK_LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.measure_existent_#MEASUREMENT_ID#")#">
					</cfquery>
				<cfelse>
					<cfquery name="ADD_STOCK_MEASUREMENT" datasource="#DSN#" result="MAX_ID">
						INSERT INTO [STOCK_LOCATION_MEASUREMENT]
						(
							[DEPARTMENT_ID]
							,[LOCATION_ID]
							,[MEASUREMENT_ID]
							,[MEASUREMENT_ROW_ID]
							,[MEASUREMENT_VALUE]
							,[MIN_VALUE]
							,[MAX_VALUE]
							,[IT_ASSET_ID]
						)
						VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
							,<cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
							,<cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							,<cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
							,<cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							,<cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							,<cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>


		<script type="text/javascript">
			wrk_opener_reload();
			window.close();
		</script>
		<cfelseif get_all.recordcount and (get_all.id eq attributes.id)>
			<cfquery name="UPD_STOCK_LOCATION" datasource="#DSN#">
				UPDATE 
					STOCKS_LOCATION
				SET
					DEPARTMENT_ID = #DEPARTMENT_ID#,
					LOCATION_ID = #LOCATION_ID#,
					<cfif isdefined("attributes.belongto_institution")>
						<cfif len(attributes.company_id) and len(attributes.member_name)>COMPANY_ID = #company_id#<cfelseif len(attributes.consumer_id) and len(attributes.member_name)>CONSUMER_ID = #consumer_id#</cfif>,
                    </cfif>
					DEPARTMENT_LOCATION = '#DEPARTMENT_ID#-#LOCATION_ID#',
					COMMENT = '#COMMENT#',
					LOCATION_TYPE = #location_type#,
					STATUS = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>,										
					PRIORITY = <cfif isdefined("attributes.priority")>1<cfelse>0</cfif>,
					IS_SCRAP = <cfif isdefined("attributes.is_scrap")>1<cfelse>0</cfif>,
					NO_SALE = <cfif isDefined("attributes.no_sale")>1<cfelse>0</cfif>,
					BELONGTO_INSTITUTION = <cfif isDefined("attributes.belongto_institution")>1<cfelse>0</cfif>,
					IS_END_OF_SERIES = <cfif isDefined("attributes.is_end_of_series")>1<cfelse>0</cfif>,
					IS_QUALITY = <cfif isDefined("attributes.is_quality")>1<cfelse>0</cfif>,
					WIDTH = <cfif len(attributes.width)>#attributes.width#<cfelse>NULL</cfif>,
					HEIGHT = <cfif len(attributes.height)>#attributes.height#<cfelse>NULL</cfif>,
					DEPTH = <cfif len(attributes.depth)>#attributes.depth#<cfelse>NULL</cfif>,
					DELIVERY = <cfif isdefined('attributes.delivery')>1<cfelse>0</cfif>,
					IS_COST_ACTION = <cfif isdefined('attributes.is_cost_action')>1<cfelse>0</cfif>,
					PRESSURE = <cfif isdefined("attributes.pressure") and len(attributes.pressure)>#attributes.pressure#<cfelse>NULL</cfif>,
					TEMPERATURE = <cfif isdefined("attributes.temperature") and len(attributes.temperature)>#attributes.temperature#<cfelse>NULL</cfif>,
					IS_RECYCLE_LOCATION = <cfif isDefined("attributes.is_recycle")>1<cfelse>0</cfif>
				WHERE
					ID = #attributes.ID#
			</cfquery>
			<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
			<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
				
			<cfif get_measure.recordcount>
				<cfoutput query="get_measure">
					<cfif isdefined("attributes.measure_existent_#MEASUREMENT_ID#")>
						<cfset get_measure_control = getComponent.STOCK_LOCATION_MEASUREMENT(stock_location_id : evaluate("attributes.measure_existent_#MEASUREMENT_ID#"))>
					<cfelse>
						<cfset get_measure_control = { recordcount:0 }>
					</cfif>
					<cfif get_measure_control.recordcount>
						<cfquery name="UPD_STOCK_MEASUREMENT" datasource="#DSN#">
							UPDATE 
								STOCK_LOCATION_MEASUREMENT
							SET 
								DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
								,LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
								,MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
								,MEASUREMENT_ROW_ID = <cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif> 
								,MEASUREMENT_VALUE = <cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
								,MIN_VALUE = <cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
								,MAX_VALUE = <cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
								,IT_ASSET_ID = <cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							WHERE 
								STOCK_LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="# evaluate("attributes.measure_existent_#MEASUREMENT_ID#")#">
						</cfquery>
					<cfelse>
						<cfquery name="ADD_STOCK_MEASUREMENT" datasource="#DSN#" result="MAX_ID">
							INSERT INTO [STOCK_LOCATION_MEASUREMENT]
							(
								[DEPARTMENT_ID]
								,[LOCATION_ID]
								,[MEASUREMENT_ID]
								,[MEASUREMENT_ROW_ID]
								,[MEASUREMENT_VALUE]
								,[MIN_VALUE]
								,[MAX_VALUE]
								,[IT_ASSET_ID]
							)
							VALUES
							(
								<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
								,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
								,<cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
								,<cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
								,<cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
								,<cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
								,<cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
								,<cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
							)
						</cfquery>
					</cfif>
				</cfoutput>
			</cfif>
            <cfset attributes.actionId = attributes.ID >
			<script type="text/javascript">
				wrk_opener_reload();
				window.close();
			</script>
		<cfelse>
			<script type="text/javascript">
				alert("<cf_get_lang no='41.Seçtiğiniz Lokasyon Kodu Kullanılıyor !'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
<cfelse>
	<!--- Diger lokasyonlarin priority si 0 laniyor. --->
	<cfif isdefined("attributes.priority") and attributes.priority eq 1>
		<cfquery name="UPD_LOCATION" datasource="#DSN#">
			UPDATE
				STOCKS_LOCATION
			SET
				PRIORITY = 0
			WHERE
				DEPARTMENT_ID = #DEPARTMENT_ID#
		</cfquery>
	</cfif>
	<!--- // Diger lokasyonlarin priority si 0 laniyor. --->
	 <cfquery name="UPD_STOCK_LOCATION" datasource="#DSN#">
		UPDATE 
			STOCKS_LOCATION
		SET
			<cfif isdefined("attributes.belongto_institution")>
				COMPANY_ID = <cfif len(attributes.company_id)>#COMPANY_ID#<cfelse>NULL</cfif>,
			<cfelse>
				COMPANY_ID = NULL,
			</cfif>
			COMMENT = '#COMMENT#',
			LOCATION_TYPE = #LOCATION_TYPE#,
			STATUS = <cfif isDefined("attributes.status")>1<cfelse>0</cfif>,			
			PRIORITY = <cfif isdefined("attributes.priority")>1<cfelse>0</cfif>,
			IS_SCRAP = <cfif isdefined("attributes.is_scrap")>1<cfelse>0</cfif>,
			NO_SALE = <cfif isDefined("attributes.no_sale")>1<cfelse>0</cfif>,
			BELONGTO_INSTITUTION = <cfif isDefined("attributes.belongto_institution")>1<cfelse>0</cfif>,
			IS_END_OF_SERIES = <cfif isDefined("attributes.is_end_of_series")>1<cfelse>0</cfif>,
			IS_QUALITY = <cfif isDefined("attributes.is_quality")>1<cfelse>0</cfif>,
			WIDTH = <cfif len(attributes.width)>#attributes.width#<cfelse>NULL</cfif>,
			HEIGHT = <cfif len(attributes.height)>#attributes.height#<cfelse>NULL</cfif>,
			DEPTH = <cfif len(attributes.depth)>#attributes.depth#<cfelse>NULL</cfif>,
			DELIVERY = <cfif isdefined('attributes.delivery')>1<cfelse>0</cfif>,
			IS_COST_ACTION = <cfif isdefined('attributes.is_cost_action')>1<cfelse>0</cfif>,
			PRESSURE = <cfif isdefined("attributes.pressure") and len(attributes.pressure)>#attributes.pressure#<cfelse>NULL</cfif>,
			TEMPERATURE = <cfif isdefined("attributes.temperature") and len(attributes.temperature)>#attributes.temperature#<cfelse>NULL</cfif>,
			IS_RECYCLE_LOCATION = <cfif isDefined("attributes.is_recycle")>1<cfelse>0</cfif>
		WHERE
			ID = #attributes.ID#
	</cfquery> 

	<cfset getComponent = createObject('component','V16.stock.cfc.measurement_parameters')>
	<cfset get_measure = getComponent.GET_MEASUREMENT_PARAMETERS()>
		
	<cfif get_measure.recordcount>
		<cfoutput query="get_measure">
			<cfif isdefined("attributes.measure_existent_#MEASUREMENT_ID#")>
				<cfset get_measure_control = getComponent.STOCK_LOCATION_MEASUREMENT(stock_location_id : evaluate("attributes.measure_existent_#MEASUREMENT_ID#"))>
			<cfelse>
				<cfset get_measure_control = { recordcount:0 }>
			</cfif>
			<cfif get_measure_control.recordcount>
				<cfquery name="UPD_STOCK_MEASUREMENT" datasource="#DSN#">
					UPDATE 
						STOCK_LOCATION_MEASUREMENT
					SET 
						DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
						,LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
						,MEASUREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
						,MEASUREMENT_ROW_ID = <cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif> 
						,MEASUREMENT_VALUE = <cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
						,MIN_VALUE = <cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						,MAX_VALUE = <cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						,IT_ASSET_ID = <cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
					WHERE 
						STOCK_LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.measure_existent_#MEASUREMENT_ID#")#">
				</cfquery>
			<cfelse>
				<cfquery name="ADD_STOCK_MEASUREMENT" datasource="#DSN#" result="MAX_ID">
					INSERT INTO [STOCK_LOCATION_MEASUREMENT]
					(
						[DEPARTMENT_ID]
						,[LOCATION_ID]
						,[MEASUREMENT_ID]
						,[MEASUREMENT_ROW_ID]
						,[MEASUREMENT_VALUE]
						,[MIN_VALUE]
						,[MAX_VALUE]
						,[IT_ASSET_ID]
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.DEPARTMENT_ID#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.LOCATION_ID#">
						,<cfqueryparam cfsqltype="cf_sql_integer" value="#MEASUREMENT_ID#">
						,<cfif len(evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.MEASUREMENT_ROW_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						,<cfif len(evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.MEASUREMENT_ID_#MEASUREMENT_ID#")#"> <cfelse>NULL</cfif>
						,<cfif len(evaluate("attributes.min_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.min_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						,<cfif len(evaluate("attributes.max_value_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("attributes.max_value_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
						,<cfif len(evaluate("attributes.it_asset_#MEASUREMENT_ID#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.it_asset_#MEASUREMENT_ID#")#"><cfelse>NULL</cfif>
					)
				</cfquery>
			</cfif>
		</cfoutput>
	</cfif>
	<cfset attributes.actionId = attributes.ID >
	<script type="text/javascript">
		location.href = document.referrer;
		window.close();
	</script>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
