<!---
	Laboratuvar işlemleri ile numune alım işlemleri bağlantılı hale getirildi,
	onun dışında numune alımının stoktan düşürülmesi için stocks_row bağlantısı
	ve işlem kategorisi eklendi. İşlem tipi id: 961. Laboratuvar ekranlarının
	en kullanışlı hali için numune alımı da bu ekrana eklenecek.
--->

<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="saveSampling" access="public" returntype="any">
		<cfargument name = "sampling_id">
		<cfargument name = "process_cat">
		<cfargument name = "department_id">
		<cfargument name = "location_id">
		<cfargument name = "sampling_date">
		<cfargument name = "sampling_time">
		<cfargument name = "sample_analysis_id">

		<cfif isDefined('arguments.sampling_id') and len(arguments.sampling_id)>
			<cfquery name = "upd_sampling" datasource="#dsn#">
				UPDATE
					#dsn#.LAB_SAMPLING
				SET
					PROCESS_CAT = <cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
					DEPARTMENT_ID = <cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
					LOCATION_ID = <cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_DATE = #now()#,
					UPDATE_IP = '#cgi.remote_addr#',
					SAMPLING_DATE = #arguments.sampling_date#,
					SAMPLING_TIME = #arguments.sampling_time#,
					SAMPLE_ANALYSIS_ID = <cfif len(arguments.sample_analysis_id)>#arguments.sample_analysis_id#<cfelse>NULL</cfif>
				WHERE
					SAMPLING_ID = #arguments.sampling_id#
			</cfquery>

			<cfif len(arguments.sample_analysis_id)>
				<cfquery name = "upd_sample_analysis" datasource="#dsn#">
					UPDATE #dsn#.REFINERY_LAB_TESTS SET SAMPLING_ID = #arguments.sampling_id# WHERE REFINERY_LAB_TEST_ID = #arguments.sample_analysis_id#
				</cfquery>
			</cfif>

			<cfreturn arguments.sampling_id>
		<cfelse>
			<cfquery name = "add_sampling" datasource="#dsn#" result = "r">
				INSERT INTO
					#dsn#.LAB_SAMPLING
				(
					PROCESS_CAT,
					DEPARTMENT_ID,
					LOCATION_ID,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					OUR_COMPANY_ID,
					SAMPLING_DATE,
					SAMPLING_TIME,
					SAMPLE_ANALYSIS_ID
				) VALUES (
					<cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
					<cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#',
					#session.ep.company_id#,
					#arguments.sampling_date#,
					#arguments.sampling_time#,
					<cfif len(arguments.sample_analysis_id)>#arguments.sample_analysis_id#<cfelse>NULL</cfif>
				)
			</cfquery>

			<cfif len(arguments.sample_analysis_id)>
				<cfquery name = "upd_sample_analysis" datasource="#dsn#">
					UPDATE #dsn#.REFINERY_LAB_TESTS SET SAMPLING_ID = #r.identitycol# WHERE REFINERY_LAB_TEST_ID = #arguments.sample_analysis_id#
				</cfquery>
			</cfif>

			<cfreturn r.identitycol>
		</cfif>

	</cffunction>

	<cffunction name="saveSamplingRow" access="public" returntype="any">
		<cfargument name = "sampling_id">
		<cfargument name = "sampling_row_id">
		<cfargument name = "stock_id">
		<cfargument name = "product_id">
		<cfargument name = "description">
		<cfargument name = "lot_no">
		<cfargument name = "spect_var_id">
		<cfargument name = "serial_no">
		<cfargument name = "unit_id">
		<cfargument name = "sample_amount">
		<cfargument name = "department_id">
		<cfargument name = "location_id">
		<cfargument name = "sampling_date">
		<cfargument name = "sampling_time">

		<cfset filterNum = application.functions.filterNum>
		<cfset wrk_round = application.functions.wrk_round>

		<cfquery name = "checkStockAmount" datasource="#dsn#">
			SELECT
				SUM(STOCK_IN - STOCK_OUT) AS TOTAL_STOCK
			FROM
				#dsn2#.STOCKS_ROW SR
			WHERE
				1 = 1
				AND SR.STOCK_ID = #arguments.stock_id#
				AND SR.PRODUCT_ID = #arguments.product_id#
				AND SR.STORE = #arguments.department_id#
				AND SR.STORE_LOCATION = #arguments.location_id#
				<cfif len(arguments.spect_var_id)>
					AND SR.SPECT_VAR_ID = #arguments.spect_var_id#
				<cfelse>
					AND SR.SPECT_VAR_ID IS NULL
				</cfif>
				<cfif len(arguments.lot_no)>
					AND SR.LOT_NO = '#arguments.lot_no#'
				<cfelse>
					AND SR.LOT_NO IS NULL
				</cfif>
		</cfquery>

		<cfif len(arguments.sampling_row_id)>
			<cfquery name = "upd_sampling_row" datasource="#dsn#">
				UPDATE
					#dsn#.LAB_SAMPLING_ROW

				SET
					STOCK_ID = <cfif len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
					PRODUCT_ID = <cfif len(arguments.product_id)>#arguments.product_id#<cfelse>NULL</cfif>,
					DESCRIPTION = <cfif len(arguments.description)>'#arguments.description#'<cfelse>NULL</cfif>,
					LOT_NO = <cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>,
					SPECT_ID = <cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
					SERIAL_NO = <cfif len(arguments.serial_no)>'#arguments.serial_no#'<cfelse>NULL</cfif>,
					STOCK_UNIT_ID = <cfif len(arguments.stock_unit_id)>#arguments.sampling_id#<cfelse>NULL</cfif>,
					SAMPLE_AMOUNT = <cfif len(arguments.sample_amount)>#arguments.sample_amount#<cfelse>NULL</cfif>
				WHERE
					SAMPLING_ROW_ID = #arguments.sampling_row_id#
			</cfquery>

			<cfset r_identity_col = arguments.sampling_row_id>
		<cfelse>
			<cfquery name = "add_sampling_row" datasource="#dsn#" result = "r">
				INSERT INTO
					#dsn#.LAB_SAMPLING_ROW
				(
					SAMPLING_ID,
					STOCK_ID,
					PRODUCT_ID,
					DESCRIPTION,
					LOT_NO,
					SPECT_ID,
					SERIAL_NO,
					STOCK_UNIT_ID,
					SAMPLE_AMOUNT
				) VALUES (
					<cfif len(arguments.sampling_id)>#arguments.sampling_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.product_id)>#arguments.product_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.description)>'#arguments.description#'<cfelse>NULL</cfif>,
					<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>,
					<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.serial_no)>'#arguments.serial_no#'<cfelse>NULL</cfif>,
					<cfif len(arguments.stock_unit_id)>#arguments.stock_unit_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.sample_amount)>#filterNum(arguments.sample_amount)#<cfelse>NULL</cfif>
				)
			</cfquery>

			<cfset r_identity_col = r.identitycol>
		</cfif>

		<cfif checkStockAmount.total_stock gte filterNum(arguments.sample_amount)>
			<cfif filterNum(arguments.sample_amount) gt 0>
				<cfquery name="ADD_STOCK_ROW" datasource="#dsn#" result = "sr">
					INSERT INTO
						#dsn2#.STOCKS_ROW
						(
							UPD_ID,
							PRODUCT_ID,
							STOCK_ID,
							PROCESS_TYPE,
							STOCK_OUT,
							STORE,
							STORE_LOCATION,
							PROCESS_DATE,
							PROCESS_TIME,
							SPECT_VAR_ID,
							LOT_NO
						) VALUES (
							#arguments.sampling_id#,
							#arguments.product_id#,
							#arguments.stock_id#,
							961,
							#filterNum(arguments.sample_amount)#,
							#arguments.department_id#,
							#arguments.location_id#,
							#arguments.sampling_date#,
							#arguments.sampling_time#,
							<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
							<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>
						)
				</cfquery>

				<cfquery name = "upd_stock_row_id" datasource="#dsn#">
					UPDATE
						#dsn#.LAB_SAMPLING_ROW
					SET
						STOCK_ROW_ID = #sr.identitycol#
					WHERE
						SAMPLING_ROW_ID = #r_identity_col#
				</cfquery>
			</cfif>

			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>

	<cffunction name="getSampling" access="public" returntype="any">
		<cfargument name = "sampling_id">

		<cfquery name = "get_sampling" datasource="#dsn#">
			SELECT
				*
			FROM
				LAB_SAMPLING
			WHERE
				1 = 1
				<cfif isDefined('arguments.sampling_id') and len(arguments.sampling_id)>
				AND SAMPLING_ID = #arguments.sampling_id#
				</cfif>
				AND OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>

		<cfreturn get_sampling>

	</cffunction>

	<cffunction name="getSamplingRow" access="public" returntype="any">
		<cfargument name = "sampling_id">
		<cfquery name = "get_sampling_row" datasource="#dsn#">
			SELECT
				LSR.SAMPLING_ROW_ID,
				LSR.STOCK_ID,
				LSR.STOCK_UNIT_ID,
				S.STOCK_CODE,
				S.PROPERTY,
				P.PRODUCT_ID,
				P.PRODUCT_NAME,
				LSR.DESCRIPTION,
				LSR.LOT_NO,
				LSR.SPECT_ID AS SPECT_VAR_ID,
				'' AS SPECT_NAME,
				LSR.SERIAL_NO,
				0 AS STOCK_AMOUNT,
				PU.MAIN_UNIT AS STOCK_UNIT,
				LSR.SAMPLE_AMOUNT
			FROM
				LAB_SAMPLING_ROW LSR
					LEFT JOIN LAB_SAMPLING LS ON LS.SAMPLING_ID = LSR.SAMPLING_ID
					LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID = LSR.STOCK_ID
					LEFT JOIN #dsn3#.PRODUCT P ON P.PRODUCT_ID = S.PRODUCT_ID
					--LEFT JOIN #dsn3#.SPECTS SP ON SP.SPECT_VAR_ID = LSR.SPECT_VAR_ID
					LEFT JOIN #dsn3#.PRODUCT_UNIT PU ON PU.PRODUCT_UNIT_ID = LSR.STOCK_UNIT_ID
			WHERE
				LSR.SAMPLING_ID = #arguments.sampling_id#
				AND LS.OUR_COMPANY_ID = #session.ep.company_id#
		</cfquery>

		<cfreturn get_sampling_row>

	</cffunction>
</cfcomponent>