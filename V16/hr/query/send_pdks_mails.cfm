<CF_DATE tarih="attributes.aktif_gun">
<cfquery name="get_all_mails" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL
	FROM
		EMPLOYEES E
	WHERE
		<cfif isdefined("attributes.employee_id")>
			E.EMPLOYEE_ID = #attributes.employee_id#
		<cfelse>
			E.EMPLOYEE_ID IN (#attributes.employee_id_list#)
		</cfif>
</cfquery>
<cfif not len(get_all_mails.EMPLOYEE_EMAIL)>
	<script type="text/javascript">
		alert('Geçerli Mail Adresi Bulunamadı!');
			<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_emp_pdks&form_submit=1</cfoutput>";

	</script>
<cfelse>
<cfif len(attributes.message_type)>
	<cfquery name="get_mail_warnings" datasource="#dsn#">
		SELECT DETAIL FROM SETUP_MAIL_WARNING WHERE MAIL_CAT_ID = #attributes.message_type#
	</cfquery>
</cfif>
<cfoutput query="get_all_mails">
	<cfset employee_id_ = EMPLOYEE_ID>
	<cfquery name="get_old_mails" datasource="#dsn#" maxrows="1">
		SELECT 
			ROW_ID 
		FROM 
			 EMPLOYEE_DAILY_IN_OUT_MAILS
		WHERE 
			EMPLOYEE_ID = #employee_id_# AND 
			ACTION_DATE = #attributes.aktif_gun#
	</cfquery>
	
	<cfif get_old_mails.recordcount>
		<cfquery name="upd_" datasource="#dsn#">
			UPDATE 
				EMPLOYEE_DAILY_IN_OUT_MAILS 
			SET 
				LAST_MAIL_DATE = #NOW()#,
				UPDATE_EMP = #session.ep.userid#
			WHERE 
				ROW_ID = #get_old_mails.ROW_ID#
		</cfquery>
	<cfelse>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_DAILY_IN_OUT_MAILS 
				(
				EMPLOYEE_ID,
				ACTION_DATE,
				FIRST_MAIL_DATE,
				RECORD_EMP
				)
				VALUES
				(
				#employee_id_#,
				#attributes.aktif_gun#,
				#now()#,
				#session.ep.userid#		
				)
		</cfquery>
	</cfif>
	<cfsavecontent variable="message"><cfoutput>PDKS Uyarı Sistemi</cfoutput></cfsavecontent>
    <cfif len(EMPLOYEE_EMAIL)>
		<cfmail to="#EMPLOYEE_EMAIL#"
			from="#session.ep.company#<#session.ep.company_email#>"
			subject="#message#" type="HTML">
			Sayın #employee_name# #employee_surname#,
			<br/><br/>
			<a href="#employee_domain##request.self#?fuseaction=myhome.list_my_pdks&aktif_gun=#dateformat(attributes.aktif_gun,dateformat_style)#" target="_blank">PDKS Durumunuz</a> <br/><br/>
			
			<cfif len(attributes.message_type)>
				#get_mail_warnings.DETAIL#
			<cfelse>
				Lütfen PDKS Durumunuzu Kontrol Ediniz!...
			</cfif>
				<br/><br/>
			Herhangi Bir Sorunla Karşılaşmanız Durumunda Lütfen İnsan Kaynakları Müdürlüğüne Başvurunuz.<br/><br/>
		</cfmail>
	</cfif>
</cfoutput>
<script type="text/javascript">
	alert('<cf_get_lang dictionary_id="40530.Mailler Başarı İle Gönderildi!">');
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href="<cfoutput>#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_emp_pdks&form_submit=1</cfoutput>";
</script>
</cfif>
