<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT 
		CAMPAIGNS.CAMP_HEAD,
        CAMPAIGNS.CAMP_TYPE,
        CAMPAIGNS.CAMP_OBJECTIVE,
        CAMPAIGNS.CAMP_STARTDATE,
        CAMPAIGNS.CAMP_FINISHDATE 
	FROM 
		CAMPAIGNS,
		CAMPAIGN_CATS
	WHERE 
		CAMPAIGNS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
		CAMPAIGNS.CAMP_STATUS = 1 AND
		CAMPAIGNS.CAMP_CAT_ID = CAMPAIGN_CATS.CAMP_CAT_ID AND
		CAMPAIGNS.CAMP_STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
		CAMPAIGNS.CAMP_FINISHDATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> 
		<cfif isdefined("session.ww.consumer_category")>
			AND (CAMPAIGNS.CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.ww.consumer_category#%"> AND CAMPAIGNS.IS_INTERNET = 1)
		<cfelseif isdefined("session.pp.company_category")>
			AND (CAMPAIGNS.COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#session.pp.company_category#%"> AND CAMPAIGNS.IS_EXTRANET = 1)
		<cfelse>
			AND CAMPAIGNS.IS_INTERNET = 1
		</cfif>
</cfquery>
<cfif not campaign.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1141.Üye İle İlişkili Kampanya Bulunamadı'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_CAMP_TYPES" datasource="#DSN3#">
	SELECT CAMP_TYPE FROM CAMPAIGN_TYPES WHERE CAMP_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#campaign.camp_type#">
</cfquery>

<cfoutput query="campaign">
    <table>
        <tr>
            <td class="headbold">#camp_head#</td>
        </tr>
        <tr>
            <td><b><cf_get_lang_main no='74.Kategori'>:</b> #get_camp_types.camp_type# / <B><cf_get_lang_main no='1212.Geçerlilik Tarihi'>:</b> <cfif isdefined("session.pp.userid")>#dateformat(date_add('h',session.pp.time_zone,camp_startdate),'dd/mm/yyyy')#<cfelse>#dateformat(date_add('h',session.ww.time_zone,camp_startdate),'dd/mm/yyyy')#</cfif> - <cfif isdefined("session.pp.userid")>#dateformat(date_add('h',session.pp.time_zone,campaign.camp_finishdate),'dd/mm/yyyy')#<cfelse>#dateformat(date_add('h',session.ww.time_zone,campaign.camp_finishdate),'dd/mm/yyyy')#</cfif></td>
        </tr>
        <tr>
            <td>#camp_objective# <br/> <br/></td>
        </tr>
    </table>
</cfoutput>
