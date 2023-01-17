<cfcomponent accessors="true">
	<cfset dsn = application.systemParam.systemParam().dsn>

	<cfparam name="this.sort_type" default="1">
	<cfparam name="this.sort_order" default="ASC">
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset p_baslangic = createodbcdatetime(createdatetime(sal_year,sal_mon,1))>
	<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
	<cfset p_bitis = createodbcdatetime(createdatetime(sal_year,sal_mon,aydaki_gun_sayisi))>

	<cfset attributes.sort_type = This.sort_type>
	<cfset attributes.sort_order = This.sort_order>
	
	<cfset attributes.sal_mon = month(p_baslangic)>
	<cfset attributes.sal_year = year(p_baslangic)>

	<cffunction name="get_offtime_cats" returntype="query">
		<cfquery name="get_offtime_cats_q" datasource="#this.dsn#">
			SELECT
				OFFTIMECAT_ID,
				#dsn#.Get_Dynamic_Language(OFFTIMECAT_ID,'#session.ep.language#','SETUP_OFFTIME','OFFTIMECAT',NULL,NULL,OFFTIMECAT) AS OFFTIMECAT,
				ISNULL(IS_PAID,0) AS UCRETLIMI
			FROM
				SETUP_OFFTIME
		</cfquery>
		<cfreturn get_offtime_cats_q/>
	</cffunction>
	
	<cffunction name="get_offtimes" returntype="query">
		<cfargument name="employee_ids" type="string" default="">
		<cfquery name="get_offtimes_q" datasource="#this.dsn#">
			SELECT
				O.EMPLOYEE_ID,
				O.OFFTIMECAT_ID,
				O.STARTDATE,
				O.FINISHDATE,
				EIO.START_DATE,
				EIO.FINISH_DATE,
				SO.OFFTIMECAT,
				O.OFFTIME_ID,
				O.RECORD_EMP,
				O.VALID,
				O.VALID_1,
				O.VALID_2,
				ISNULL(SO.IS_PAID,0) AS UCRETLIMI
			FROM
				OFFTIME O,
				SETUP_OFFTIME SO,
				EMPLOYEES_IN_OUT EIO
			WHERE
				(
					ISNULL(O.VALID,-1) <> 0
					AND
					ISNULL(O.VALID_1,-1) <> 0 
					AND 
					ISNULL(O.VALID_2,-1) <> 0
				) 
				AND
				EIO.START_DATE <= #p_bitis# AND
				(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
				O.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
				O.OFFTIMECAT_ID = SO.OFFTIMECAT_ID AND
				<cfif len(arguments.employee_ids)>
					O.EMPLOYEE_ID IN (#arguments.employee_ids#) AND
				</cfif>
				(
					(O.STARTDATE >= #p_baslangic# AND O.STARTDATE < #dateadd('d',1,p_bitis)#)
				OR
					(O.FINISHDATE >= #p_baslangic# AND O.FINISHDATE < #dateadd('d',1,p_bitis)#)
				)
		</cfquery>
		<cfreturn get_offtimes_q/>
	</cffunction>
	
	<cffunction name="get_emps" returntype="query">
		<cfquery name="get_emps_q" datasource="#this.dsn#">
			SELECT DISTINCT
				*
			FROM
				(
				SELECT
					(
					SELECT TOP 1
						B.BANK_NAME
					FROM
						EMPLOYEES_BANK_ACCOUNTS BA,
						SETUP_BANK_TYPES B
					WHERE
						BA.BANK_ID = B.BANK_ID AND
						BA.EMPLOYEE_ID = E.EMPLOYEE_ID AND
						BA.DEFAULT_ACCOUNT = 1
					) AS BANKA_ADI,
					(
					SELECT TOP 1
						BA.BANK_ACCOUNT_NO
					FROM
						EMPLOYEES_BANK_ACCOUNTS BA,
						SETUP_BANK_TYPES B
					WHERE
						BA.BANK_ID = B.BANK_ID AND
						BA.EMPLOYEE_ID = E.EMPLOYEE_ID AND
						BA.DEFAULT_ACCOUNT = 1
					) AS BANKA_HESAP,
					E.EMPLOYEE_STATUS,
					E.EMPLOYEE_ID,
					E.EMPLOYEE_NAME,
					E.EMPLOYEE_SURNAME,
					EIO.SURELI_IS_AKDI,
					EIO.SURELI_IS_FINISHDATE,
					EIO.PUANTAJ_GROUP_IDS,
					EIO.START_DATE,
					EIO.FINISH_DATE,
					EIO.DUTY_TYPE,
					EIO.SSK_STATUTE,
					EIO.IN_OUT_ID,
					EIO.GROSS_NET,
					EIO.SALARY_TYPE,
					EIO.VALID,
					EI.TC_IDENTY_NO,
					EI.BIRTH_DATE,
					E.GROUP_STARTDATE,
					ISNULL(E.KIDEM_DATE,EIO.START_DATE) AS KIDEM_DATE,
					ISNULL(E.IZIN_DATE,EIO.START_DATE) AS IZIN_DATE,
					ISNULL((SELECT TOP 1 SS.WEEK_OFFDAY FROM SETUP_SHIFTS SS WHERE SS.SHIFT_ID = EIO.SHIFT_ID),1) AS HAFTA_TATILI,
					(
						SELECT TOP 1 SPC.POSITION_CAT FROM EMPLOYEE_POSITIONS EP,SETUP_POSITION_CAT SPC WHERE EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND EP.IS_MASTER = 1 AND EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID
					) AS POS_NAME,
					B.SSK_NO,
					B.SSK_OFFICE
				FROM
					EMPLOYEES_IN_OUT EIO,
					EMPLOYEES_IDENTY EI,
					EMPLOYEES E,
					BRANCH B
				WHERE
					B.BRANCH_ID = #this.ssk_office# AND
					EIO.BRANCH_ID = B.BRANCH_ID AND
					EIO.START_DATE <= #p_bitis# AND
					(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
					EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
					E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
				) T1
			ORDER BY
				EMPLOYEE_NAME ASC,
				EMPLOYEE_SURNAME ASC
			</cfquery>
		<cfreturn get_emps_q/>
	</cffunction>
	<cffunction name="UPD_AGS_AGV" access="remote"  returntype="any">
		<cfargument name="emp_id" default="">
		<cfargument name="agv_value" default="">
		<cfargument name="ags_value" default="">
		<cfargument name="sal_mon" default="">
		<cfargument name="sal_year" default="">
		<cfargument name="ssk_office" default="">
		<cfargument name="type" default="">
		<cfquery name="GET_PUANTAJ_ID" datasource="#dsn#">
			SELECT 
				EPR.PUANTAJ_ID
			FROM
				EMPLOYEES_PUANTAJ EP,
				EMPLOYEES_PUANTAJ_ROWS EPR
			WHERE 
				EPR.PUANTAJ_ID = EP.PUANTAJ_ID 
				AND EP.SAL_MON = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_mon#">
				AND EP.SAL_YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_year#">
				AND EP.SSK_BRANCH_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.ssk_office#">
		</cfquery>
		<cfquery name="UPD_AGS_AGV" datasource="#dsn#">
			UPDATE 
				EMPLOYEES_PUANTAJ_ROWS
			SET
				<cfif arguments.type eq 1>TOTAL_TIME_TAX = <cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.agv_value#"></cfif>
				<cfif arguments.type eq 2>TOTAL_TIME_ARGE = <cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.ags_value#"></cfif>
			WHERE
				PUANTAJ_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#GET_PUANTAJ_ID.PUANTAJ_ID#"> AND 
				EMPLOYEE_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.emp_id#">
		</cfquery>
		<cfquery name="GET_TIMECOST_MONTHLY" datasource="#dsn#">
			SELECT 
				ROW_ID
			FROM
				EMPLOYEES_PUANTAJ_TIMECOST_MONTHLY 
			WHERE 
				SAL_MON = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_mon#"> AND
				SAL_YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_year#"> AND
				EMPLOYEE_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.emp_id#">
		</cfquery>
		<cfif GET_TIMECOST_MONTHLY.recordcount>
			<cfquery name="UPD_TIMECOST_MONTHLY" datasource="#dsn#">
				UPDATE 
					EMPLOYEES_PUANTAJ_TIMECOST_MONTHLY
				SET
					<cfif arguments.type eq 1>TAX_TIMECOST_DAY = <cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.agv_value#"></cfif>
					<cfif arguments.type eq 2>RD_TIMECOST_DAY = <cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.ags_value#"></cfif>
				WHERE
					SAL_MON = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_mon#"> AND 
					SAL_YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_year#"> AND
					EMPLOYEE_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.emp_id#"> 
			</cfquery>
		<cfelse>
			<cfif len(arguments.agv_value) and len(arguments.ags_value)>
				<cfdump var= "arguments.agv_value : #arguments.agv_value# ags_value: #arguments.ags_value#">
				<cfquery name="UPD_TIMECOST_MONTHLY" datasource="#dsn#">
					INSERT 
						EMPLOYEES_PUANTAJ_TIMECOST_MONTHLY
					(
						SAL_MON,
						SAL_YEAR,
						EMPLOYEE_ID,
						TAX_TIMECOST_DAY,
						RD_TIMECOST_DAY,
						RECORD_EMP,
						RECORD_IP,
						RECORD_DATE
					)
					VALUES
					(
						<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_mon#">,
						<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_year#">,
						<cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.emp_id#">,
						<cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.agv_value#">,
						<cfqueryparam CFSQLType = "cf_sql_float" value = "#arguments.ags_value#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				</cfquery>
			</cfif>
		</cfif>
	</cffunction>
	<cffunction name="GET_AGS_AGV" access="remote"  returntype="query">
		<cfargument name="emp_id" default="">
		<cfargument name="sal_mon" default="">
		<cfargument name="sal_year" default="">
		<cfquery name="GET_AGS_AGV" datasource="#dsn#">
			SELECT 
				RD_TIMECOST_DAY,
				TAX_TIMECOST_DAY
			FROM 
				EMPLOYEES_PUANTAJ_TIMECOST_MONTHLY 
			WHERE 
				SAL_MON = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_mon#">
				AND SAL_YEAR = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.sal_year#">
				AND EMPLOYEE_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#arguments.emp_id#">
		</cfquery>
		<cfreturn GET_AGS_AGV>
	</cffunction>
</cfcomponent>