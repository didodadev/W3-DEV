<cfif isdefined("attributes.is_del")>
 <cfquery name="upd_t" datasource="#DSN#">
	DELETE FROM
		TRAINING_CLASS_TRAINER_EVAL
	WHERE
		CLASS_ID = #attributes.CLASS_ID#
 </cfquery>
<cfelse>
 <cfquery name="upd_t" datasource="#DSN#">
	 UPDATE 
     	TRAINING_CLASS_TRAINER_EVAL
	 SET
		PROGRAMA_UYGUN='#attributes.PROGRAMA_UYGUN#',
		SURE_YETERLI='#attributes.SURE_YETERLI#',
		KATILIMCI_BILGI_SEVIYE='#attributes.KATILIMCI_BILGI_SEVIYE#',
		DERSE_KATILIM='#attributes.DERSE_KATILIM#',
		OLUMLU_NITELIK='#attributes.OLUMLU_NITELIK#',
		OLUMSUZ_NITELIK='#attributes.OLUMSUZ_NITELIK#',
		GORUS_ONVERI='#attributes.GORUS_ONVERI#',
		KATILIMCIYA_UYGUN='#attributes.KATILIMCIYA_UYGUN#',
		DERS_SONU_BEKLENTI='#attributes.DERS_SONU_BEKLENTI#',
		KATILIMCI_DUZEYLERI='#attributes.KATILIMCI_DUZEYLERI#',
		UPDATE_EMP=#SESSION.EP.USERID#,
		UPDATE_DATE= #NOW()#,
		UPDATE_IP='#CGI.REMOTE_ADDR#'
	WHERE
		CLASS_ID=#attributes.CLASS_ID#
 </cfquery>
</cfif>
<script type="text/javascript">
window.close();	
</script>
