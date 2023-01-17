<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  	<tr>
        <td valign="top"> 
            <cf_get_lang_set module_name="settings">
			<cfinclude template="../form/add_quiz_stage.cfm">
        </td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
