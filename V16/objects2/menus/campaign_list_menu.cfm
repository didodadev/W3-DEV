<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT DISTINCT
		C.CAMP_NO,
		C.CAMP_ID,
		C.CAMP_STARTDATE,
		C.CAMP_FINISHDATE,
		C.CAMP_HEAD,
		C.LEADER_EMPLOYEE_ID,
		CAMPAIGN_CATS.CAMP_CAT_NAME,
        UFU.USER_FRIENDLY_URL
	FROM
		<cfif (isdefined("attributes.product_catid") and len(attributes.product_catid)) or (isdefined("attributes.brand_id") and len(attributes.brand_id))>
			PROMOTIONS P,
		</cfif>
		CAMPAIGNS C
        OUTER APPLY(
			SELECT TOP 1 UFU.USER_FRIENDLY_URL 
			FROM #dsn#.USER_FRIENDLY_URLS UFU 
			WHERE UFU.ACTION_TYPE = 'CAMP_ID' 
			AND UFU.ACTION_ID = C.CAMP_ID 		
			AND UFU.PROTEIN_SITE = #GET_PAGE.PROTEIN_SITE#) UFU,	
		CAMPAIGN_CATS
	WHERE
		C.CAMP_STATUS = 1 AND
		C.CAMP_CAT_ID = CAMPAIGN_CATS.CAMP_CAT_ID AND
		C.CAMP_STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		C.CAMP_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">		
		<cfif isdefined("session.ww.consumer_category")>
			AND (C.CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> AND C.IS_INTERNET = 1)
		<cfelseif isdefined("session.pp.company_category")>
			AND (C.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> AND C.IS_EXTRANET = 1)
		<cfelse>
			AND C.IS_INTERNET = 1
		</cfif>		
</cfquery>

<cfset column_width = 12 / attributes.campaign_column_number>

<cfif campaign.recordcount>	
	<div>
		<h1>
			<cfif isDefined("attributes.campaign_menu_header") and len(attributes.campaign_menu_header)>
				<cf_get_lang dictionary_id='#attributes.campaign_menu_header#'>
			</cfif>
		</h1>
		<ul>
		<cfoutput query="campaign"> 	
			<li>
				<a href="#USER_FRIENDLY_URL#" class="camp_link">#camp_head#</a>
			</li>
		</cfoutput>
		</ul>
	</div>
</cfif>