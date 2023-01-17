<cfinclude template="upd_date_values.cfm">
<cfinclude template="get_check.cfm">
<cfif CHECK_1.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='750.Lütfen Varlık Teslim Tarihinden Sonra Rezervasyon Yapınız'> !");
		history.back();
	</script>
	<cfabort>
<cfelseif check.recordcount>
<script type="text/javascript">
	alert("<cf_get_lang no='16.Bu Aralıkta Kaynak Rezervasyon Çakışması Var !'>");
	history.back();
</script>
<cfelse>
	<cfif isDefined("attributes.EVENT_ID")>
		<cfquery name="ADD_ASSETP_RESERVE" datasource="#DSN#">
			INSERT INTO 
				ASSET_P_RESERVE
				(
					ASSETP_ID,
					<cfif isDefined("attributes.event_id") and len(attributes.event_id)>EVENT_ID,</cfif>
					<cfif isDefined("attributes.class_id") and len(attributes.class_id)>CLASS_ID,</cfif>
					<cfif len(detail)>DETAIL,</cfif>
					STARTDATE,
					FINISHDATE,
					STATUS,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP
				)
			VALUES
				(
					#attributes.ASSETP_ID#,
					<cfif isDefined("attributes.EVENT_ID") and len(attributes.EVENT_ID)>#attributes.EVENT_ID#,</cfif>
					<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>#attributes.CLASS_ID#,</cfif>
					<cfif len(detail)>'#detail#',</cfif>
					#FORM.STARTDATE#,
					#FORM.FINISHDATE#,
					1,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
	<cfelse>
		<cfquery name="ADD_ASSETP_RESERVE" DATASOURCE="#DSN#">
			INSERT INTO 
				ASSET_P_RESERVE
					(
						ASSETP_ID,
						<cfif isDefined("attributes.PROJECT_ID") and len(attributes.PROJECT_ID)>PROJECT_ID,</cfif>
						<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>CLASS_ID,</cfif>
						STARTDATE,
						FINISHDATE,
						STATUS,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						UPDATE_DATE,
						UPDATE_EMP,
						UPDATE_IP
					)
					VALUES
					(
						#attributes.ASSETP_ID#,
						<cfif isDefined("attributes.PROJECT_ID") and len(attributes.PROJECT_ID)>#attributes.PROJECT_ID#,</cfif>
						<cfif isDefined("attributes.CLASS_ID") and len(attributes.CLASS_ID)>#attributes.CLASS_ID#,</cfif>
						#FORM.STARTDATE#,
						#FORM.FINISHDATE#,
						1,
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#',
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
		</cfif>
</cfif>
<cfif isdefined("attributes.project_id") or isdefined("attributes.event_id") or isdefined("attributes.class_id")>
	<script type="text/javascript">
		opener.wrk_opener_reload();
		window.opener.close();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>


