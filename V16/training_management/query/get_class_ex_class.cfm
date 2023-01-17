<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfset bu_ay = Month(now())>
<cfset attributes.dun = date_add('m',-1,Now())>
<cfset attributes.bugun = Now()>
<cfif Len(attributes.date1)>
	<cf_date tarih='attributes.date1'>
</cfif>
<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and len(attributes.member_name)>
	<cfset GET_EMP_TRAN = cmp.GET_EMP_TRAN1(emp_id:attributes.emp_id)>
	<!--- <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
		SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
	</cfquery> --->
	<cfif get_emp_tran.recordcount>
		<cfset emp_class_id=valuelist(get_emp_tran.class_id,',')>
	<cfelse>
		<cfset emp_class_id="">
	</cfif>
<cfelseif isdefined("attributes.cons_id") and len(attributes.cons_id) and len(attributes.member_name)>
	<cfset GET_EMP_TRAN = cmp.GET_EMP_TRAN2(cons_id:attributes.cons_id)>
	<!--- <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
		SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cons_id#">
	</cfquery> --->
	<cfif get_emp_tran.recordcount>
		<cfset emp_class_id=valuelist(get_emp_tran.class_id,',')>
	<cfelse>
		<cfset emp_class_id="">
	</cfif>
<cfelseif isdefined("attributes.par_id") and len(attributes.par_id) and len(attributes.member_name)>
	<cfset GET_EMP_TRAN = cmp.GET_EMP_TRAN3(par_id:attributes.par_id)>
	<!--- <cfquery name="GET_EMP_TRAN" datasource="#DSN#">
		SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">
	</cfquery> --->
	<cfif get_emp_tran.recordcount>
		<cfset emp_class_id=valuelist(get_emp_tran.class_id,',')>
	<cfelse>
		<cfset emp_class_id="">
	</cfif>
</cfif>
<cfset GET_BRANCHS = cmp.GET_BRANCHS_F()>
<!--- <cfquery name="GET_BRANCHS" datasource="#DSN#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME 
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.POSITION_CODE#"> 	
					)
	ORDER BY BRANCH_ID
</cfquery> --->
<cfif get_branchs.recordcount>
	<cfset branch_id_list = listsort(valuelist(get_branchs.branch_id,','),"Numeric","Desc")>
<cfelse>
	<cfset branch_id_list = 0>
</cfif>
<cfparam name="attributes.training_cat_id" default="">
<cfparam name="attributes.training_sec_id" default="">
<cfparam name="attributes.project" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.train_head" default="">
<cfparam name="attributes.train_id" default="">
<cfset GET_CLASS_EX_CLASS = cmp.GET_CLASS_EX_CLASS_F(
	branch_id_list:branch_id_list,
	online:attributes.online,
	keyword:attributes.keyword,
	date1:attributes.date1,
	dun:iif(isDefined("attributes.field_id"),attributes.DUN,""),
	training_cat_id:attributes.training_cat_id,
	training_sec_id:attributes.training_sec_id,
	<!--- emp_class_id:emp_class_id, --->
	ic_dis:attributes.ic_dis,
	project:attributes.project,
	project_id:attributes.project_id,
	train_head:attributes.train_head,
	train_id:attributes.train_id
)>
<!--- <cfquery name="GET_CLASS_EX_CLASS" datasource="#DSN#">
	SELECT DISTINCT
		TC.START_DATE, 
		TC.FINISH_DATE, 
		TC.ONLINE, 
		TC.CLASS_ID, 
		TC.CLASS_NAME, 
		TC.CLASS_PLACE, 
		TC.MONTH_ID, 
		<!--- TC.TRAINER_EMP,
		TC.TRAINER_PAR,
		TC.TRAINER_CONS, --->
		TC.INT_OR_EXT AS TYPE
	FROM
		TRAINING_CLASS TC
		LEFT JOIN TRAINING TRN ON TC.TRAINING_ID = TRN.TRAIN_ID
	WHERE
		TC.CLASS_ID IS NOT NULL AND
		(
			TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE DEPARTMENT_ID IN(SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#branch_id_list#">)))) OR
			<!---CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS WHERE TRAINER_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR--->
			TC.CLASS_ID NOT IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID IS NOT NULL) OR
			TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_INFORM WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">) OR
			TC.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
		)
		<cfif isDefined("attributes.online") and len(attributes.online)>AND ONLINE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.online#"></cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND TC.CLASS_NAME LIKE '%' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#" maxlength="100" /> + '%'
		</cfif>
		<cfif isDefined("attributes.date1") and len(attributes.date1)>
            AND
            (
                TC.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> OR
                TC.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
            )
		</cfif>
		<cfif isDefined("attributes.field_id")>AND TC.START_DATE ><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DUN#"></cfif>
		<cfif isdefined("attributes.training_cat_id") AND len(attributes.training_cat_id)>AND TC.TRAINING_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_cat_id#"></cfif>
		<cfif isdefined("attributes.training_sec_id") AND len(attributes.training_sec_id)>AND TC.TRAINING_SEC_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.training_sec_id#"></cfif>
		<cfif isdefined("emp_class_id") and listlen(emp_class_id)>AND TC.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes"  value="#emp_class_id#">) <cfelseif isdefined("emp_class_id") and not listlen(emp_class_id)> AND TC.CLASS_ID=0</cfif>
		<cfif isdefined("attributes.ic_dis") and len(attributes.ic_dis)>AND TC.INT_OR_EXT = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.ic_dis#"></cfif>
		<cfif isdefined("attributes.project") and len(attributes.project) and len(attributes.project_id)>AND TC.PROJECT_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"></cfif>
		<cfif isdefined("attributes.train_id") and len(attributes.train_id) and isdefined("attributes.train_head") and len(attributes.train_head)>
			AND TRN.TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_id#">
		</cfif>
	ORDER BY 
		START_DATE DESC		
</cfquery> --->