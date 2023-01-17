<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.is_delete') and attributes.is_delete eq 1>
	<cfquery name="del_query" datasource="#dsn#">
		DELETE 
		FROM 
			SALARY_FACTOR_DEFINITION
		WHERE
			ID = #attributes.ID#
	</cfquery>
<cfelse>
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
			AND ID <> #attributes.ID# 
	</cfquery>
	<cfif get_query.recordcount>
		<script type="text/javascript">
			alert('Varolan tarihe tekrar tanım giremezsiniz!');
			<cfif not isdefined("attributes.draggable")>
				history.back();
			<cfelseif isdefined("attributes.draggable")>
				$('#factor_box .catalyst-refresh').click();
				closeBoxDraggable( 'add_factor_box' );
			</cfif>
		</script>
		<cfabort>
	</cfif>
	<cfquery name="UPD_QUERY" datasource="#dsn#">
		UPDATE SALARY_FACTOR_DEFINITION
		SET
			STARTDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.STARTDATE#">,
			FINISHDATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.FINISHDATE#">,
			SALARY_FACTOR = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.SALARY_FACTOR#">,
			BASE_SALARY_FACTOR = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BASE_SALARY_FACTOR#">,
			BENEFIT_FACTOR = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.BENEFIT_FACTOR#">,
			UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			FAMILY_ALLOWANCE_POINT = <cfif len(attributes.FAMILY_ALLOWANCE_POINT)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.FAMILY_ALLOWANCE_POINT#"><cfelse>NULL</cfif>,
			CHILD_BENEFIT_FIRST	= <cfif len(attributes.CHILD_BENEFIT_FIRST)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.CHILD_BENEFIT_FIRST#"><cfelse>NULL</cfif>,
			CHILD_BENEFIT_SECOND = <cfif len(attributes.CHILD_BENEFIT_SECOND)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.CHILD_BENEFIT_SECOND#"><cfelse>NULL</cfif>,
			COLLECTIVE_AGREEMENT_BONUS_AMOUNT = <cfif len(attributes.COLLECTIVE_AGREEMENT_BONUS_AMOUNT)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.COLLECTIVE_AGREEMENT_BONUS_AMOUNT#"><cfelse>NULL</cfif>,
			COLLECTIVE_AGREEMENT_BONUS_MONTH = <cfif isdefined("attributes.collective_agreement_bonus_month") and  len(attributes.collective_agreement_bonus_month)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.collective_agreement_bonus_month#"><cfelse>NULL</cfif>,
			HIGHEST_CIVIL_SERVANT_SALARY  = <cfif isdefined("attributes.highest_civil_servant_salary") and len(attributes.highest_civil_servant_salary)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.highest_civil_servant_salary#"><cfelse>NULL</cfif>,
			WEEKDAY_FEE = <cfif isdefined("attributes.weekday_fee") and len(attributes.weekday_fee)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weekday_fee#"><cfelse>NULL</cfif>,
			WEEKDAY_RATE = <cfif isdefined("attributes.weekday_rate") and len(attributes.weekday_rate)><cfqueryparam cfsqltype="cf_sql_float" value="#attributes.weekday_rate#"><cfelse>NULL</cfif>
		WHERE
			ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#factor_box .catalyst-refresh').click();
		closeBoxDraggable( 'add_factor_box' );
	</cfif>
</script>