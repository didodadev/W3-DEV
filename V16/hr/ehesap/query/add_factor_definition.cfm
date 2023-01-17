<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfquery name="get_query" datasource="#dsn#">
    SELECT 
        ID, 
        STARTDATE, 
        FINISHDATE, 
        SALARY_FACTOR,
		BASE_SALARY_FACTOR,
		BENEFIT_FACTOR, 
        UPDATE_DATE,
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
        SALARY_FACTOR_DEFINITION 
    WHERE 
        STARTDATE < #DATEADD("d",1,attributes.finishdate)# 
    	AND FINISHDATE > #DATEADD("d",-1,attributes.startdate)# 
</cfquery>
<cfif get_query.recordcount gt 0>
	<script type="text/javascript">
		alert('Varolan tarihe tekrar tanim giremezsiniz!');
		<cfif not isdefined("attributes.draggable")>
			history.back();
		<cfelseif isdefined("attributes.draggable")>
			$('#factor_box .catalyst-refresh').click();
			closeBoxDraggable( 'add_factor_box' );
			return false;
		</cfif>
	</script>
	<cfabort>
</cfif>
<cfquery name="add_query" datasource="#dsn#">
	INSERT INTO SALARY_FACTOR_DEFINITION
		(
		STARTDATE,
		FINISHDATE,
		SALARY_FACTOR,
		BASE_SALARY_FACTOR,
		BENEFIT_FACTOR,
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE,
		FAMILY_ALLOWANCE_POINT,
		CHILD_BENEFIT_FIRST,
		CHILD_BENEFIT_SECOND,
		COLLECTIVE_AGREEMENT_BONUS_AMOUNT,
		COLLECTIVE_AGREEMENT_BONUS_MONTH,
		HIGHEST_CIVIL_SERVANT_SALARY,
		WEEKDAY_FEE,
		WEEKDAY_RATE 
		)
	VALUES
		(
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.SALARY_FACTOR#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BASE_SALARY_FACTOR#">,
		<cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BENEFIT_FACTOR#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		<cfif len(attributes.FAMILY_ALLOWANCE_POINT)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.FAMILY_ALLOWANCE_POINT#"><cfelse>NULL</cfif>,
		<cfif len(attributes.CHILD_BENEFIT_FIRST)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.CHILD_BENEFIT_FIRST#"><cfelse>NULL</cfif>,
		<cfif len(attributes.CHILD_BENEFIT_SECOND)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.CHILD_BENEFIT_SECOND#"><cfelse>NULL</cfif>,
		<cfif len(attributes.COLLECTIVE_AGREEMENT_BONUS_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.COLLECTIVE_AGREEMENT_BONUS_AMOUNT#"><cfelse>NULL</cfif>,
		<cfif len(attributes.collective_agreement_bonus_month)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.collective_agreement_bonus_month#"><cfelse>NULL</cfif>,
		<cfif len(attributes.highest_civil_servant_salary )><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.highest_civil_servant_salary#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.weekday_fee") and len(attributes.weekday_fee)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weekday_fee#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.weekday_rate") and len(attributes.weekday_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weekday_rate#"><cfelse>NULL</cfif>
		)
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.location.href = '<cfoutput>/index.cfm?fuseaction=ehesap.personal_payment</cfoutput>';
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#factor_box .catalyst-refresh').click();
		closeBoxDraggable( 'add_factor_box' );
	</cfif>
</script>

