<cf_papers paper_type="OPPORTUNITY">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>

<cfif isdefined("OPP_DATE") and len(OPP_DATE)> 
	<CF_DATE tarih="OPP_DATE"> 
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_OPPORTUNITY" datasource="#DSN3#">
		INSERT INTO
			OPPORTUNITIES
			(
				<cfif isdefined("MEMBER_TYPE") and (MEMBER_TYPE is "PARTNER")>PARTNER_ID,COMPANY_ID,
				<cfelseif isdefined("MEMBER_TYPE") and (MEMBER_TYPE is "CONSUMER")>CONSUMER_ID,</cfif>
				<cfif COMMETHOD_ID neq 0>COMMETHOD_ID,</cfif>
				<cfif CATALOG_ID neq 0>CATALOG_ID, </cfif>
				<cfif isdefined("PRODUCT_CAT_ID") and isdefined("PRODUCT_CAT") and len(PRODUCT_CAT) and len(PRODUCT_CAT_ID)>PRODUCT_CAT_ID,</cfif>
				<cfif isDefined("OPP_DETAIL") and len(OPP_DETAIL)>OPP_DETAIL,</cfif>
				<cfif len(INCOME)>INCOME, </cfif>
				<cfif len(MONEY)>MONEY, </cfif>
				<cfif len(STOCK_ID)>STOCK_ID,</cfif>
				<cfif len(SALES_POSITION_CODE)>SALES_POSITION_CODE, </cfif>
				<cfif len(SALES_PARTNER_ID)>SALES_PARTNER_ID,</cfif>
				<cfif isdefined("OPP_DATE") and len(OPP_DATE)>OPP_DATE,</cfif>
				OPP_CURRENCY_ID,
				OPP_STATUS,
				<cfif len(ACTIVITY_TIME)>ACTIVITY_TIME,</cfif>	
				<cfif probability neq 0>PROBABILITY,</cfif>	
				OPP_HEAD,
				RECORD_EMP,
				OPP_ZONE,
				RECORD_IP
				<cfif  len(attributes.project_head) and len(attributes.PROJECT_ID) >,PROJECT_ID</cfif>
				,RECORD_DATE
				,OPP_NO
			)
		VALUES
			(
				<cfif isdefined("MEMBER_TYPE") and (MEMBER_TYPE is "PARTNER")><cfif len(MEMBER_ID)>#MEMBER_ID#<cfelse>NULL</cfif>,#attributes.COMPANY_ID#,
				<cfelseif isdefined("MEMBER_TYPE") and (MEMBER_TYPE is "CONSUMER")>#MEMBER_ID#,</cfif>
				<cfif COMMETHOD_ID neq 0>#COMMETHOD_ID#, </cfif>
				<cfif CATALOG_ID neq 0>#CATALOG_ID#, </cfif>
				<cfif isdefined("PRODUCT_CAT_ID") and isdefined("PRODUCT_CAT") and len(PRODUCT_CAT) and len(PRODUCT_CAT_ID)>#PRODUCT_CAT_ID#, </cfif>
				<cfif isDefined("OPP_DETAIL") and len(OPP_DETAIL)>'#OPP_DETAIL#',</cfif>
				<cfif len(INCOME)>#INCOME#,</cfif>
				<cfif len(MONEY)>'#MONEY#',</cfif>	
				<cfif len(STOCK_ID)>#STOCK_ID#, </cfif>
				<cfif len(SALES_POSITION_CODE)>#SALES_POSITION_CODE#,</cfif>
				<cfif len(SALES_PARTNER_ID)>#SALES_PARTNER_ID#, </cfif>
				<cfif isdefined("OPP_DATE") and len(OPP_DATE)>#OPP_DATE#,</cfif>
				-1,
				1,
				<cfif len(ACTIVITY_TIME)>#ACTIVITY_TIME#,</cfif>
				<cfif probability neq 0>#PROBABILITY#,</cfif>
				'#OPP_HEAD#',
				#SESSION.EP.USERID#,
				0,
				'#CGI.REMOTE_ADDR#'
				<cfif len(attributes.project_head) and len(attributes.PROJECT_ID)>,#attributes.PROJECT_ID#</cfif>
				,#NOW()#
				,'#system_paper_no#'	
			)	
		</cfquery>
		<cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
			UPDATE 
				GENERAL_PAPERS
			SET
				OPPORTUNITY_NUMBER=#system_paper_no_add#
			WHERE
				OPPORTUNITY_NUMBER IS NOT NULL
		</cfquery>		
		<cfquery name="GET_OPP_MAX" datasource="#DSN3#">
			SELECT
				MAX(OPP_ID) AS MAX_ID
			FROM
				OPPORTUNITIES
		</cfquery>
	</cftransaction>
</cflock>
<script language="JavaScript" type="text/javascript">
	window.close();
</script>
