<cfquery name="GET_STORES" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_ID,
		B.BRANCH_ID,
		B.COMPANY_ID,
		B.BRANCH_NAME,			
		D.DEPARTMENT_HEAD
	  <cfif isdefined("attributes.is_ingroup")>
		,CP.COMPANY_ADDRESS
		,CP.COMPANY_ID AS GRP_COMP_ID
		,CP.FULLNAME
		,(SELECT TOP 1
			PARTNER_ID
		FROM
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_STATUS = 1 AND
			COMPANY_ID = CP.COMPANY_ID
		ORDER BY 
			PARTNER_ID
		) AS PARTNER_ID
		,(SELECT TOP 1
			COMPANY_PARTNER_NAME
		FROM
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_STATUS = 1 AND
			COMPANY_ID = CP.COMPANY_ID
		ORDER BY 
			PARTNER_ID
		) AS COMPANY_PARTNER_NAME
		,(SELECT TOP 1
			COMPANY_PARTNER_SURNAME
		FROM
			COMPANY_PARTNER
		WHERE 
			COMPANY_PARTNER_STATUS = 1 AND 
			COMPANY_ID = CP.COMPANY_ID
		ORDER BY 
			PARTNER_ID
		) AS COMPANY_PARTNER_SURNAME
	  </cfif>
	FROM 
		DEPARTMENT D,
		BRANCH B
	  <cfif isdefined("attributes.is_ingroup")>
		,OUR_COMPANY O
		,COMPANY CP
	  </cfif>
	WHERE 
		D.IS_STORE <> 2
	  <cfif not isdefined("attributes.is_ingroup") and (isdefined("attributes.system_company_id") and len(attributes.system_company_id))>
		AND	B.COMPANY_ID = #attributes.system_company_id#
	  <cfelseif isdefined("attributes.is_ingroup")>
		AND	B.COMPANY_ID <> #attributes.system_company_id#
	  </cfif>
	  <cfif not (isdefined('attributes.dsp_all_departmants') and attributes.dsp_all_departmants eq 1)>
		  <cfif not isdefined("attributes.is_ingroup") and isdefined("attributes.is_branch")>
			AND B.BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
		  <cfelseif isdefined("attributes.is_ingroup")>
			AND B.BRANCH_ID <> #ListGetAt(session.ep.user_location,2,"-")#
		  </cfif>
	  </cfif>
		AND B.BRANCH_ID = D.BRANCH_ID
		AND D.DEPARTMENT_STATUS = 1
	  <cfif isdefined("attributes.is_ingroup") and (isdefined("attributes.system_company_id") and len(attributes.system_company_id))>
		AND O.COMP_ID = B.COMPANY_ID
		AND CP.OUR_COMPANY_ID <> #attributes.system_company_id#
		AND CP.OUR_COMPANY_ID = O.COMP_ID
	  </cfif>
  	<cfif isdefined("attributes.department_id_value") and len(attributes.department_id_value)>
		AND D.DEPARTMENT_ID = #attributes.department_id_value#
  	</cfif>	  
	ORDER BY
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD
</cfquery>
