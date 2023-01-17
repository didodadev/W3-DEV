<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.department_head=replacelist(attributes.department_head,list,list2)>

<cfquery name="ADD_DEPARTMENT" datasource="#DSN#" result="MAX_ID">
	INSERT INTO 
		DEPARTMENT
	(
		DEPARTMENT_STATUS,
		IS_STORE,
		BRANCH_ID,
		DEPARTMENT_HEAD,
		DEPARTMENT_DETAIL,
	  	<cfif len(POS_ID2)>ADMIN2_POSITION_CODE,</cfif>
		ADMIN1_POSITION_CODE,
		OUR_COMPANY_ID,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP
	)
	VALUES
	(
		<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
		1,
		#BRANCH_ID#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.department_head#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(attributes.department_detail,100)#">,
		<cfif len(POS_ID2)>#POS_ID2#,</cfif>
		#POS_ID#,
		#session.ep.company_id#,
		#NOW()#,
		#session.ep.userid#,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
	)
</cfquery>
<cfquery name="get_max" datasource="#DSN#">
	UPDATE
		DEPARTMENT
	SET
		HIERARCHY_DEP_ID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#MAX_ID.IDENTITYCOL#">
	WHERE
		DEPARTMENT_ID=#MAX_ID.IDENTITYCOL#
</cfquery>
<!--- history icin --->
<cfquery name="add_dept_history" datasource="#dsn#">
	INSERT INTO 
    	DEPARTMENT_HISTORY
  	( 
        DEPARTMENT_STATUS,
        IS_PRODUCTION,
        IS_STORE,
        BRANCH_ID,
        DEPARTMENT_ID,
        DEPARTMENT_HEAD,
        DEPARTMENT_DETAIL,
        ADMIN1_POSITION_CODE,
        ADMIN2_POSITION_CODE,
        HIERARCHY_DEP_ID,
        HIERARCHY,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP,
        IS_ORGANIZATION,
        HEADQUARTERS_ID,
        OUR_COMPANY_ID,
        ZONE_ID,
        
        LEVEL_NO
    ) 
	SELECT 
    	DEPARTMENT_STATUS,
        IS_PRODUCTION,
        IS_STORE,
        BRANCH_ID,
        DEPARTMENT_ID,
        DEPARTMENT_HEAD,
        DEPARTMENT_DETAIL,
        ADMIN1_POSITION_CODE,
        ADMIN2_POSITION_CODE,
        HIERARCHY_DEP_ID,
        HIERARCHY,
        RECORD_DATE,
        RECORD_EMP,
        RECORD_IP,
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP,
        IS_ORGANIZATION,
        HEADQUARTERS_ID,
        OUR_COMPANY_ID,
        ZONE_ID,
        LEVEL_NO 
   	FROM 
    	DEPARTMENT 
  	WHERE 
    	DEPARTMENT_ID = #MAX_ID.IDENTITYCOL#
</cfquery>
<cfset attributes.actionId = MAX_ID.IDENTITYCOL >
<!--- history icin --->
<script type="text/javascript">
		location.href = document.referrer;
	self.close();
</script>
