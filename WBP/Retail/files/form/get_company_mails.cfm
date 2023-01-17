<cfquery name="get_comp_partners" datasource="#dsn#">
    SELECT
        *
    FROM
        COMPANY_PARTNER
    WHERE
        COMPANY_ID = #attributes.company_id# AND
        COMPANY_PARTNER_EMAIL IS NOT NULL AND
        COMPANY_PARTNER_EMAIL <> '' AND
        COMPANY_PARTNER_STATUS = 1
</cfquery>
<cfoutput>
<select name="order_mail_#attributes.set_id#" id="order_mail_#attributes.set_id#">
    <cfloop query="get_comp_partners">
        <option value="#COMPANY_PARTNER_EMAIL#">#COMPANY_PARTNER_EMAIL#</option>
    </cfloop>
</select>
<script>
    $("##order_mail_#attributes.set_id#").jqxDropDownList({placeHolder: "Mail Adresi Seçiniz", autoOpen: true,checkboxes: true,autoDropDownHeight: true,checkboxes: true, width:300, height: 25 });
	$("##order_mail_#set_id#").jqxDropDownList('uncheckAll');
</script>
</cfoutput>