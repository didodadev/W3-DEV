<!--- partner detay --->
<CF_DATE tarih = "ATTRIBUTES.BIRTHDATE">
	<cfquery name="get_partner_detail" datasource="#dsn#">
		SELECT
			PARTNER_ID
		FROM
			COMPANY_PARTNER_DETAIL
		WHERE
			PARTNER_ID=#attributes.PARTNER_ID#
	</cfquery>
<cfif get_partner_detail.recordcount>
	<cfquery name="upd_partner_detail" datasource="#dsn#">
		UPDATE
			COMPANY_PARTNER_DETAIL
		SET
        	HOMETELCODE = '#ATTRIBUTES.HOMETELCODE#',
			HOMETEL = '#ATTRIBUTES.HOMETEL#',
			IDENTYCAT_ID = #ATTRIBUTES.IDENTYCAT_ID#,
			IDENTYCARD_NO = '#ATTRIBUTES.IDENTYCARD_NO#',
			HOMEADDRESS = '#ATTRIBUTES.HOMEADDRESS#',
			BIRTHPLACE = '#ATTRIBUTES.BIRTHPLACE#',
			HOMEPOSTCODE = '#ATTRIBUTES.HOMEPOSTCODE#',
			BIRTHDATE = #ATTRIBUTES.BIRTHDATE#,
			HOMECOUNTY = '#ATTRIBUTES.HOMECOUNTY#',
			HOMECITY = '#ATTRIBUTES.HOMECITY#',
			EDU1 = '#ATTRIBUTES.EDU1#',
			EDU1_FINISH = <cfif len(ATTRIBUTES.EDU1_FINISH)>#ATTRIBUTES.EDU1_FINISH#<cfelse>NULL</cfif>,
			EDU2 = '#ATTRIBUTES.EDU2#',
			EDU2_FINISH = <cfif len(ATTRIBUTES.EDU2_FINISH)>#ATTRIBUTES.EDU2_FINISH#<cfelse>NULL</cfif>,
			EDU3 = '#ATTRIBUTES.EDU3#',
			EDU3_FINISH = <cfif len(ATTRIBUTES.EDU3_FINISH)>#ATTRIBUTES.EDU3_FINISH#<cfelse>NULL</cfif>,
			EDU4 = '#ATTRIBUTES.EDU4#',
			EDU4_FINISH = <cfif len(ATTRIBUTES.EDU4_FINISH)>#ATTRIBUTES.EDU4_FINISH#<cfelse>NULL</cfif>,
			EDU4_FACULTY = '#ATTRIBUTES.edu4_faculty#',
			EDU4_PART = '#ATTRIBUTES.EDU4_PART#',
			EDU5 = '#ATTRIBUTES.EDU5#',
			EDU5_FINISH = <cfif len(ATTRIBUTES.EDU5_FINISH)>#ATTRIBUTES.EDU5_FINISH#<cfelse>NULL</cfif>,
			EDU5_PART = '#ATTRIBUTES.EDU5_PART#',
			LANG1 = '#ATTRIBUTES.LANG1#',
			LANG1_LEVEL = #ATTRIBUTES.LANG1_LEVEL#,
			LANG2 = '#ATTRIBUTES.LANG2#',
			LANG2_LEVEL = #ATTRIBUTES.LANG2_LEVEL#,		
			MARRIED = <cfif isdefined("attributes.married")>1,<cfelse>0,</cfif>
			CHILD = <cfif len(attributes.CHILD)>#ATTRIBUTES.CHILD#<cfelse>NULL</cfif>,
			TRAINING_LEVEL= <cfif len(ATTRIBUTES.TRAINING_LEVEL)>#ATTRIBUTES.TRAINING_LEVEL#<cfelse>NULL</cfif>
		WHERE
			PARTNER_ID = #attributes.partner_id#
	</cfquery>
<cfelse>
	<cfquery name="add_partner_detail" datasource="#dsn#">
		INSERT INTO
			COMPANY_PARTNER_DETAIL
		(
			HOMETELCODE,
			HOMETEL,
			IDENTYCAT_ID,
			IDENTYCARD_NO,
			HOMEADDRESS,
			BIRTHPLACE,
			HOMEPOSTCODE,
			BIRTHDATE,
			HOMECOUNTY,
			HOMECITY,
			MARRIED,
			CHILD,
			EDU1,
			EDU1_FINISH,
			EDU2,
			EDU2_FINISH,
			EDU3,
			EDU3_FINISH,
			EDU4,
			EDU4_FINISH,
			EDU4_FACULTY,
			EDU4_PART,
			EDU5,
			EDU5_FINISH,
			EDU5_PART,
			LANG1,
			LANG1_LEVEL,
			LANG2,
			LANG2_LEVEL,
			PARTNER_ID,
			TRAINING_LEVEL
		)
		VALUES
		(
			'#ATTRIBUTES.HOMETELCODE#',
			'#ATTRIBUTES.HOMETEL#',
			#ATTRIBUTES.IDENTYCAT_ID#,
			'#ATTRIBUTES.IDENTYCARD_NO#',
			'#ATTRIBUTES.HOMEADDRESS#',
			'#ATTRIBUTES.BIRTHPLACE#',
			'#ATTRIBUTES.HOMEPOSTCODE#',
			#ATTRIBUTES.BIRTHDATE#,
			'#ATTRIBUTES.HOMECOUNTY#',
			'#ATTRIBUTES.HOMECITY#',			
			<cfif isdefined("attributes.married")>1,<cfelse>0,</cfif>
			<cfif len(attributes.CHILD)>#ATTRIBUTES.CHILD#,<cfelse>NULL,</cfif>
			'#ATTRIBUTES.EDU1#',
			<cfif len(ATTRIBUTES.EDU1_FINISH)>#ATTRIBUTES.EDU1_FINISH#<cfelse>NULL</cfif>,
			'#ATTRIBUTES.EDU2#',
			<cfif len(ATTRIBUTES.EDU2_FINISH)>#ATTRIBUTES.EDU2_FINISH#<cfelse>NULL</cfif>,
			'#ATTRIBUTES.EDU3#',
			<cfif len(ATTRIBUTES.EDU3_FINISH)>#ATTRIBUTES.EDU3_FINISH#<cfelse>NULL</cfif>,
			'#ATTRIBUTES.EDU4#',
			<cfif len(ATTRIBUTES.EDU4_FINISH)>#ATTRIBUTES.EDU4_FINISH#<cfelse>NULL</cfif>,
			'#ATTRIBUTES.edu4_faculty#',
			'#ATTRIBUTES.EDU4_PART#',
			'#ATTRIBUTES.EDU5#',
			<cfif len(ATTRIBUTES.EDU5_FINISH)>#ATTRIBUTES.EDU5_FINISH#<cfelse>NULL</cfif>,
			'#ATTRIBUTES.EDU5_PART#',
			'#ATTRIBUTES.LANG1#',
			 #ATTRIBUTES.LANG1_LEVEL#,
			'#ATTRIBUTES.LANG2#',
			 #ATTRIBUTES.LANG2_LEVEL#,
			#attributes.partner_id#,
			#ATTRIBUTES.TRAINING_LEVEL#
		)
	</cfquery>
</cfif>
<!--- partner detay --->
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</script>
