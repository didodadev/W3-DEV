<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
	<cfloop from="1" to="#max_record_number#" index="i">
		<cfquery name="get_class_attender_eval" datasource="#DSN#">
			SELECT 
				EMP_ID,
				CON_ID,
				PAR_ID 
			FROM 
				TRAINING_CLASS_ATTENDER_EVAL 
			WHERE 
				CLASS_ID=#attributes.CLASS_ID# AND
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID=#Evaluate("attributes.EMP_ID_#i#")#
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID=#Evaluate("attributes.CON_ID_#i#")#
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID=#Evaluate("attributes.PAR_ID_#i#")#
				</cfif>
		</cfquery>
		<cfif get_class_attender_eval.recordcount>
		<cfquery name="UPD_CLASS_ATTENDER_EVAL" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_ATTENDER_EVAL
			SET
				SEMINERE_ILGI=<cfif Len(Evaluate("attributes.SEMINERE_ILGI_#i#"))>#Evaluate("attributes.SEMINERE_ILGI_#i#")#,<cfelse>NULL,</cfif>
				TARTISMALARA_KATILIM=<cfif Len(Evaluate("attributes.TARTISMALARA_KATILIM_#i#"))>#Evaluate("attributes.TARTISMALARA_KATILIM_#i#")#,<cfelse>NULL,</cfif>
				OGRENME_MOTIVASYONU=<cfif Len(Evaluate("attributes.OGRENME_MOTIVASYONU_#i#"))>#Evaluate("attributes.OGRENME_MOTIVASYONU_#i#")#,<cfelse>NULL,</cfif>
				FIKIR_URETME=<cfif Len(Evaluate("attributes.FIKIR_URETME_#i#"))>#Evaluate("attributes.FIKIR_URETME_#i#")#,<cfelse>NULL,</cfif>
				KARSI_FIKRE_SAYGI=<cfif Len(Evaluate("attributes.KARSI_FIKRE_SAYGI_#i#"))>#Evaluate("attributes.KARSI_FIKRE_SAYGI_#i#")#,<cfelse>NULL,</cfif>
				YENILIGE_ACIKLIK=<cfif Len(Evaluate("attributes.YENILIGE_ACIKLIK_#i#"))>#Evaluate("attributes.YENILIGE_ACIKLIK_#i#")#,<cfelse>NULL,</cfif>
				DEGISIME_INANC=<cfif Len(Evaluate("attributes.DEGISIME_INANC_#i#"))>#Evaluate("attributes.DEGISIME_INANC_#i#")#,<cfelse>NULL,</cfif>
				ILETISIM_BECERISI=<cfif Len(Evaluate("attributes.ILETISIM_BECERISI_#i#"))>#Evaluate("attributes.ILETISIM_BECERISI_#i#")#,<cfelse>NULL,</cfif>
				NOTE='#wrk_eval("attributes.NOTE_#i#")#',
				UPDATE_DATE=#now()#,
				UPDATE_IP='#CGI.REMOTE_ADDR#',
				UPDATE_EMP=#SESSION.EP.USERID#
			WHERE
				CLASS_ID=#attributes.CLASS_ID# AND
				<cfif isdefined("attributes.EMP_ID_#i#")>
				EMP_ID=#Evaluate("attributes.EMP_ID_#i#")#
				<cfelseif isdefined("attributes.CON_ID_#i#")>
				CON_ID=#Evaluate("attributes.CON_ID_#i#")#
				<cfelseif isdefined("attributes.PAR_ID_#i#")>
				PAR_ID=#Evaluate("attributes.PAR_ID_#i#")#
				</cfif>
		</cfquery>
		<cfelse>
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
		</cfif>	
	</cfloop>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
window.close();
</script>
