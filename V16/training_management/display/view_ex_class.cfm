<cfinclude template="../query/get_ex_class.cfm">
<cfif LEN(get_ex_class.class_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_ex_class.class_date)>
</cfif>
<table width="650" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
<tr>
  <td class="headbold"><cf_get_lang_main no='7.Eğitim'>:&nbsp;<cfoutput>#get_ex_class.class_name#</cfoutput></td>
</tr>
</table>
<table width="650" border="0" align="center">
				  <tr>
					<td class="txtbold" nowrap><cf_get_lang_main no='74.bölüm'></td>
					<td>:
						<cfset attributes.sec_id = #get_ex_class.training_sec_id#>
						<cfinclude template="../query/get_training_sec_names.cfm">
						<cfoutput>#GET_TRAINING_SEC_NAMES.training_cat# / #GET_TRAINING_SEC_NAMES.section_name#</cfoutput>
					</td>
				  </tr>
				  <tr>
				  <td class="txtbold" nowrap><cf_get_lang_main no='7.Eğitim'></td>
				  <td>:&nbsp;<cfoutput>#get_ex_class.class_name#</cfoutput></td>
				  </tr>
				  <tr>
					<td class="txtbold" nowrap><cf_get_lang no='187.Eğitim Yeri'></td>
					<td>: <cfoutput>#get_ex_class.CLASS_PLACE#</cfoutput>
					</td>
				  </tr>

				  <tr>
					<td class="txtbold" nowrap><cf_get_lang no='239.Eğitim Maliyeti'></td>
					<td>:
					<cfif LEN(get_ex_class.CLASS_COST)><cfoutput>#get_ex_class.CLASS_COST#</cfoutput></cfif>
					</td>
				  </tr>
				  <tr>
					<td class="txtbold" nowrap><cf_get_lang_main no='330.Tarih'></td>
					<td>:
						<cfif LEN(get_ex_class.class_date)>
						<cfoutput>
						#dateformat(get_ex_class.class_date,dateformat_style)# 
						#timeformat(get_ex_class.class_date,timeformat_style)#
						</cfoutput></cfif>
					</td>
				  </tr>

</table>
