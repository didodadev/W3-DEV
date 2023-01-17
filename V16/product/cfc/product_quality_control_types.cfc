<cfcomponent extends="cfc.faFunctions">
	<cfset dsn=application.systemParam.systemParam().dsn>
	<cfset dsn3 = "#dsn#_#session.ep.company_id#">
	<cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
	<cffunction name="get_product_info" access="public" returntype="query">
		<cfargument name="product_id"  default="">
		<cfquery name="get_product_info" datasource="#dsn3#">
			SELECT
				PRODUCT_CODE,
				PRODUCT_NAME,
				PRODUCT_CATID,
				QUALITY_START_DATE
			FROM
				PRODUCT
			WHERE
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
		</cfquery>
		<cfreturn get_product_info>
	</cffunction>
	<cffunction name="getQualityControlType" access="public" returntype="query">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfquery name="get_Quality_Control_Type" datasource="#dsn3#">
			SELECT 
			QT.TYPE_ID,
			QT.QUALITY_CONTROL_TYPE,
			QT.PROCESS_CAT_ID
			FROM 
				QUALITY_CONTROL_TYPE QT
			WHERE
				TYPE_ID IS NOT NULL
				<cfif isDefined("arguments.is_active") and Len(arguments.is_active)>
					AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">
				</cfif>
			GROUP BY 
			QT.TYPE_ID,
			QT.QUALITY_CONTROL_TYPE,
			QT.PROCESS_CAT_ID
		</cfquery>
		<cfreturn get_Quality_Control_Type>
	</cffunction>
	<cffunction name="getProductQualityTypes" returntype="query">
		<cfargument name="product_id" required="no" default="">
		<cfargument name="product_cat_id" default="">
		<cfquery name="get_Product_Quality_Types" datasource="#dsn3#">
			SELECT 
			PO.PRODUCT_CAT_ID,
			PO.PRODUCT_QUALITY_ID,
			PO.PRODUCT_ID,
			PO.QUALITY_TYPE_ID,
			PO.OPERATION_TYPE_ID,
			PO.ORDER_NO,
			PO.DEFAULT_VALUE,
			PO.TOLERANCE,
			PO.TOLERANCE_2,
			PO.QUALITY_RULE,
			PO.PROCESS_CAT,
			PO.QUALITY_SAMPLE_NUMBER,
			PO.QUALITY_SAMPLE_METHOD,
			PO.QUALITY_SAMPLE_TYPE,
			PO.RECORD_EMP,
			PO.RECORD_DATE,
			PO.RECORD_IP,
			QT.TYPE_ID,
			QT.QUALITY_CONTROL_TYPE,
			QT.TYPE_DESCRIPTION,
			QR.QUALITY_CONTROL_TYPE_ID
			
			FROM 
		    PRODUCT_QUALITY PO
			LEFT JOIN QUALITY_CONTROL_TYPE  AS QT ON QT.TYPE_ID = PO.QUALITY_TYPE_ID
			LEFT JOIN QUALITY_CONTROL_ROW AS QR ON QR.QUALITY_CONTROL_TYPE_ID = QT.TYPE_ID
			WHERE
			PO.QUALITY_RULE IS NOT NULL
			AND QT.TYPE_ID IS NOT NULL
			<cfif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					AND PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				</cfif>
				<cfif isDefined("arguments.product_id") and Len(arguments.product_id)>
					AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
			GROUP BY
				PO.PRODUCT_CAT_ID,
				PO.PRODUCT_ID,
				PO.QUALITY_TYPE_ID,
				PO.OPERATION_TYPE_ID,
				PO.ORDER_NO,
				PO.DEFAULT_VALUE,
				PO.TOLERANCE,
				PO.TOLERANCE_2,
				PO.QUALITY_RULE,
				PO.PROCESS_CAT,
				PO.QUALITY_SAMPLE_NUMBER,
				PO.QUALITY_SAMPLE_METHOD,
				PO.QUALITY_SAMPLE_TYPE,
				PO.RECORD_EMP,
				PO.RECORD_DATE,
				PO.RECORD_IP,
				QT.TYPE_ID,
				QT.QUALITY_CONTROL_TYPE,
				QT.TYPE_DESCRIPTION,
				QR.QUALITY_CONTROL_TYPE_ID
		</cfquery>
		<cfreturn get_Product_Quality_Types>
	</cffunction> 
	<cffunction name="getProductCatQualityTypes" returntype="query">
		<cfargument name="product_cat_id"  default="">
		<cfargument name="product_id"  default="">
		<cfargument name="OR_Q_ID"  default="">
		<cfquery name="get_Product_Cat_Quality_Types" datasource="#dsn3#">
			SELECT 
				QT.QUALITY_CONTROL_TYPE,
				PO.PROCESS_CAT AS PROCESS_CAT,
				PO.ORDER_NO,
				PO.QUALITY_TYPE_ID,
				QT.CONTENT_ID,
				PO.PRODUCT_QUALITY_ID
				<cfif len(arguments.OR_Q_ID)>
					,QRR.CONTROL_TYPE_ID 
					,QRR.MAIN_QUALITY_VALUE
				</cfif>
			FROM 
				PRODUCT_QUALITY PO
				LEFT JOIN QUALITY_CONTROL_TYPE  AS QT ON QT.TYPE_ID = PO.QUALITY_TYPE_ID
				<cfif len(arguments.OR_Q_ID)>
					LEFT JOIN ORDER_RESULT_QUALITY_ROW QRR ON QT.TYPE_ID = QRR.CONTROL_TYPE_ID
				</cfif>
			WHERE
				1=1
				<cfif len(arguments.product_id) and len(arguments.product_cat_id)>
			 		AND PO.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				<cfelseif not len(arguments.product_id) and len(arguments.product_cat_id)>
					OR PO.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"> 
				<cfelseif len(arguments.product_id) and not len(arguments.product_cat_id)>
					AND PO.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
				 <cfif len(arguments.OR_Q_ID)>
					AND QRR.OR_Q_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.OR_Q_ID#">
				 </cfif>
			GROUP BY  
			<cfif len(arguments.OR_Q_ID)>
				QRR.CONTROL_TYPE_ID,
				QRR.MAIN_QUALITY_VALUE,
			</cfif>
				PO.QUALITY_TYPE_ID,
				QT.QUALITY_CONTROL_TYPE,
				PO.ORDER_NO,
				PO.PRODUCT_QUALITY_ID,
				PO.PROCESS_CAT,
				QT.CONTENT_ID
		</cfquery>
		<cfreturn get_Product_Cat_Quality_Types>
	</cffunction>
	<cffunction name="getProductSubCatQualityTypes" returntype="query">
		<cfargument name="control_type" default="">
		<cfargument name="or_q_id" default="">
		<cfquery name="get_Product_Sub_Cat_Quality_Types" datasource="#dsn3#">
			SELECT 
				QR.QUALITY_ROW_DESCRIPTION TYPE_DESCRIPTION,
				QR.SAMPLE_METHOD,
				QR.SAMPLE_NUMBER,
				QR.CONTROL_OPERATOR,
				QR.QUALITY_VALUE,
				QR.TOLERANCE,
				QR.TOLERANCE_2,
				QR.QUALITY_CONTROL_ROW_ID,
				QR.QUALITY_CONTROL_ROW	QUALITY_CONTROL_TYPE,
				QR.QUALITY_CONTROL_TYPE_ID,
				QR.UNIT
				<cfif len(arguments.or_q_id)>
					,ORQ.CONTROL_RESULT,
					ORQ.QUALITY_VALUE AS ROW_QUALITY_VALUE
				</cfif>
			FROM 
				QUALITY_CONTROL_ROW QR
				<cfif len(arguments.or_q_id)>,ORDER_RESULT_QUALITY_ROW ORQ</cfif>
			WHERE
			 	QUALITY_CONTROL_TYPE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#control_type#">
				
			<cfif len(arguments.or_q_id)>
				AND ORQ.CONTROL_ROW_ID= QR.QUALITY_CONTROL_ROW_ID
				AND ORQ.OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#or_q_id#">
			</cfif>
			GROUP BY 
				QR.QUALITY_CONTROL_TYPE_ID,
				QR.QUALITY_CONTROL_ROW,
				QR.QUALITY_CONTROL_ROW_ID,
				QR.QUALITY_ROW_DESCRIPTION,
				QR.SAMPLE_METHOD,
				QR.SAMPLE_NUMBER,
				QR.CONTROL_OPERATOR,
				QR.QUALITY_VALUE,
				QR.TOLERANCE,
				QR.TOLERANCE_2,
				QR.UNIT
				<cfif len(arguments.or_q_id)>
					,ORQ.CONTROL_RESULT,
					ORQ.QUALITY_VALUE
				</cfif>
				
		</cfquery>
		<cfreturn get_Product_Sub_Cat_Quality_Types>
	</cffunction>
	<cffunction name="getProductQuality" returntype="query" access="remote">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		<cfquery name="get_Product_Quality" datasource="#dsn3#">
			SELECT 
				PRODUCT_CAT_ID,
				PRODUCT_ID,
				QUALITY_TYPE_ID,
				OPERATION_TYPE_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				ORDER_NO
			FROM 
				PRODUCT_QUALITY
			WHERE
				1=1
				<cfif isDefined("arguments.product_cat_id") and Len(arguments.product_cat_id)>
					AND PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#">
				</cfif>
				<cfif isDefined("arguments.product_id") and Len(arguments.product_id)>
					AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfif>
		</cfquery>
		<cfreturn get_Product_Quality>
	</cffunction>
	<cffunction name="add_quality_types" access="remote" returntype="any">
		<cfargument name="product_cat_id" required="no" default="">
		<cfargument name="product_id" required="no" default="">
		<cfargument name="quality_type_id" default="">
		<cfargument name="operation_type_id" required="no" default="">
		<cfargument name="order_no" required="no" default="">
		<cfargument name="record_num_qt" default="">
		<cfargument name="is_upd" default="">
		<cfargument name="q_id" default="">
		<cfargument name="process_cat" default="">
		<cfloop from="1" to="#arguments.record_num_qt#" index="qt">
			<cfif isDefined("arguments.row_kontrol_qt#qt#") and Len(Evaluate('arguments.row_kontrol_qt#qt#'))><cfset row_kontrol_qt = Evaluate('arguments.row_kontrol_qt#qt#')><cfelse><cfset row_kontrol_qt = ""></cfif>
			<cfif isDefined("arguments.quality_type_id#qt#") and Len(Evaluate('arguments.quality_type_id#qt#'))><cfset quality_type_id = Evaluate('arguments.quality_type_id#qt#')><cfelse><cfset quality_type_id = ""></cfif>
			<cfif isDefined("arguments.op_id_list_#qt#") and Len(Evaluate('arguments.op_id_list_#qt#'))><cfset operation_type_id = Evaluate('arguments.op_id_list_#qt#')><cfelse><cfset operation_type_id = ""></cfif>
			<cfif isDefined("arguments.order_no#qt#") and Len(Evaluate('arguments.order_no#qt#'))><cfset order_no = Evaluate('arguments.order_no#qt#')><cfelse><cfset order_no = ""></cfif>
			<cfif isDefined("arguments.process_cat#qt#") and Len(Evaluate('arguments.process_cat#qt#'))><cfset process_cat = Evaluate('arguments.process_cat#qt#')><cfelse><cfset process_cat = ""></cfif>
			<cfif isDefined("arguments.q_id#qt#") and Len(Evaluate('arguments.q_id#qt#'))><cfset q_id = Evaluate('arguments.q_id#qt#')><cfelse><cfset q_id = 0></cfif>
			<cfif Evaluate("arguments.row_kontrol_qt#qt#") neq 0>
				<cfif Evaluate("arguments.row_kontrol_qt#qt#") eq 2>
					<cfquery name="add_product_quality_types" datasource="#dsn3#">
						INSERT INTO
							PRODUCT_QUALITY
						(
							PRODUCT_CAT_ID,
							PRODUCT_ID,
							QUALITY_TYPE_ID,
							OPERATION_TYPE_ID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							ORDER_NO,
							PROCESS_CAT	
						)
						VALUES     
						(
							<cfif Len(arguments.product_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.quality_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#quality_type_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.operation_type_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.operation_type_id#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif Len(arguments.order_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order_no#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>
						)
					</cfquery>
				<cfelseif Evaluate("arguments.row_kontrol_qt#qt#") eq 1>
					<cfquery name="upd_product_quality_types" datasource="#dsn3#">
						UPDATE
							PRODUCT_QUALITY
						SET
							PRODUCT_CAT_ID=<cfif Len(arguments.product_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_cat_id#"><cfelse>NULL</cfif>,
							PRODUCT_ID=<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
							QUALITY_TYPE_ID=<cfif Len(arguments.quality_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#quality_type_id#"><cfelse>NULL</cfif>,
							OPERATION_TYPE_ID=<cfif Len(arguments.operation_type_id)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.operation_type_id#"><cfelse>NULL</cfif>,
							UPDATE_EMP=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							UPDATE_DATE=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							UPDATE_IP=<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							ORDER_NO=<cfif Len(arguments.order_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.order_no#"><cfelse>NULL</cfif>,
							PROCESS_CAT	= <cfif Len(arguments.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#"><cfelse>NULL</cfif>
						WHERE
							PRODUCT_QUALITY_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.q_id#">
					</cfquery>
				</cfif>
			<cfelseif Evaluate("arguments.row_kontrol_qt#qt#") eq 0>
				<cfquery name="del_Product_Quality_Types" datasource="#dsn3#">
					DELETE FROM 
						PRODUCT_QUALITY
					WHERE
						PRODUCT_QUALITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.q_id#">
				</cfquery>
				<cfquery name="del_product_quality_parameters" datasource="#dsn3#">
					DELETE FROM 
						PRODUCT_QUALITY_CONTROL_ROW
					WHERE
						<cfif isDefined("arguments.q_id") and Len(arguments.q_id)>
							PRODUCT_QUALITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.q_id#">
						</cfif>
				</cfquery>
			</cfif>
		</cfloop>
		<script>
			closeBoxDraggable('quality_box');
			jQuery('#quality_control_cat_type .catalyst-refresh' ).click();
		</script>
	</cffunction>
	<cffunction name="get_quality_id" access="remote" returntype="query">
		<cfargument name="q_ids" default="">
		<cfargument name="product_id" default="">
		<cfargument name="product_q_id" default="">
		<cfquery name="get_quality_id" datasource="#dsn3#">
			SELECT
			PRODUCT_QUALITY_CONTROL_ROW_ID
			, PRODUCT_QUALITY_ID
			, PRODUCT_ID
			, QUALITY_TYPE_ID
			, PRODUCT_QUALITY_CONTROL_TYPE
			, SAMPLE_NUMBER
			, SAMPLE_METHOD
			, MIN_LIMIT
			, MAX_LIMIT
			, STANDART_VALUE
			, CONTROL_OPERATOR
			, DESCRIPTION
			, QUALITY_CONTROL_ROW_ID
			, AMOUNT
			,UNIT
			FROM 
			  	PRODUCT_QUALITY_CONTROL_ROW
			WHERE 
				1=1
				<cfif len(product_q_id)>
					AND PRODUCT_QUALITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_q_id#">
				</cfif>
				<cfif len(q_ids)>
			   		AND QUALITY_CONTROL_ROW_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#q_ids#">
				</cfif>
				<cfif len(product_id)>
					AND PRODUCT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
				</cfif>
		</cfquery>
		<cfreturn get_quality_id>
	</cffunction>
	<cffunction name="add_quality_type_rows" access="remote" returntype="any">
		<cfargument name="rowcount_" default="">
		<cfargument name="q_id" default="">
		<cfargument name="quality_type_id" default="">
		<cfargument name="sample_method" default="">
		<cfargument name="sample_number" default="">
		<cfargument name="min_limit" default="">
		<cfargument name="max_limit" default="">
		<cfargument name="standart_value" default="">
		<cfargument name="control_operator" default="">
		<cfargument name="type_description" default="">
		<cfargument name="quality_type_name" default="">
		<cfargument name="row_id" default="">
		<cfargument name="product_id" default="">
		<cfargument name="pro_q_id" default="">
		<cfargument name="amount" default="">
		<cfargument name="unit" default="">
		<cfargument name="q_start_date" default="">


		<cfloop from="1" to="#rowcount_#" index="i">
			<cfif isDefined("arguments.quality_type_id_#i#") and Len(Evaluate('arguments.quality_type_id_#i#'))><cfset quality_type_id = Evaluate('arguments.quality_type_id_#i#')><cfelse><cfset quality_type_id = ""></cfif>
			<cfif isDefined("arguments.sample_method_#i#") and Len(Evaluate('arguments.sample_method_#i#'))><cfset sample_method = Evaluate('arguments.sample_method_#i#')><cfelse><cfset sample_method = ""></cfif>
			<cfif isDefined("arguments.sample_number_#i#") and Len(Evaluate('arguments.sample_number_#i#'))><cfset sample_number = Evaluate('arguments.sample_number_#i#')><cfelse><cfset sample_number = ""></cfif>
			<cfif isDefined("arguments.min_limit_#i#") and Len(Evaluate('arguments.min_limit_#i#'))><cfset min_limit = Evaluate('arguments.min_limit_#i#')><cfelse><cfset min_limit = ""></cfif>
			<cfif isDefined("arguments.max_limit_#i#") and Len(Evaluate('arguments.max_limit_#i#'))><cfset max_limit = Evaluate('arguments.max_limit_#i#')><cfelse><cfset max_limit = ""></cfif>
			<cfif isDefined("arguments.standart_value_#i#") and Len(Evaluate('arguments.standart_value_#i#'))><cfset standart_value = Evaluate('arguments.standart_value_#i#')><cfelse><cfset standart_value = ""></cfif>
			<cfif isDefined("arguments.control_operator_#i#") and Len(Evaluate('arguments.control_operator_#i#'))><cfset control_operator = Evaluate('arguments.control_operator_#i#')><cfelse><cfset control_operator = ""></cfif>
			<cfif isDefined("arguments.type_description_#i#") and Len(Evaluate('arguments.type_description_#i#'))><cfset type_description = Evaluate('arguments.type_description_#i#')><cfelse><cfset type_description = ""></cfif>
			<cfif isDefined("arguments.q_id#i#") and Len(Evaluate('arguments.q_id#i#'))><cfset q_id = Evaluate('arguments.q_id#i#')><cfelse><cfset q_id = ""></cfif>
			<cfif isDefined("arguments.quality_type_name_#i#") and Len(Evaluate('arguments.quality_type_name_#i#'))><cfset quality_type_name = Evaluate('arguments.quality_type_name_#i#')><cfelse><cfset quality_type_name = ""></cfif>
			<cfif isDefined("arguments.pro_q_id#i#") and Len(Evaluate('arguments.pro_q_id#i#'))><cfset pro_q_id = Evaluate('arguments.pro_q_id#i#')><cfelse><cfset pro_q_id=0></cfif>
			<cfif isDefined("arguments.row_id#i#") and Len(Evaluate('arguments.row_id#i#'))><cfset row_id = Evaluate('arguments.row_id#i#')><cfelse><cfset row_id = ""></cfif>
			<cfif isDefined("arguments.amount_#i#") and Len(Evaluate('arguments.amount_#i#'))><cfset amount = Evaluate('arguments.amount_#i#')></cfif>
			<cfif isDefined("arguments.unit_#i#") and Len(Evaluate('arguments.unit_#i#'))><cfset unit = Evaluate('arguments.unit_#i#')></cfif>
			<cfif pro_q_id eq 0>
				<cfquery name="add_quality_type_rows" datasource="#dsn3#">
					INSERT INTO
						PRODUCT_QUALITY_CONTROL_ROW
						(
							PRODUCT_QUALITY_ID,
							PRODUCT_QUALITY_CONTROL_TYPE,
							QUALITY_TYPE_ID,
							QUALITY_CONTROL_ROW_ID,
							PRODUCT_ID,
							SAMPLE_METHOD,
							SAMPLE_NUMBER,
							MIN_LIMIT,
							MAX_LIMIT,
							STANDART_VALUE,
							CONTROL_OPERATOR,
							AMOUNT,
							UNIT,
							DESCRIPTION,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
						VALUES     
						(
							<cfif Len(arguments.q_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#q_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.quality_type_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.quality_type_name#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.quality_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#quality_type_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_method#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.sample_number)#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.min_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.min_limit)#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.max_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.max_limit)#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.standart_value)#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.control_operator)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.control_operator#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.amount)#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit#"><cfelse>NULL</cfif>,
							<cfif Len(arguments.type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type_description#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
				</cfquery>
			<cfelse>
				<cfquery name="upd_quality_type_rows" datasource="#dsn3#">
					UPDATE
						PRODUCT_QUALITY_CONTROL_ROW
					SET
						PRODUCT_QUALITY_ID= <cfif Len(arguments.q_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.q_id#"><cfelse>NULL</cfif>,
						PRODUCT_QUALITY_CONTROL_TYPE= <cfif Len(arguments.quality_type_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.quality_type_name#"><cfelse>NULL</cfif>,
						QUALITY_TYPE_ID= <cfif Len(arguments.quality_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#quality_type_id#"><cfelse>NULL</cfif>,
						PRODUCT_ID= <cfif Len(arguments.product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"><cfelse>NULL</cfif>,
						SAMPLE_METHOD= <cfif Len(arguments.sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_method#"><cfelse>NULL</cfif>,
						SAMPLE_NUMBER= <cfif Len(arguments.sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.sample_number)#"><cfelse>NULL</cfif>,
						MIN_LIMIT= <cfif Len(arguments.min_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.min_limit)#"><cfelse>NULL</cfif>,
						MAX_LIMIT= <cfif Len(arguments.max_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.max_limit)#"><cfelse>NULL</cfif>,
						STANDART_VALUE= <cfif Len(arguments.standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.standart_value)#"><cfelse>NULL</cfif>,
						CONTROL_OPERATOR= <cfif Len(arguments.control_operator)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.control_operator#"><cfelse>NULL</cfif>,
						AMOUNT=<cfif Len(arguments.amount)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(arguments.amount)#"><cfelse>NULL</cfif>,
						UNIT=<cfif Len(arguments.unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit#"><cfelse>NULL</cfif>,
						DESCRIPTION= <cfif Len(arguments.type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type_description#"><cfelse>NULL</cfif>,
						UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
					WHERE
						PRODUCT_QUALITY_CONTROL_ROW_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#pro_q_id#">
				</cfquery>
			</cfif>
			<cfif isdate(arguments.q_start_date) and len(arguments.q_start_date)>
				<cfquery name="upd_q_startdate" datasource="#dsn3#">
					UPDATE 
                    	PRODUCT 
                	SET  
						QUALITY_START_DATE = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.q_start_date#">
					WHERE 
                    	PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
				</cfquery>
			</cfif>
		</cfloop>
		<script>
			closeBoxDraggable('quality_box_');
			jQuery('#quality_control_cat_type .catalyst-refresh' ).click();
		</script>
	</cffunction>
</cfcomponent>