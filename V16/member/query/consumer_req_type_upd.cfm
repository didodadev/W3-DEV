<!-- onur  09022004-->
<cfquery name="del_consumer_req" datasource="#dsn#"> 
DELETE FROM MEMBER_REQ_TYPE 
WHERE CONSUMER_ID = #attributes.consumer_id#
</cfquery>
<cfoutput>
<cfif isDefined('attributes.req')>
<cfloop from="1" to="#Listlen(attributes.req)#" index="i"> 
<cfset liste = ListGetAt(attributes.req,i)>
<cfquery name="add_consumer_req" datasource="#dsn#"> 
INSERT INTO MEMBER_REQ_TYPE
		(
			CONSUMER_ID,
			REQ_ID
		)
	VALUES
		(
		#attributes.consumer_id#,
		#liste#
		)
 </cfquery> 
 </cfloop>
</cfif>
 </cfoutput>
<script type="text/javascript">
	location.href = document.referrer;
</script>
