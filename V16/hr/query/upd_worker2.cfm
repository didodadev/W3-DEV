<cfif len(attributes.UPPER_ROW_ID) and len(attributes.UPPER_ROLE_HEAD) and len(form.hierarchy1_code) and len(form.hierarchy)>
	<cfset my_hierarchy_code = attributes.hierarchy1_code & '.' & attributes.hierarchy>
<cfelseif not len(attributes.UPPER_ROW_ID) or not len(attributes.UPPER_ROLE_HEAD) and len(form.hierarchy)>
	<cfset my_hierarchy_code = attributes.workgroup_hierarchy & '.' & attributes.hierarchy>
<cfelseif len(form.hierarchy)>
	<cfset my_hierarchy_code = attributes.hierarchy>
<cfelse>
	<cfset my_hierarchy_code = ''>
</cfif>

<cfquery name="CHECK" datasource="#dsn#">
	SELECT
		HIERARCHY
	FROM
		WORKGROUP_EMP_PAR
	WHERE
		HIERARCHY = '#my_hierarchy_code#'
		AND
		WRK_ROW_ID <> #attributes.WRK_ROW_ID#
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
	alert("<cf_get_lang no ='1743.Bu Hierarşi Kullanılmaktadır Lütfen Kodu Değiştiriniz'>!");
	history.back();
	</script>
	<cfabort>
</cfif>

<cfif my_hierarchy_code is not '#attributes.old_hierarchy_code#'>
	<cfset hie_uzunluk = len(attributes.old_hierarchy_code)>
	<cfquery name="get_alt_kademeler" datasource="#dsn#">
		SELECT
			HIERARCHY,WRK_ROW_ID
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			HIERARCHY LIKE '#attributes.old_hierarchy_code#.%'
	</cfquery>
	<cfif get_alt_kademeler.recordcount>
		<cfloop query="get_alt_kademeler">
			<cfset yeni_hie1 = mid(get_alt_kademeler.HIERARCHY,hie_uzunluk+1,len(get_alt_kademeler.HIERARCHY)-(hie_uzunluk-1))>
			<cfset yeni_hie = '#my_hierarchy_code#' & '#yeni_hie1#'>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE 
					WORKGROUP_EMP_PAR 
				SET 
					HIERARCHY = '#yeni_hie#',
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP ='#cgi.remote_addr#',
					UPDATE_DATE = #now()#
				WHERE 
					WRK_ROW_ID = #get_alt_kademeler.WRK_ROW_ID#
			</cfquery>
		</cfloop>
	</cfif> 
</cfif>
<cfquery name="get_work_group" datasource="#dsn#">
	SELECT
		HIERARCHY,WORKGROUP_ID
	FROM
		WORK_GROUP
	WHERE
		HIERARCHY = '#attributes.workgroup_hierarchy#'
</cfquery>

<cfif not isdefined("attributes.is_org_view")>
	<cfquery name="add_worker_emp" datasource="#DSN#">
		UPDATE 
			WORKGROUP_EMP_PAR
		SET 
			IS_ORG_VIEW = 0,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP ='#cgi.remote_addr#',
			UPDATE_DATE = #now()#
		WHERE
			HIERARCHY LIKE '#my_hierarchy_code#.%'
	</cfquery>
</cfif>

<cfquery name="add_worker_emp" datasource="#DSN#">
  UPDATE 
  	   WORKGROUP_EMP_PAR
  	SET 
	  ORDER_NO = <cfif len(attributes.ORDER_NO)>#attributes.ORDER_NO#,<cfelse>NULL,</cfif>
	  UPPER_ROW_ID = <cfif len(attributes.UPPER_ROW_ID) and len(attributes.UPPER_ROLE_HEAD)>#attributes.UPPER_ROW_ID#,<cfelse>NULL,</cfif>
	  WORKGROUP_ID = #get_work_group.WORKGROUP_ID#,
	  IS_REAL = <cfif isdefined("attributes.is_real")>1,<cfelse>0,</cfif>
	  IS_CRITICAL = <cfif isdefined("attributes.is_critical")>1,<cfelse>0,</cfif>
	  HIERARCHY = '#my_hierarchy_code#',
	  ROLE_HEAD = '#attributes.role_head#',
	  ROLE_ID  = <cfif len(form.role_id)>#form.role_id#,<cfelse>NULL,</cfif> 
	  IS_ORG_VIEW = <cfif isdefined("attributes.is_org_view")>1<cfelse>0</cfif>,
	  PARTNER_ID=<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
	  COMPANY_ID=<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
	  CONSUMER_ID=<cfif len(attributes.consumer_id)>#attributes.consumer_id#<cfelse>NULL</cfif>,
	  EMPLOYEE_ID = <cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
	  UPDATE_EMP = #session.ep.userid#,
	  UPDATE_IP ='#cgi.remote_addr#',
	  UPDATE_DATE = #now()#
  WHERE
	 WRK_ROW_ID = #attributes.WRK_ROW_ID#
</cfquery>

<script type="text/javascript">
	<cfoutput>
        window.location.href = '#request.self#?fuseaction=hr.list_workgroup&event=upd&workgroup_id=#workgroup_id#';
    </cfoutput>
</script>
