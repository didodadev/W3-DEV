<cfscript> 
    add_partner=CreateObject("component","cfc.addPartner"); 
	add_partner.dsn=dsn;
    max_partner_id = add_partner.addPartner(attributes: attributes);  

</cfscript>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

