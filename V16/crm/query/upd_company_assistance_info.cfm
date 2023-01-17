<cfif len(attributes.birthdate)><cf_date tarih='attributes.birthdate'></cfif>
<cfif len(attributes.married_date)><cf_date tarih='attributes.married_date'></cfif>

<cflock name="#createUUID()#" timeout="100">
	<cftransaction>
		<cfquery name="UPD_COMPANY_ASSISTANCE_INFO" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER
			SET
				COMPANY_PARTNER_NAME = '#attributes.name#',
				COMPANY_PARTNER_SURNAME = '#attributes.surname#',
				MOBIL_CODE = <cfif len(attributes.mobil_code)>'#attributes.mobil_code#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.mobil_num)>'#attributes.mobil_num#'<cfelse>NULL</cfif>,
				MAIL = <cfif len(attributes.mail)>'#attributes.mail#'<cfelse>NULL</cfif>,
				SEX = <cfif len(attributes.sex)>#attributes.sex#<cfelse>NULL</cfif>,
				PURCHASE_AUTHORITY = <cfif len(attributes.purchase_authority)>#attributes.purchase_authority#,<cfelse>NULL,</cfif>
				DEPOT_RELATION = <cfif len(attributes.depot_relation)>#attributes.depot_relation#,<cfelse>NULL,</cfif>
				COMPANY_PARTNER_STATUS = 1,		
				IS_UNIVERSITY = <cfif len(attributes.is_university)>#attributes.is_university#,<cfelse>NULL,</cfif>
				MISSION = <cfif len(attributes.mission)>#listgetat(attributes.mission,1)#,<cfelse>NULL,</cfif>
				<!--- DEPARTMENT = <cfif len(attributes.department)>#attributes.department#,<cfelse>NULL,</cfif> --->
				ASSISTANCE_STATUS=<cfif len(attributes.mission)>#listgetat(attributes.mission,1)#,<cfelse>NULL,</cfif>
				TITLE = <cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_MEMBER = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER_DETAIL
			SET
				BIRTHDATE = <cfif len(attributes.birthdate)>#attributes.birthdate#,<cfelse>NULL,</cfif>
				BIRTHPLACE = <cfif len(attributes.birthplace)>'#attributes.birthplace#',<cfelse>NULL,</cfif>
				MARRIED_DATE = <cfif len(attributes.married_date)>#attributes.married_date#,<cfelse>NULL,</cfif>
				MARRIED = <cfif len(attributes.is_married)>#attributes.is_married#,<cfelse>NULL,</cfif>
				FACULTY = <cfif len(attributes.faculty)>#listfirst(attributes.faculty, ',')#,<cfelse>NULL,</cfif>
				EDU1 = <cfif len(attributes.faculty)>'#listlast(attributes.faculty, ',')#'<cfelse>NULL</cfif>
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>

		<cfquery name="DEL_HOBBY" datasource="#dsn#">
			DELETE 	
			FROM
				COMPANY_PARTNER_HOBBY 
			WHERE
				PARTNER_ID = #attributes.partner_id# 
		</cfquery>
		<cfif isDefined('attributes.hobby')>
			<cfloop list="#attributes.hobby#" index="i">
				<cfquery name="ins_hobb" datasource="#dsn#">
					INSERT INTO 
						COMPANY_PARTNER_HOBBY
					(
						HOBBY_ID,
						PARTNER_ID
					)
					VALUES
					(
						#i#,
						#partner_id#
					)
				</cfquery>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable") and attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		window.close();
		wrk_opener_reload();
	</cfif>
</script>
