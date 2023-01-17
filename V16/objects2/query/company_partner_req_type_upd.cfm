<cfquery name="del_company_partner_req" datasource="#dsn#"> 
	DELETE FROM MEMBER_REQ_TYPE WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
</cfquery>
<cfoutput>
<cfif isDefined('attributes.req')>
<cfloop from="1" to="#Listlen(attributes.req)#" index="i"> 
<cfset liste = ListGetAt(attributes.req,i)>
<cfquery name="add_company_partner_req" datasource="#dsn#"> 
	INSERT INTO MEMBER_REQ_TYPE
	(
		PARTNER_ID,
		REQ_ID
	)
	VALUES
	(
		#attributes.partner_id#,
		#liste#
	)
 </cfquery> 
 </cfloop>
</cfif>
 </cfoutput>
<script type="text/javascript">
	self.close();
</script>

