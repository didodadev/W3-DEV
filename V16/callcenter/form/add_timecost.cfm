<cf_get_lang_set module_name="myhome"><!--- sayfanin en altinda kapanisi var --->
<table cellpadding="0" cellspacing="0" border="0" style="width:100%; height:100%">
	<tr>
		<td style="vertical-align:top"> 
            <cfinclude template="../../#application.objects['myhome.emptypopup_form_add_timecost']['filePath']#"> 
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->