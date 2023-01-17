<cfquery name="DETAIL_EXISTS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_IDENTY_ID
	FROM 
		EMPLOYEES_IDENTY
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
</cfquery>

<cfif not isdefined("attributes.married")>
	<cfset attributes.married = 0>
</cfif>

<cfif len(attributes.birth_date)>
	<CF_DATE tarih="attributes.birth_date">
</cfif>
<cfif len(attributes.given_date)>
	<CF_DATE tarih="attributes.given_date">
</cfif>

<cfif detail_exists.recordcount>

	<cfquery name="UPD_IDENTY" datasource="#dsn#">
		UPDATE
			EMPLOYEES_IDENTY
		SET
			NATIONALITY=<cfif len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
			SERIES = '#attributes.series#',
			TC_IDENTY_NO='#attributes.tc_identy_no#',
			NUMBER = '#attributes.number#',
			FATHER = '#attributes.father#',
			MOTHER = '#attributes.mother#',
		<cfif len(attributes.birth_date)>
			BIRTH_DATE = #attributes.birth_date#,
		<cfelse>
			BIRTH_DATE = NULL,
		</cfif>
			BIRTH_CITY = <cfif len(attributes.birth_city)>#attributes.birth_city#<cfelse>NULL</cfif>,
			BIRTH_PLACE = '#attributes.birth_place#',
			TAX_NUMBER = '#attributes.tax_number#',
			TAX_OFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
			MARRIED = <cfif isdefined('attributes.married')>#attributes.married#<cfelse>NULL</cfif>,
			RELIGION = '#attributes.religion#',
		 <cfif LEN(attributes.blood_type)>
		 <!--- BLOOD_TYPE= '#BLOOD_TYPE#',--->
		    BLOOD_TYPE = #attributes.blood_type#,
		 </cfif>
			CITY = '#attributes.city#',
			COUNTY = '#attributes.county#',
			WARD = '#attributes.ward#',
			VILLAGE = '#attributes.village#',
			BINDING = '#attributes.binding#',
			FAMILY = '#attributes.family#',
			CUE = '#attributes.cue#',
			GIVEN_PLACE = '#attributes.given_place#',
			GIVEN_REASON = '#attributes.given_reason#',
			RECORD_NUMBER = '#attributes.record_number#',
		<cfif len(attributes.given_date)>
			GIVEN_DATE = #attributes.given_date#,
		<cfelse>
			GIVEN_DATE = NULL,
		</cfif>
			LAST_SURNAME = '#attributes.last_surname#',
			<cfif isdefined("attributes.socialsec_no")>
				SOCIALSECURITY_NO = <cfif len(attributes.socialsec_no)>'#attributes.socialsec_no#'<cfelse>NULL</cfif>,
			</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#cgi.REMOTE_ADDR#',
			UPDATE_EMP = #session.ep.userid#
		WHERE
			EMPLOYEE_IDENTY_ID = #DETAIL_EXISTS.EMPLOYEE_IDENTY_ID#
	</cfquery>

<cfelse>

	<cfquery name="ADD_IDENTY" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_IDENTY
			(
			EMPLOYEE_ID,
			NATIONALITY,
			TC_IDENTY_NO, 
			SERIES,
			NUMBER,
			FATHER,
			MOTHER,
			BIRTH_DATE,
			BIRTH_PLACE,
			MARRIED,
			RELIGION,
		 <cfif len(attributes.BLOOD_TYPE)>	
			BLOOD_TYPE,
		 </cfif>
			CITY,
			COUNTY,
			WARD,
			VILLAGE,
			BINDING,
			FAMILY,
			CUE,
			GIVEN_PLACE,
			GIVEN_REASON,
			RECORD_NUMBER,
			GIVEN_DATE,
			LAST_SURNAME,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
			)
		VALUES
			(
			#attributes.EMPLOYEE_ID#,
			<cfif len(attributes.nationality)>#attributes.nationality#,<cfelse>NULL,</cfif>
			'#attributes.tc_identy_no#', 
			'#attributes.series#',
			'#attributes.number#',
			'#attributes.father#',
			'#attributes.mother#',
		<cfif len(attributes.birth_date)>
			#attributes.birth_date#,
		<cfelse>
			NULL,
		</cfif>
			'#attributes.birth_place#',
			<cfif isdefined('attributes.married')>#attributes.married#,<cfelse>NULL,</cfif>
			'#attributes.religion#',
		  <cfif LEN(attributes.blood_type)>
			 #attributes.blood_type#,
		  </cfif>	
			'#attributes.city#',
			'#attributes.county#',
			'#attributes.ward#',
			'#attributes.village#',
			'#attributes.binding#',
			'#attributes.family#',
			'#attributes.cue#',
			'#attributes.given_place#',
			'#attributes.given_reason#',
			'#attributes.record_number#',
		<cfif len(attributes.given_date)>
			#attributes.given_date#,
		<cfelse>
			NULL,
		</cfif>
			'#attributes.last_surname#',
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	location.href="<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#attributes.employee_id#</cfoutput>"
</script>
