<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
	<cfloop from="1" to="#max_record_number#" index="i">
		<cfquery name="ADD_CLASS_ATTENDER_EVAL" datasource="#dsn#">
			INSERT INTO
				TRAINING_CLASS_ATTENDER_EVAL
				(
				CLASS_ID,
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID,
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID,
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID,
				</cfif>
				SEMINERE_ILGI,
				TARTISMALARA_KATILIM,
				OGRENME_MOTIVASYONU,
				FIKIR_URETME,
				KARSI_FIKRE_SAYGI,
				YENILIGE_ACIKLIK,
				DEGISIME_INANC,
				ILETISIM_BECERISI,
				NOTE,
				RECORD_DATE,
				RECORD_IP,
				RECORD_EMP
				)
			VALUES
				(
				#attributes.CLASS_ID#,
				<cfif isdefined("attributes.EMP_ID_#i#")>
				#evaluate("attributes.EMP_ID_#i#")#,
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				#Evaluate("attributes.CON_ID_#i#")#,
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				#Evaluate("attributes.PAR_ID_#i#")#,
				</cfif>
				<cfif Len(Evaluate("attributes.SEMINERE_ILGI_#i#"))>#Evaluate("attributes.SEMINERE_ILGI_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.TARTISMALARA_KATILIM_#i#"))>#Evaluate("attributes.TARTISMALARA_KATILIM_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.OGRENME_MOTIVASYONU_#i#"))>#Evaluate("attributes.OGRENME_MOTIVASYONU_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.FIKIR_URETME_#i#"))>#Evaluate("attributes.FIKIR_URETME_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.KARSI_FIKRE_SAYGI_#i#"))>#Evaluate("attributes.KARSI_FIKRE_SAYGI_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.YENILIGE_ACIKLIK_#i#"))>#Evaluate("attributes.YENILIGE_ACIKLIK_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.DEGISIME_INANC_#i#"))>#Evaluate("attributes.DEGISIME_INANC_#i#")#,<cfelse>NULL,</cfif>
				<cfif Len(Evaluate("attributes.ILETISIM_BECERISI_#i#"))>#Evaluate("attributes.ILETISIM_BECERISI_#i#")#,<cfelse>NULL,</cfif>
				'#wrk_eval("attributes.NOTE_#i#")#',
				#now()#,
				'#CGI.REMOTE_ADDR#',
				#SESSION.EP.USERID#
				)
		</cfquery>	
	</cfloop>
	</CFTRANSACTION>
</CFLOCK>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
