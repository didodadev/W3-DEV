<cfinclude template="../query/get_training_in_subject.cfm">
<table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
 <tr>
  <td class="headbold" height="35"><cf_get_lang no='415.Konu Hitleri'></td>
  </tr>
 </table>
<!--- Konu Hitleri --->
<table cellSpacing="0" cellpadding="0" width="98%" border="0" align="center">
 <tr class="color-border">
  <td>
   <table cellspacing="1" cellpadding="2" width="100%" border="0">
	  <tr class="color-header" height="22">
		<td class="form-title"><cf_get_lang_main no='158.Ad Soyad'></td>
		<td class="form-title" width="75"><cf_get_lang no='87.Toplam Süre'></td>
	  </tr>	  
	<cfif GET_TRAINING_IN_SUBJECT.RecordCount>
	 <cfoutput query="GET_TRAINING_IN_SUBJECT">	  
	  <tr class="color-row" height="22">
		 <td height="22">	
			#GET_TRAINING_IN_SUBJECT.EMPLOYEE_NAME# #GET_TRAINING_IN_SUBJECT.EMPLOYEE_SURNAME#
		 </td>
		 <td height="22">	
			<cfif Len(READING_DATE)>
				#TimeFormat(READING_DATE - ACCESS_DATE,"m")#<cf_get_lang_main no='1415.Dk'>
			<cfelse>
				<cf_get_lang no='275.Okuma Bitmemiş'>
			</cfif>
		 </td>		 
	  </tr>
	</cfoutput>
   <cfelse>
	  <tr class="color-row" height="22">	   
		 <td height="22" colspan="2">
			<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
		 </td>
	  </tr>		 	
   </cfif>		
	</table>
  </td>
 </tr>
</table>
<!---Konu Hitleri --->
