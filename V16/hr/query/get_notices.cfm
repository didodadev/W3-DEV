<cfif len(attributes.STARTDATE)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.FINISHDATE)>
	<cf_date tarih="attributes.finishdate">
</cfif>

<cfquery name="GET_NOTICES" datasource="#dsn#">
  SELECT
  		NOTICE_CAT_ID,
		NOTICE_ID,
		NOTICE_NO,
		NOTICE_HEAD,
		RECORD_DATE,
		POSITION_ID,
		POSITION_NAME,
		POSITION_CAT_ID,
		POSITION_CAT_NAME,
		RECORD_EMP,
		STARTDATE,
		FINISHDATE,
		COMPANY_ID,
		COMPANY,
		OUR_COMPANY_ID,
		STATUS,
		DEPARTMENT_ID,
		BRANCH_ID,
		COMPANY_ID,
		STATUS_NOTICE,
		(SELECT COUNT(NOTICE_ID) FROM EMPLOYEES_APP_POS WHERE NOTICE_ID = NOTICES.NOTICE_ID) AS BASVURU_SAYISI
	FROM
		NOTICES
	WHERE
		NOTICE_ID IS NOT NULL
	<cfif attributes.status eq 1>
		AND STATUS = 0
	<cfelseif attributes.status eq 2>
		AND STATUS = 1
	</cfif> 
	<cfif attributes.status_notice eq -1>
		AND STATUS_NOTICE = -1
	<cfelseif attributes.status_notice eq -2>
		AND STATUS_NOTICE = -2
	</cfif>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>   
		AND  
			( 
			NOTICES.NOTICE_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR
			NOTICES.NOTICE_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
	</cfif>		
	<cfif isDefined("attributes.STARTDATE")>
		<cfif len(attributes.STARTDATE) AND len(attributes.FINISHDATE)>
		<!--- IKI TARIH DE VAR --->
		AND
		(
			(
			NOTICES.STARTDATE >= #attributes.STARTDATE# AND
			NOTICES.STARTDATE <= #attributes.FINISHDATE#
			)
		OR
			(
			NOTICES.STARTDATE <= #attributes.STARTDATE# AND
			NOTICES.FINISHDATE >= #attributes.STARTDATE#
			)
		)
		<cfelseif len(attributes.STARTDATE)>
		<!--- SADECE BAŞLANGIÇ --->
		AND
		(
		NOTICES.STARTDATE >= #attributes.STARTDATE#
		OR
			(
			NOTICES.STARTDATE < #attributes.STARTDATE# AND
			NOTICES.FINISHDATE >= #attributes.STARTDATE#
			)
		)
		<cfelseif len(attributes.FINISHDATE)>
		<!--- SADECE BITIŞ --->
		AND
		(
		NOTICES.FINISHDATE <= #attributes.FINISHDATE#
		OR
			(
			NOTICES.STARTDATE <= #attributes.FINISHDATE# AND
			NOTICES.FINISHDATE > #attributes.FINISHDATE#
			)
		)
		</cfif>
	</cfif>
	<cfif isdefined('attributes.comp_id') and len(attributes.comp_id) and attributes.comp_id is not "all">
			AND OUR_COMPANY_ID=#attributes.comp_id#
	</cfif>
	<cfif len(attributes.company_id) and len(attributes.company)>
		AND NOTICES.COMPANY_ID=#ATTRIBUTES.COMPANY_ID#
	</cfif>
	<cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
		AND NOTICES.BRANCH_ID=#attributes.branch_id#  	
	</cfif>
	<cfif isdefined('attributes.department') and len(attributes.department) and attributes.department is not "all">
		AND NOTICES.DEPARTMENT_ID=#attributes.department#  	
	</cfif>
	<cfif isdefined('attributes.notice_cat_id') and len(attributes.notice_cat_id)>
		AND NOTICES.NOTICE_CAT_ID IN (#attributes.notice_cat_id#)
	</cfif>
	ORDER BY
		RECORD_DATE DESC
</cfquery>
