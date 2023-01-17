<cfquery name="CHECK_PAP" datasource="#DSN3#">
	SELECT 
		GENERAL_PAPERS_ID 
	FROM 
		GENERAL_PAPERS
	WHERE 
		ZONE_TYPE = 1 AND 
		PAPER_TYPE = 0	
</cfquery>
	
<cfif not check_pap.recordcount>
	<cfquery name="ADD_GENERAL_PAPERS" datasource="#DSN3#">
		INSERT INTO 
			GENERAL_PAPERS 
		(  
			OFFER_NO,
			OFFER_NUMBER,
			ORDER_NO,
			ORDER_NUMBER,
			PAPER_TYPE,
			ZONE_TYPE
		)		
		VALUES
		(
			'#attributes.offer_no#',
			<cfif len(attributes.offer_number) and isnumeric(attributes.offer_number)>#attributes.offer_number#<cfelse>NULL</cfif>,
			'#attributes.order_no#',
			<cfif len(attributes.order_number) and isnumeric(attributes.order_number)>#attributes.order_number#<cfelse>NULL</cfif>,
			0,
			1
		)
	</cfquery>
<cfelse>
	<cfquery name="UPD_GENERAL_PAPERS" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS 
		SET  
		   OFFER_NO = '#attributes.offer_no#',
		   OFFER_NUMBER = <cfif len(attributes.offer_number) and isnumeric(attributes.offer_number)>#attributes.offer_number#<cfelse>NULL</cfif>,
		   ORDER_NO = '#attributes.order_no#',
		   ORDER_NUMBER = <cfif len(attributes.order_number) and isnumeric(attributes.order_number)>#attributes.order_number#<cfelse>NULL</cfif>,
		   ZONE_TYPE =	<cfif isDefined("attributes.zone_type")>#attributes.zone_type#<cfelse>0</cfif>
		WHERE 
			PAPER_TYPE = 0 AND
			ZONE_TYPE = 1
	</cfquery>
</cfif>		

<cfquery name="CHECK_PAP_2" datasource="#DSN3#">
	SELECT 
		GENERAL_PAPERS_ID 
	FROM 
		GENERAL_PAPERS
	WHERE 
		ZONE_TYPE = 1 AND
		PAPER_TYPE=1		
</cfquery>

<cfif not check_pap_2.recordcount>
	<cfquery name="ADD_GENERAL_PAPER" datasource="#DSN3#">
		INSERT INTO 	
		GENERAL_PAPERS 
		(
			OFFER_NO,
			OFFER_NUMBER,
			ORDER_NO,
			ORDER_NUMBER,
			PAPER_TYPE,
			ZONE_TYPE
		)
		VALUES
		(
			'#attributes.g_offer_no#',
			<cfif len(attributes.g_offer_number) and isnumeric(attributes.g_offer_number)>#attributes.g_offer_number#<cfelse>NULL</cfif>,
			'#attributes.g_order_no#',
			<cfif len(attributes.g_order_number) and isnumeric(attributes.g_order_number)>#attributes.g_order_number#<cfelse>NULL</cfif>,
			1,
			1
		)
	</cfquery>
<cfelse>
	<cfquery name="UPD_GENERAL_PAPERS_GIVE" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS 
		SET
			OFFER_NO = '#attributes.g_offer_no#',
			OFFER_NUMBER = <cfif len(attributes.g_offer_number) and isnumeric(attributes.g_offer_number)>#attributes.g_offer_number#<cfelse>NULL</cfif>,
			ORDER_NO = '#attributes.g_order_no#',
			ORDER_NUMBER = <cfif len(attributes.g_order_number) and isnumeric(attributes.g_order_number)>#attributes.g_order_number#<cfelse>NULL</cfif>,
			ZONE_TYPE =	<cfif isDefined("attributes.zone_type")>#attributes.zone_type#<cfelse>0</cfif>
		WHERE 
			PAPER_TYPE = 1 AND 
			ZONE_TYPE = 1
	</cfquery>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_general_paper">
