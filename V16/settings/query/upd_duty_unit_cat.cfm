<cfquery name="GET_CONTROL" datasource="#DSN#">
	SELECT DUTY_TYPE_ID FROM SETUP_DUTY_TYPE WHERE DUTY_UNIT_CAT_ID = #attributes.duty_unit_cat_id#
</cfquery>

<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2547.Bu Hizmet Birimi, Hizmet Tipinde Seçilmiş, Kontrol Ediniz'> !");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cflock timeout="60">
		<cftransaction>
			<cfquery name="UPD_DUTY_UNIT_CAT" datasource="#DSN#">
				UPDATE 
					SETUP_DUTY_UNIT_CAT
				SET 
					DUTY_UNIT_CAT = '#attributes.duty_unit_cat#',
					DETAIL = '#attributes.detail#',
					UPDATE_IP = '#cgi.remote_addr#',
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#	 
				WHERE 
					DUTY_UNIT_CAT_ID = #attributes.duty_unit_cat_id#
			</cfquery>
			<cfif (attributes.duty_unit_cat is not attributes.old_duty_unit_cat) or (attributes.detail is not attributes.old_detail)>
				<cfquery name="add_setup_duty_unit_cat"	 datasource="#dsn#">
					INSERT INTO
						SETUP_DUTY_UNIT_CAT_HISTORY
					(
						DUTY_UNIT_CAT_ID,
						DUTY_UNIT_CAT,
						DETAIL,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						#attributes.duty_unit_cat_id#,
						'#attributes.old_duty_unit_cat#',
						'#attributes.old_detail#',
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#'
					)
				</cfquery>
			</cfif>
		</cftransaction>
	</cflock>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.add_duty_unit_cat" addtoken="no">
