<cfquery name="del_company_partner_req" datasource="#dsn#"> 
DELETE FROM MEMBER_REQ_TYPE WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfoutput>
<cfif isDefined('attributes.req')>
<cfloop from="1" to="#Listlen(attributes.req)#" index="i"> 
<cfset liste = ListGetAt(attributes.req,i)>
	<cfquery name="add_company_partner_req" datasource="#dsn#"> 
	INSERT INTO MEMBER_REQ_TYPE
			(
				COMPANY_ID,
				REQ_ID
			)
		VALUES
			(
			#attributes.cpid#,
			#liste#
			)
	 </cfquery> 
 </cfloop>
</cfif>
 </cfoutput>
<script type="text/javascript">
/* 	self.close(); */	
	window.location.href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#attributes.cpid#</cfoutput>";
</script>

