<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3="#dsn#_#session.ep.company_id#">
	<cfset dsn1="#dsn#_product">
	
	<cffunction name="get_stock_property" access="public">
	  <cfargument name="pid">
        <cfquery name="query_result" datasource="#dsn3#">
            SELECT
						RENK.PROPERTY_DETAIL AS RENK_,
						RENK.PROPERTY_DETAIL_ID AS RENK_ID,
						BEDEN.PROPERTY_DETAIL AS BEDEN_,
						BEDEN.PROPERTY_DETAIL_ID AS BEDEN_ID,
						BEDEN.PROPERTY_DETAIL_CODE,
						BOY.PROPERTY_DETAIL AS BOY_,
						BOY.PROPERTY_DETAIL_ID AS BOY_ID,
						STOCKS.STOCK_ID<!---,
						ASSORTMENT.ORDER_AMOUNT,
						ISNULL(ASSORTMENT.ASSORTMENT_AMOUNT,1) AS SUM_ASSORTMENT_AMOUNT,
						ISNULL(STOCKS.ASSORTMENT_AMOUNT,0) AS ASSORTMENT_AMOUNT--->
					FROM 
						#dsn1#.STOCKS
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_COLOR = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS RENK
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_SIZE = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS BEDEN
						OUTER APPLY
						(
							SELECT 
								PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
								PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
								PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_CODE
							FROM
								#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
								#dsn1#.PRODUCT_PROPERTY PRP,
								STOCKS_PROPERTY SP
							WHERE
								PRP.PROPERTY_ID = PPD.PRPT_ID AND
								SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
								PRP.PROPERTY_LEN = 1 AND 
								SP.STOCK_ID = STOCKS.STOCK_ID 
						) AS BOY
						
					WHERE 
						STOCKS.STOCK_STATUS = 1 AND
						STOCKS.PRODUCT_ID=#arguments.pid# AND
						RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
						BEDEN.PROPERTY_DETAIL IS NOT NULL
						ORDER BY RENK.PROPERTY_DETAIL

        </cfquery>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="get_measure_rows" access="public">
         <cfargument name="req_id">
        <cfquery name="query_result" datasource="#dsn3#">
            SELECT * FROM TEXTILE_MEASUREMENT_ROWS
            WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
        </cfquery>
        <cfreturn query_result>
    </cffunction>

    <cffunction name="delete_measure_rows" access="public">
        <cfargument name="req_id">
        <cfquery name="query_result" datasource="#dsn3#">
            DELETE FROM TEXTILE_MEASUREMENT_ROWS WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
        </cfquery>
    </cffunction>

	<cffunction name="insert_measure_rows" access="public">
        <cfargument name="req_id">
        <cfargument name="size">
        <cfargument name="detail">
        <cfargument name="detailen">
        <cfargument name="target">
        <cfargument name="yoh">
        <cfargument name="yog">
        <cfargument name="yod">
        <cfargument name="uoh">
        <cfargument name="uog">
        <cfargument name="uod">
        <cfargument name="ush">
        <cfargument name="usg">
        <cfargument name="usd">
        <cfquery name="query_result" datasource="#dsn3#">
            INSERT INTO 
				TEXTILE_MEASUREMENT_ROWS
					(
					REQUEST_ID, 
					STOCK_ID, 
					Detail, 
					DetailEN, 
					Target, 
					YOH, 
					YOG, 
					YOD, 
					UOH, 
					UOG, 
					UOD, 
					USH, 
					USG, 
					USD
					) 
				VALUES
					(
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>, 
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.size#'>, 
					<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detail#'>, 
					<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.detailen#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.target, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yoh, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yog, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yod, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uoh, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uog, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uod, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.ush, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usg, ',', '.')#'>, 
					<cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usd, ',', '.')#'>
					)
        </cfquery>
		
	</cffunction>
	
	<cffunction name="get_measure_header" access="public">
		<cfargument name="header_id">
		<cfquery name="query_result" datasource="#dsn3#">
			SELECT * FROM #dsn3#.TEXTILE_MEASUREMENT_HEADER WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#header_id#'>
		</cfquery>
		<cfreturn query_result>
	</cffunction>

	<cffunction name="get_measure_header_list" access="public">
		<cfargument name="req_id">
		<cfquery name="query_result" datasource="#dsn3#">
			SELECT HDR.*, OPP.REQ_NO, OPP.PRODUCT_ID
			FROM #dsn3#.TEXTILE_MEASUREMENT_HEADER HDR
			INNER JOIN #dsn3#.TEXTILE_SAMPLE_REQUEST OPP ON HDR.REQUEST_ID = OPP.REQ_ID
			WHERE 1=1
			<cfif isDefined("arguments.req_id") and len(arguments.req_id)> 
			AND REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
			</cfif>
		</cfquery>
		<cfreturn query_result>
	</cffunction>

	<cffunction name="insert_measure_header" access="public">
		<cfargument name="req_id">
		<cfargument name="erate">
		<cfargument name="brate">
		<cfargument name="process_stage">
		<cfargument name="stretching_group" default="">
		<cfquery name="query_result" result="executing_result" datasource="#dsn3#">
			INSERT INTO #dsn3#.TEXTILE_MEASUREMENT_HEADER ( 
				REQUEST_ID, 
				<cfif len( arguments.erate )>ERATE, </cfif>
				<cfif len( arguments.brate )>BRATE, </cfif>
				PROCDATE,
				PROCESS_STAGE,
				STRETCHING_GROUP) 
			VALUES
			(
				<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>,
				<cfif len( arguments.erate )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.erate, ',', '.')#'>,</cfif>
				<cfif len( arguments.brate )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.brate, ',', '.')#'>,</cfif>
				GETDATE(),
				<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.process_stage#">,
				<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stretching_group#'>
			)
		</cfquery>
		<cfreturn executing_result.generatedkey>
	</cffunction>

	<cffunction name="update_measure_header" access="public">
		<cfargument name="header_id">
		<cfargument name="erate">
		<cfargument name="brate">
		<cfargument name="stretching_group" default="">
		<cfif len( arguments.erate ) or len( arguments.brate )>
		<cfquery name="query_result" datasource="#dsn3#">
			UPDATE #dsn3#.TEXTILE_MEASUREMENT_HEADER SET 
			<cfif len( arguments.erate )>ERATE = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.erate, ',', '.')#'>,</cfif>
			<cfif len( arguments.brate )>BRATE = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' value='#replace(arguments.brate, ',', '.')#' scale="2"></cfif>
			<cfif len(arguments.stretching_group)>,STRETCHING_GROUP = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.stretching_group#'></cfif>
			WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.header_id#'>
		</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="copy_measure_header" access="public">
		<cfargument name="source_id">
		<cfargument name="target_id">
		<cfargument name="req_id">
		<cfif len(arguments.target_id)>
			<cfquery name="query_source" datasource="#dsn3#">
				SELECT * FROM #dsn3#.TEXTILE_MEASUREMENT_HEADER WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_id#'>
			</cfquery>
			<cfquery name="query_target" datasource="#dsn3#">
				UPDATE #dsn3#.TEXTILE_MEASUREMENT_HEADER SET ERATE = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#query_source.ERATE#' null="#len(query_source.ERATE)?'no':'yes'#">, BRATE = <cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#query_source.BRATE#' null="#len(query_source.BRATE)?'no':'yes'#"> 
				WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.target_id#'>
			</cfquery>
			<cfreturn arguments.target_id>
		<cfelse>
			<cfquery name="query_result" result="executing_result" datasource="#dsn3#">
				INSERT #dsn3#.TEXTILE_MEASUREMENT_HEADER ( REQUEST_ID, ERATE, BRATE, PROCDATE )
				SELECT #arguments.req_id#, ERATE, BRATE, GETDATE() FROM #dsn3#.TEXTILE_MEASUREMENT_HEADER 
				WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_id#'>
			</cfquery>
			<cfreturn executing_result.generatedkey>
		</cfif>
	</cffunction>

	<cffunction name="get_measure_items" access="public">
		<cfargument name="req_id">
		<cfargument name="mh_id">
		<cfquery name="query_result" datasource="#dsn3#">
			SELECT * FROM #dsn3#.TEXTILE_MEASUREMENT_ITEMS
			WHERE REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
			AND HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mh_id#'>
			ORDER BY STOCK_ID
		</cfquery>
		<cfreturn query_result>
	</cffunction>

	<cffunction name="delete_measure_items" access="public">
		<cfargument name="mh_id">
		<cfquery name="query_result" datasource="#dsn3#">
			DELETE FROM #dsn3#.TEXTILE_MEASUREMENT_ITEMS WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mh_id#'>
		</cfquery>
	</cffunction>

	<cffunction name="insert_measure_items" access="public">
		<cfargument name="mh_id">		
		<cfargument name="req_id">
		<cfargument name="row_index">
		<cfargument name="ebtype">
		<cfargument name="measure_point">
		<cfargument name="serial_inc">
		<cfargument name="desc">
		<cfargument name="boy">
		<cfargument name="size">
		<cfargument name="target">
		<cfargument name="yoi">
		<cfargument name="yog">
		<cfargument name="yof">
		<cfargument name="uog">
		<cfargument name="usg">
		<cfargument name="usf">

		<cfquery name="query_result" datasource="#dsn3#">
			INSERT INTO
			#dsn3#.TEXTILE_MEASUREMENT_ITEMS
				(
					HEADER_ID, 
					<cfif len( arguments.req_id )> REQUEST_ID, </cfif> 
					<cfif len( arguments.row_index )> ROW_INDEX, </cfif> 
					<cfif len( arguments.boy )> BOY_ID, </cfif>
					<cfif len( arguments.size )> STOCK_ID, </cfif> 
					<cfif len( arguments.ebtype )> EBTYPE, </cfif> 
					<cfif len( arguments.measure_point )> MEASURE_POINT, </cfif> 
					<cfif len( arguments.serial_inc )> SERIAL_INC, </cfif>
					<cfif len( arguments.desc )> DESCRIPTION, </cfif> 
					<cfif len( arguments.target )> TARGET, </cfif>
					<cfif len( arguments.yoi )> YOI, </cfif>
					<cfif len( arguments.yog )> YOG, </cfif>
					<cfif len( arguments.yof )> YOF, </cfif>
					<cfif len( arguments.uog )> UOG, </cfif>
					<cfif len( arguments.usg )> USG, </cfif>
					<cfif len( arguments.usf )> USF </cfif>
				)
				VALUES
				(
					<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.mh_id#'>,
					<cfif len( arguments.req_id )><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>,</cfif>
					<cfif len( arguments.row_index )><cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.row_index#'>,</cfif>
					<cfif len( arguments.boy )><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.boy#'>,</cfif>
					<cfif len( arguments.size )><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.size#'>,</cfif>
					<cfif len( arguments.ebtype )><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.ebtype#'>,</cfif>
					<cfif len( arguments.measure_point )><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.measure_point#'>,</cfif>
					<cfif len( arguments.serial_inc )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.serial_inc, ',', '.')#'>,</cfif>
					<cfif len( arguments.desc )><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.desc#'>,</cfif>
					<cfif len( arguments.target )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.target, ',', '.' )#'>,</cfif>
					<cfif len( arguments.yoi )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yoi, ',', '.' )#'>,</cfif>
					<cfif len( arguments.yog )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yog, ',', '.' )#'>,</cfif>
					<cfif len( arguments.yof )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.yof, ',', '.' )#'>,</cfif>
					<cfif len( arguments.uog )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.uog, ',', '.' )#'>,</cfif>
					<cfif len( arguments.usg )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usg, ',', '.' )#'>,</cfif>
					<cfif len( arguments.usf )><cfqueryparam cfsqltype='CF_SQL_DECIMAL' scale="2" value='#replace(arguments.usf, ',', '.' )#'></cfif>
				)
		</cfquery>
	</cffunction>

	<cffunction name="copy_measure_items" access="public">
		<cfargument name="source_mh_id">
		<cfargument name="target_mh_id">
		<cfargument name="req_id">
		<cfquery name="query_delete" datasource="#dsn3#">
			DELETE FROM #dsn3#.TEXTILE_MEASUREMENT_ITEMS WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.target_mh_id#'>
		</cfquery>
		<cfquery name="query_result" datasource="#dsn3#">
			INSERT INTO #dsn3#.TEXTILE_MEASUREMENT_ITEMS
			(
				HEADER_ID, REQUEST_ID, ROW_INDEX, BOY_ID, STOCK_ID, EBTYPE, MEASURE_POINT, SERIAL_INC, DESCRIPTION, TARGET, YOI, YOG, YOF, UOG, USG, USF
			)
			SELECT #arguments.target_mh_id#, #arguments.req_id#, ROW_INDEX, BOY_ID, STOCK_ID, EBTYPE, MEASURE_POINT, SERIAL_INC, DESCRIPTION, TARGET, 0, 0, 0, 0, 0, 0
			FROM #dsn3#.TEXTILE_MEASUREMENT_ITEMS
			WHERE HEADER_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.source_mh_id#'>
		</cfquery>
	</cffunction>


</cfcomponent>