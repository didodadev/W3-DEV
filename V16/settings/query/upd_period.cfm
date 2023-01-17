<cfif not len(attributes.PERIOD_DATE)>
	<cfset attributes.PERIOD_DATE="01/01/#attributes.PERIOD_YEAR#">
</cfif>
<cfif not len(attributes.budget_period_date)>
	<cfset attributes.budget_period_date="01/01/#attributes.period_year#">
</cfif>
<cf_date tarih='attributes.PERIOD_DATE'>
<cf_date tarih='attributes.budget_period_date'>
<cfif attributes.IS_SPECIAL_PERIOD_DATE eq 1 and len(attributes.start_date) and len(attributes.finish_date)>
	<cfset attributes.start_date = attributes.start_date>
	<cfset attributes.finish_date = attributes.finish_date>
<cfelse>
	<cfset attributes.start_date="01/01/#attributes.PERIOD_YEAR#">
	<cfset attributes.finish_date="31/12/#attributes.PERIOD_YEAR#">
</cfif>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfif attributes.IS_SPECIAL_PERIOD_DATE eq 1>
	<cfquery name="get_old_db" datasource="#DSN#">
		SELECT
			PERIOD_YEAR,
			OUR_COMPANY_ID
		FROM
			SETUP_PERIOD
		WHERE
			OUR_COMPANY_ID = #COMPANY_ID# AND
			PERIOD_ID <> #PERIOD_ID# AND
			(
				((#attributes.start_date# BETWEEN START_DATE AND FINISH_DATE)
				 OR
				(#attributes.finish_date# BETWEEN START_DATE AND FINISH_DATE)) OR
				(
				(START_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)
				 OR
				(FINISH_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#)
				)
			)
	</cfquery>
	<cfif get_old_db.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='2514.Bu Firma ve Döneme ait Kayıt bulunmaktadır'>. Lütfen Tarih Aralığını Kontrol Ediniz!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfquery name="UPD_PERIOD" datasource="#dsn#">
	UPDATE 
		SETUP_PERIOD
	SET 
		PERIOD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#period_name#">,
		PERIOD_DATE = #attributes.PERIOD_DATE#,
		BUDGET_PERIOD_DATE = #attributes.BUDGET_PERIOD_DATE#,
		OTHER_MONEY = <cfif len(attributes.other_money)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#"><cfelse>NULL</cfif>,
		STANDART_PROCESS_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.standart_process_money#">,
		INVENTORY_CALC_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_calc_type#">,
		<cfif session.ep.admin>IS_LOCKED=<cfif isdefined("attributes.IS_LOCKED")>1,<cfelse>0,</cfif></cfif>
		IS_INTEGRATED=<cfif isdefined("attributes.IS_INTEGRATED")>1,<cfelse>0,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
		UPDATE_EMP = #SESSION.EP.USERID#,
		START_DATE = #attributes.start_date#,
		FINISH_DATE = #attributes.finish_date#,
		IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>
	WHERE 
		PERIOD_ID = #PERIOD_ID#
</cfquery>
<cfif PERIOD_YEAR eq 2009>
	<cfquery name="UPD_PERIOD" datasource="#dsn#">
		UPDATE
			SETUP_PERIOD
		SET
			STANDART_PROCESS_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="TL">
		WHERE
			STANDART_PROCESS_MONEY = 'YTL'
			AND PERIOD_ID = #PERIOD_ID#
	</cfquery>
	<cfquery name="UPD_PERIOD" datasource="#dsn#">
		UPDATE
			SETUP_PERIOD
		SET
			OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="TL">
		WHERE
			OTHER_MONEY = 'YTL'
			AND PERIOD_ID = #PERIOD_ID#
	</cfquery>
</cfif>
<cfquery name="upd_emp" datasource="#DSN#">
	UPDATE
		EMPLOYEE_POSITION_PERIODS
	SET 
		PERIOD_DATE = #attributes.PERIOD_DATE#,
		BUDGET_PERIOD_DATE =  #attributes.BUDGET_PERIOD_DATE#
	WHERE 
		PERIOD_ID=#PERIOD_ID#		
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_period" addtoken="no">
