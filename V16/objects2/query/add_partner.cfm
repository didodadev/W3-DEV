<cfscript> 
    add_partner=CreateObject("component","cfc.addPartner"); 
	add_partner.dsn=dsn;
    max_partner_id = add_partner.addPartner(attributes: attributes);  

</cfscript>

<cfif isDefined("session.pp") or isDefined("session.ww")>
    <script type="text/javascript">
        window.location.replace(document.referrer);
    </script>
<cfelse>
    <cfif isDefined('attributes.is_popup') and attributes.is_popup eq 1>
        <script type="text/javascript">
            wrk_opener_reload();
            window.close();
        </script>
    <cfelse>
        <cfif isdefined('attributes.my_type_url') and attributes.my_type_url eq 1>
            <cflocation url="#request.self#?fuseaction=objects2.form_upd_my_company" addtoken="no">
        <cfelse>
            <cflocation url="#request.self#?fuseaction=objects2.upd_my_member&company_id=#attributes.company_id#" addtoken="no">
        </cfif>
    </cfif>
</cfif>