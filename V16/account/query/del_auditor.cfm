
<cfset wizard = createObject("component", "V16.account.cfc.MagicAuditor" )>
<cftransaction>
    
    <cfset get_wizard_block = wizard.get_wizard_block(
                                                        wizard_id : attributes.wizard_id
                                                     )>
    <cfif len(get_wizard_block.wizard_block_id)>
        <cfset del_wizard_block_row = wizard.del_wizard_block_row(
                                                                    block_id : valueList(get_wizard_block.wizard_block_id)
                                                                 )>
    </cfif>

    <cfset del_wizard_block = wizard.del_wizard_block(
                                                        wizard_id : attributes.wizard_id
                                                     )>
    <cfset del_wizard = wizard.del_wizard(
                                            wizard_id : attributes.wizard_id
                                         )>
 
</cftransaction>

<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=account.magic_auditor';
</script>