<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="addDecisionmedicine" access="public" returntype="any">
		<cfargument name="barcode" type="string" required="no" default="">
		<cfargument name="decisionmedicine" type="string" required="no">
		<cfargument name="active_ingredient" type="string" required="no" default="">
		<cfargument name="CODE" type="string" required="no" default="">
		<cfquery name="INSERT_DECISIONMEDICINE" datasource="#DSN#"> 
			INSERT INTO 
				SETUP_DECISIONMEDICINE
			(
				DRUG_MEDICINE,
				ACTIVE_INGREDIENT,
				IS_DEFAULT,
				BARCODE,
				CODE,
				RECORD_IP,
				RECORD_DATE,
				RECORD_EMP
			) 
			VALUES 
			(
				<cfif len(arguments.decisionmedicine)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.decisionmedicine#"><cfelse>NULL</cfif>,
				<cfif len(arguments.active_ingredient)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.active_ingredient#"><cfelse>NULL</cfif>,
				<cfif isDefined("arguments.is_default") and arguments.is_default eq 1>1,<cfelse>0,</cfif>
				<cfif len(arguments.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#"><cfelse>NULL</cfif>,
				<cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
				'#cgi.remote_addr#',
				#now()#,
				#session.ep.userid#
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="updDecisionmedicine" access="public" returntype="any">
		<cfargument name="decision_medicine_id" type="numeric" required="yes">
		<cfargument name="barcode" type="string" required="no">
		<cfargument name="decision_medicine" type="string" required="no" default="">
		<cfargument name="active_ingredient" type="string" required="no" default="">
		<cfargument name="CODE" type="string" required="no" default="">
		<cfquery name="UPDATE_DECISIONMEDICINE" datasource="#DSN#">
			UPDATE 
				SETUP_DECISIONMEDICINE
			SET 
				DRUG_MEDICINE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.decision_medicine#">,
				ACTIVE_INGREDIENT = <cfif len(arguments.active_ingredient)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.active_ingredient#"><cfelse>NULL</cfif>,
				IS_DEFAULT =<cfif isDefined("arguments.is_default") and arguments.is_default eq 1>1,<cfelse>0,</cfif>
				BARCODE = <cfif len(arguments.barcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.barcode#"><cfelse>NULL</cfif>,
				CODE = <cfif len(arguments.code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code#"><cfelse>NULL</cfif>,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> 
			WHERE 
				DRUG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.decision_medicine_id#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getDecisionmedicine" access="public" returntype="query">
		<cfargument name="decision_medicine_id" type="numeric" required="no" default="0">
		<cfargument name="decision_medicine_id_list" type="string" required="no" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="DRUG_ID">
		<cfquery name="get_medicine_list" datasource="#dsn#">
			SELECT 
				*,
				#dsn#.Get_Dynamic_Language(DRUG_ID,'#session.ep.language#','SETUP_DECISIONMEDICINE','DRUG_MEDICINE',NULL,NULL,DRUG_MEDICINE) AS DRUG_MEDICINE_NEW
			FROM 
				SETUP_DECISIONMEDICINE
			WHERE
				1 = 1
				<cfif arguments.decision_medicine_id gt 0>
					AND DRUG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.decision_medicine_id#">
				<cfelseif len(decision_medicine_id_list) and decision_medicine_id_list neq 0>
					AND DRUG_ID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="yes" value="#arguments.decision_medicine_id_list#">)
				<cfelseif not len(decision_medicine_id_list) and decision_medicine_id_list neq 0>
					AND 1 = 0
				</cfif>
				<cfif isDefined("arguments.is_default") and len(arguments.is_default)>AND IS_DEFAULT = #arguments.is_default#</cfif>
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>AND DRUG_MEDICINE LIKE '%#arguments.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI </cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		
		<cfreturn get_medicine_list>
	</cffunction> 
</cfcomponent>

