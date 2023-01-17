<table cellspacing="0" cellpadding="0" border="0" width="98%">
<tr class="color-border">
  <td>							
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang no ='133.Eğitim Konuları'></td>
	  </tr>								 
	  <cfif GET_CL_SEC.recordcount>
		  <cfoutput query="GET_CL_SEC">
			<tr class="color-row" height="20">
			  <td>
				<cfset attributes.TRAINING_SEC_ID=TRAINING_SEC_ID>
				<cfinclude template="../query/get_training_sec_name.cfm">				
				<a href="#request.self#?fuseaction=training.training_subject&train_id=#TRAINING_ID#" class="tableyazi">#TRAIN_HEAD#</a> - (#get_training_sec_name.SECTION_NAME#)
			  </td>
			</tr>
		  </cfoutput> 
	  <cfelse>
		<tr class="color-row" height="20">
		  <td colspan="2" >&nbsp;<cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>							
	  </cfif>
	</table>
 </td>
</tr>
</table>		
