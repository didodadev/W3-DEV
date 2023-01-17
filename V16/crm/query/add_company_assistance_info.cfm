
<cf_date tarih='attributes.birthdate'>
<cf_date tarih='attributes.married_date'>
<cflock name="#createUUID()#" timeout="100">
  <cftransaction>
	<cfquery name="ADD_COMPANY_ASSINTANCE_INFO" datasource="#dsn#">
		INSERT INTO
			COMPANY_PARTNER
		(
			ASSISTANCE_STATUS,
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			MOBIL_CODE,
			MOBILTEL,
			MAIL,
			SEX,
			PURCHASE_AUTHORITY,
			DEPOT_RELATION,
			COMPANY_PARTNER_STATUS,
			COMPANY_ID,
			IS_UNIVERSITY,
			RECORD_DATE,
			RECORD_MEMBER,
			RECORD_IP,
			MISSION,
			<!--- DEPARTMENT, --->
			TITLE
		)
		VALUES
		(
		   <cfif len(attributes.asistance_status)>#listgetat(attributes.asistance_status,1)#<cfelse>NULL</cfif>,
		   '#attributes.name#',
		   '#attributes.surname#',
			<cfif len(attributes.mobil_code)>'#attributes.mobil_code#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mobil_num)>'#attributes.mobil_num#'<cfelse>NULL</cfif>,
			<cfif len(attributes.mail)>'#attributes.mail#',<cfelse>NULL,</cfif>
			<cfif len(attributes.sex)>#attributes.sex#<cfelse>NULL</cfif>,
			<cfif len(attributes.purchase_authority)>#attributes.purchase_authority#<cfelse>NULL</cfif>,
			<cfif len(attributes.depot_relation)>#attributes.depot_relation#<cfelse>NULL</cfif>,
			1,									
			#attributes.company_id#,
			<cfif len(attributes.is_university)>#attributes.is_university#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
		   '#cgi.remote_addr#',
		   <cfif len(attributes.asistance_status)>#listgetat(attributes.asistance_status,1)#<cfelse>NULL</cfif>,
		   <!--- <cfif len(attributes.department)>#attributes.department#,<cfelse>NULL,</cfif> --->
		   <cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>
		)
	</cfquery>
	<cfquery name="maxid" datasource="#dsn#">
		SELECT MAX(PARTNER_ID) AS MAXP_ID FROM COMPANY_PARTNER 
	</cfquery>
	<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#dsn#">
		INSERT INTO
			COMPANY_PARTNER_DETAIL
		(
			PARTNER_ID,
			BIRTHDATE,
			BIRTHPLACE,
			MARRIED_DATE,
			MARRIED,
			FACULTY,
			EDU1
		)
		VALUES
		(
			#maxid.maxp_id#,
			<cfif len(attributes.birthdate)>#attributes.birthdate#,<cfelse>NULL,</cfif>
			<cfif len(attributes.birthplace)>'#attributes.birthplace#',<cfelse>NULL,</cfif>
			<cfif len(attributes.married_date)>#attributes.married_date#,<cfelse>NULL,</cfif>
			<cfif len(attributes.is_married)>#attributes.is_married#,<cfelse>NULL,</cfif>
			<cfif len(attributes.faculty)>#listfirst(attributes.faculty, ',')#,<cfelse>NULL,</cfif>
			<cfif len(attributes.faculty)>'#listlast(attributes.faculty, ',')#'<cfelse>NULL</cfif>
		)
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
					#maxid.maxp_id#
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

