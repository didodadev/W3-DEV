<!--- FBS 20121006 cfcye cevrildi, acil lazim oldugundan sadece selecti cevirip kullandim, add ve upd duzenlenmeli daha sonra --->
<cfcomponent>
	<cffunction name="getQualityControlType" access="public" returntype="query">
		<cfargument name="is_active" type="numeric" required="yes" default="1">
		<cfquery name="get_Quality_Control_Type" datasource="#dsn3#">
			SELECT 
			QT.TYPE_ID,
			QT.IS_ACTIVE,
			QT.QUALITY_CONTROL_TYPE,
			QT.TYPE_DESCRIPTION,
			QT.PROCESS_CAT_ID,
			QT.RECORD_EMP,
			QT.RECORD_DATE,
			QT.RECORD_IP,
			QT.UPDATE_EMP,
			QT.UPDATE_DATE,
			QT.UPDATE_IP,
			QR.QUALITY_CONTROL_TYPE_ID
			FROM 
				QUALITY_CONTROL_TYPE QT
				LEFT JOIN QUALITY_CONTROL_ROW AS QR ON QR.QUALITY_CONTROL_TYPE_ID = QT.TYPE_ID
			WHERE
				TYPE_ID IS NOT NULL
				<cfif isDefined("arguments.is_active") and Len(arguments.is_active)>
					AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bigint" value="#arguments.is_active#">
				</cfif>
			GROUP BY 
				QT.TYPE_ID,
				QT.IS_ACTIVE,
				QT.QUALITY_CONTROL_TYPE,
				QT.TYPE_DESCRIPTION,
				QT.PROCESS_CAT_ID,
				QT.RECORD_EMP,
				QT.RECORD_DATE,
				QT.RECORD_IP,
				QT.UPDATE_EMP,
				QT.UPDATE_DATE,
				QT.UPDATE_IP,
				QR.QUALITY_CONTROL_TYPE_ID
		</cfquery>
		<cfreturn get_Quality_Control_Type>
	</cffunction>
	<cffunction name="getProductQualityTypes" returntype="query">
		<cfargument name="product_id" required="no" default="">
		
		<cfquery name="get_Product_Quality_Types" datasource="#dsn3#">
			SELECT 
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
			
			FROM 
		    PRODUCT_QUALITY PO
			LEFT JOIN QUALITY_CONTROL_TYPE  AS QT ON QT.TYPE_ID = PO.QUALITY_TYPE_ID
			LEFT JOIN QUALITY_CONTROL_ROW AS QR ON QR.QUALITY_CONTROL_TYPE_ID = QT.TYPE_ID
			WHERE
				QT.TYPE_ID IS NOT NULL
				<cfif isDefined("arguments.product_id") and Len(arguments.product_id)>
					AND PO.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#">
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
</cfcomponent>
