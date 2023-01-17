<cfif LEN(class_date)>
  <CF_DATE tarih="class_date">
</cfif>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>

		<cfquery name="UPD_EX_CLASS" datasource="#DSN#">
			UPDATE
				TRAINING_EX_CLASS
			SET
				TRAINING_SEC_ID = <cfif len(TRAINING_SEC_ID)>#attributes.TRAINING_SEC_ID#,<cfelse>NULL,</cfif>
				CLASS_NAME = '#CLASS_NAME#',
				CLASS_PLACE = <cfif len(CLASS_PLACE)>'#CLASS_PLACE#',<cfelse>NULL,</cfif>
			    TRAINER_EMP = <cfif LEN(form.EMP_ID) and (form.EMP_ID neq 0)>#form.EMP_ID#,<cfelse>NULL,</cfif>
			    TRAINER_PAR = <cfif LEN(form.PAR_ID) and (form.PAR_ID neq 0)>#form.PAR_ID#,<cfelse>NULL,</cfif>
			    CLASS_DATE = <cfif LEN(class_date)>#class_date#,<cfelse>NULL,</cfif>
				HOUR_NO = <cfif LEN(attributes.HOUR_NO)>#attributes.HOUR_NO#,<cfelse>NULL,</cfif>
				CLASS_COST = <cfif LEN(CLASS_COST)>#CLASS_COST#,<cfelse>NULL,</cfif>
				QUIZ_ID = <cfif LEN(quiz_id)>#quiz_id#,<cfelse>NULL,</cfif>
				UPDATE_DATE = #NOW()#,
				UPDATE_IP = '#CGI.REMOTE_ADDR#',
				UPDATE_EMP = #SESSION.EP.USERID#,
				MONEY_TYPE=#MONEY_TYPE#
			WHERE
				EX_CLASS_ID = #FORM.EX_CLASS_ID#
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cflocation url="#request.self#?fuseaction=training_management.form_upd_ex_class&ex_class_id=#FORM.ex_class_id#" addtoken="no">

