<cf_get_lang_set module_name="training">
<cfquery name="get_class_name" datasource="#DSN#">
	  SELECT 
		CLASS_NAME
	  FROM
		TRAINING_CLASS
	  WHERE
		CLASS_ID = #attributes.CLASS_ID#		
</cfquery>
<table cellspacing="1" cellpadding="2" width="98%" height="100%"  border="0" class="color-border" align="center">
<tr class="color-list"> 
  <td height="35" colspan="2" class="headbold">Eğitime Katıl</td>
</tr>
<tr class="color-row"> 
  <td valign="top"> 
  <table>
	  <cfform name="added_class" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_added_class&class_id=#attributes.class_id#" method="post">
		<tr> 
		  <td class="txtbold">
			<cf_get_lang no='15.Ders'> : <cfoutput query="get_class_name">#class_name#</cfoutput>
		  </td>
		</tr>
		<tr>
		  <td class="txtboldblue">
			<cf_get_lang_main no='178.Katılımcılar'> : 
			<cfoutput>
				<cfif isdefined('session.ep')>
					#session.ep.name# #session.ep.surname#
				<cfelseif isdefined('session.pp')>
					#session.pp.company_nick# - #session.pp.name# #session.pp.surname#
				<cfelseif isdefined('session.ww.userid')>
					#session.ww.name# #session.ww.surname#
				</cfif>
			</cfoutput>
		  </td>
		</tr>
		  <td height="35">
		  <cfsavecontent variable="message"><cf_get_lang no='24.Katılıyorum'></cfsavecontent>
		  <cf_workcube_buttons is_upd='0' insert_info='#message#'>
		</tr>
	  </cfform>
	</table>
	</td>
</tr>
</table>
