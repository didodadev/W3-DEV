<cfquery name="del_company_partner_hobbies" datasource="#dsn#"> 
	DELETE FROM COMPANY_PARTNER_HOBBY WHERE PARTNER_ID = #attributes.pid#
</cfquery>
<cfoutput>
<cfif isDefined('attributes.hobby')>
<cfloop from="1" to="#Listlen(attributes.hobby)#" index="i"> 
<cfset liste = ListGetAt(attributes.hobby,i)>
    <cfquery name="add_company_partner_hobbies" datasource="#dsn#"> 
        INSERT INTO COMPANY_PARTNER_HOBBY
                (
                    PARTNER_ID,
                    HOBBY_ID
                )
            VALUES
                (
                #attributes.pid#,
                #liste#
                )
    </cfquery> 
 </cfloop>
</cfif>
</cfoutput>
<script type="text/javascript">
    <cfif not isdefined("attributes.draggable")>
        self.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    </cfif>
</script>
