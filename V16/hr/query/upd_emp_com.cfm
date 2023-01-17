<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_DETAIL_ID
	FROM 
		EMPLOYEES_DETAIL 
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfquery name="delete_emp_reference" datasource="#dsn#">
	DELETE EMPLOYEES_REFERENCE WHERE EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
</cfquery>	
<cfquery name="delete_emp_im" datasource="#dsn#">
	DELETE EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>
<cfloop from="1" to="#attributes.add_ref_info#" index="r">
	<cfif isdefined('attributes.del_ref_info#r#') and  evaluate('attributes.del_ref_info#r#') eq 1 and len('#wrk_eval('attributes.ref_name#r#')#')><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_reference" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_REFERENCE
			 (
				EMPLOYEE_ID,
				REFERENCE_TYPE,
				REFERENCE_NAME,
				REFERENCE_COMPANY,
				REFERENCE_POSITION,
				REFERENCE_TELCODE,
				REFERENCE_TEL,
				REFERENCE_EMAIL
			 )
			 VALUES
			 (
				#attributes.EMPLOYEE_ID#,
				<cfif len(wrk_eval('attributes.ref_type#r#'))>#wrk_eval('attributes.ref_type#r#')#<cfelse>NULL</cfif>,<!--- '#wrk_eval('attributes.ref_type#r#')#', --->
				<cfif len(wrk_eval('attributes.ref_name#r#'))>'#wrk_eval('attributes.ref_name#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_company#r#'))>'#wrk_eval('attributes.ref_company#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_position#r#'))>'#wrk_eval('attributes.ref_position#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_telcode#r#'))>'#wrk_eval('attributes.ref_telcode#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_tel#r#'))>'#wrk_eval('attributes.ref_tel#r#')#'<cfelse>NULL</cfif>,
				<cfif len(wrk_eval('attributes.ref_mail#r#'))>'#wrk_eval('attributes.ref_mail#r#')#'<cfelse>NULL</cfif>
			 )
		</cfquery>
	</cfif>
</cfloop>
<cfloop from="1" to="#attributes.add_im_info#" index="i">
	<cfif isdefined('attributes.del_im_info#i#') and  evaluate('attributes.del_im_info#i#') eq 1 and len('#wrk_eval('attributes.im_address#i#')#')><!--- silinmemiş ise.. --->
		<cfquery name="add_employees_instant_message" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_INSTANT_MESSAGE
			 (
				EMPLOYEE_ID,
				IMCAT_ID,
                IM_ADDRESS,
                RECORD_DATE,
				RECORD_IP,
				RECORD_EMP                
			 )
			 VALUES
			 (
				#attributes.EMPLOYEE_ID#,
				<cfif len(wrk_eval('attributes.imcat_id#i#'))>#wrk_eval('attributes.imcat_id#i#')#<cfelse>NULL</cfif>,<!--- '#wrk_eval('attributes.ref_type#r#')#', --->
				<cfif len(wrk_eval('attributes.im_address#i#'))>'#wrk_eval('attributes.im_address#i#')#'<cfelse>NULL</cfif>,
                #now()#,
				'#cgi.REMOTE_ADDR#',
				#session.ep.userid#
			 )
		</cfquery>
	</cfif>
</cfloop>
<cfif detail_exists.recordcount>
	<cfquery name="upd_EMPLOYEES_DETAIL" datasource="#dsn#">
		UPDATE
			EMPLOYEES_DETAIL
		SET
			HOMETEL_CODE = <cfif len(attributes.hometel_code)>'#attributes.hometel_code#'<cfelse>NULL</cfif>, 
			HOMETEL = <cfif len(attributes.hometel)>'#attributes.hometel#'<cfelse>NULL</cfif>, 
            NEIGHBORHOOD = <cfif len(attributes.neighborhood)>'#attributes.neighborhood#'<cfelse>NULL</cfif>,
            BOULEVARD = <cfif len(attributes.boulevard)>'#attributes.boulevard#'<cfelse>NULL</cfif>,
            AVENUE = <cfif len(attributes.avenue)>'#attributes.avenue#'<cfelse>NULL</cfif>,
            STREET = <cfif len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
			HOMEPOSTCODE = '#attributes.homepostcode#', 
			HOMECITY = <cfif isdefined('attributes.select_city') and len(attributes.select_city)>#attributes.select_city#,<cfelse>NULL,</cfif>
			HOMECOUNTY = <cfif isdefined('attributes.select_county') and len(attributes.select_county)>#attributes.select_county#,<cfelse>NULL,</cfif> 
			HOMECOUNTRY = <cfif len(attributes.homecountry)>#attributes.homecountry#,<cfelse>NULL,</cfif> 
            HOMEADDRESS = <cfif len(attributes.homeaddress)>'#attributes.homeaddress#'<cfelse>NULL</cfif>,
            EXTERNAL_DOOR_NUMBER = <cfif len(attributes.external_door_number)>'#attributes.external_door_number#',<cfelse>NULL,</cfif> 
            INTERNAL_DOOR_NUMBER = <cfif len(attributes.internal_door_number)>'#attributes.internal_door_number#',<cfelse>NULL,</cfif> 
			DIRECT_TELCODE_SPC = <cfif len(attributes.directTelCode)>'#attributes.directTelCode#'<cfelse>NULL</cfif>,
			DIRECT_TEL_SPC = <cfif len(attributes.directTel)>'#attributes.directTel#'<cfelse>NULL</cfif>,
			EXTENSION_SPC = <cfif len(attributes.extension)>'#attributes.extension#'<cfelse>NULL</cfif>,
			MOBILCODE_SPC = <cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
			MOBILTEL_SPC = <cfif len(attributes.mobilTel)>'#attributes.mobilTel#'<cfelse>NULL</cfif>,
			MOBILCODE2_SPC = <cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#'<cfelse>NULL</cfif>,
			MOBILTEL2_SPC = <cfif len(attributes.mobilTel2)>'#attributes.mobilTel2#'<cfelse>NULL</cfif>,
			EMAIL_SPC =<cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
			CONTACT1 = '#attributes.contact1#',
			CONTACT1_RELATION = '#attributes.contact1_relation#',
			CONTACT1_TELCODE = <cfif len(attributes.contact1_telcode)>'#attributes.contact1_telcode#'<cfelse>NULL</cfif>,
			CONTACT1_TEL = <cfif len(attributes.contact1_tel)>'#attributes.contact1_tel#'<cfelse>NULL</cfif>, 
			CONTACT1_EMAIL = '#attributes.contact1_email#', 
			CONTACT2 = '#attributes.contact2#', 
			CONTACT2_RELATION = '#attributes.contact2_relation#', 
			CONTACT2_TELCODE =<cfif len(attributes.contact2_telcode)> '#attributes.contact2_telcode#'<cfelse>NULL</cfif>, 
			CONTACT2_TEL = <cfif len(attributes.contact2_tel)>'#attributes.contact2_tel#'<cfelse>NULL</cfif>, 
			CONTACT2_EMAIL = '#attributes.contact2_email#', 
			<cfif isdefined("attributes.new_company")>
				NEW_COMPANY = '#attributes.new_company#',
				NEW_COMPANY_POS = '#attributes.new_company_pos#',
			</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#			
		WHERE
			EMPLOYEE_DETAIL_ID = #DETAIL_EXISTS.EMPLOYEE_DETAIL_ID#
	</cfquery>
<cfelse>

	<cfquery name="add_EMPLOYEES_DETAIL" datasource="#DSN#">
		INSERT INTO
			EMPLOYEES_DETAIL
			(
			EMPLOYEE_ID,
			HOMETEL_CODE,
			HOMETEL,
            NEIGHBORHOOD,
            BOULEVARD,
            AVENUE,
            STREET,
            EXTERNAL_DOOR_NUMBER,
            INTERNAL_DOOR_NUMBER,
			HOMEPOSTCODE,
			HOMECOUNTY,
			HOMECITY,
			HOMECOUNTRY,
			CONTACT1,
			CONTACT1_RELATION,
			CONTACT1_TELCODE,
			CONTACT1_TEL,
			CONTACT1_EMAIL,
			CONTACT2,
			CONTACT2_RELATION,
			CONTACT2_TELCODE,
			CONTACT2_TEL,
			CONTACT2_EMAIL,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP,
			DIRECT_TELCODE_SPC,
			DIRECT_TEL_SPC,
			EXTENSION_SPC,
			MOBILCODE_SPC,
			MOBILTEL_SPC,
			MOBILCODE2_SPC,
			MOBILTEL2_SPC,
			EMAIL_SPC
			)
		VALUES
			(
			#attributes.EMPLOYEE_ID#, 
			<cfif len(attributes.HOMETEL_CODE)>'#attributes.HOMETEL_CODE#',<cfelse>NULL,</cfif>
            <cfif len(attributes.HOMETEL)>'#attributes.HOMETEL#',<cfelse>NULL,</cfif>
            <cfif len(attributes.neighborhood)>'#attributes.neighborhood#',<cfelse>NULL</cfif>,
            <cfif len(attributes.boulevard)>'#attributes.boulevard#',<cfelse>NULL</cfif>,
            <cfif len(attributes.avenue)>'#attributes.avenue#',<cfelse>NULL</cfif>,
            <cfif len(attributes.street)>'#attributes.street#',<cfelse>NULL</cfif>,
			<cfif len(attributes.external_door_number)>'#attributes.external_door_number#',<cfelse>NULL</cfif>,
            <cfif len(attributes.internal_door_number)>'#attributes.internal_door_number#',<cfelse>NULL</cfif>,
            <cfif len(attributes.homepostcode)>'#attributes.homepostcode#',<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.select_county') and len(attributes.select_county)>#attributes.select_county#,<cfelse>NULL,</cfif> 
			<cfif isdefined('attributes.select_city') and len(attributes.select_city)>#attributes.select_city#,<cfelse>NULL,</cfif>
			<cfif len(attributes.homecountry)>#attributes.homecountry#,<cfelse>NULL,</cfif> 
			'#attributes.contact1#', 
			'#attributes.contact1_relation#', 
			<cfif len(attributes.contact1_telcode)>'#attributes.contact1_telcode#',<cfelse>NULL,</cfif>
            <cfif len(attributes.contact1_tel)>'#attributes.contact1_tel#',<cfelse>NULL,</cfif>
			'#attributes.contact1_email#', 
			'#attributes.contact2#', 
			'#attributes.contact2_relation#', 
			<cfif len(attributes.contact2_telcode)>'#attributes.contact2_telcode#',<cfelse>NULL,</cfif>
            <cfif len(attributes.contact2_tel)>'#attributes.contact2_tel#',<cfelse>NULL,</cfif>
			'#attributes.contact2_email#', 
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#,
			<cfif len(attributes.directTelCode)>'#attributes.directTelCode#'<cfelse>NULL</cfif>,
			<cfif len(attributes.directTel)>'#attributes.directTel#'<cfelse>NULL</cfif>,
			<cfif len(attributes.extension)>'#attributes.extension#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mobilcode)>'#attributes.mobilcode#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mobilTel)>'#attributes.mobilTel#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mobilcode2)>'#attributes.mobilcode2#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mobilTel2)>'#attributes.mobilTel2#'<cfelse>NULL</cfif>,
			<cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
