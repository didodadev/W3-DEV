<cfscript> 
    add_partner=CreateObject("component","cfc.addPartner"); 
	add_partner.dsn=dsn;
    max_partner_id = add_partner.addPartner(attributes: attributes);  
</cfscript>


<!---Ek Bilgiler--->
<cfset attributes.info_id = max_partner_id>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -3>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->

<cfif isdefined("attributes.is_popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=member.form_list_company&event=det&cpid=#form.company_id#</cfoutput>";
	</script>
</cfif> 