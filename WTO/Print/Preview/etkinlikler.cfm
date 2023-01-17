<cfquery name="get_organizations" datasource="#DSN#">
	SELECT 
		ORGANIZATION_HEAD,
		ORGANIZATION_CAT_ID,
		ORGANIZATION_CAT=(SELECT OC.ORGANIZATION_CAT_NAME FROM ORGANIZATION_CAT AS OC WHERE OC.ORGANIZATION_CAT_ID= ORGANIZATION.ORGANIZATION_CAT_ID),
		ORGANIZER_EMP,
		ORGANIZER_CON,
		ORGANIZER_PAR,
		START_DATE,
		FINISH_DATE,
		MAX_PARTICIPANT,
		ADDITIONAL_PARTICIPANT,
		ORGANIZATION_PLACE,
		ORGANIZATION_PLACE_ADDRESS,
		ORGANIZATION_PLACE_TEL,
		ORGANIZATION_PLACE_MANAGER,
		ORGANIZATION_TARGET,
		CAMPAIGN_ID,
		CAMPAIGN_NAME=(SELECT C.CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS C WHERE C.CAMP_ID=ORGANIZATION.CAMPAIGN_ID),
		PROJECT_ID,
		PROJECT_NAME=(SELECT P.PROJECT_HEAD FROM PRO_PROJECTS P WHERE P.PROJECT_ID=ORGANIZATION.PROJECT_ID),
		TOTAL_DATE,
		TOTAL_HOUR,
		ORG_STAGE,
		STAGE=(SELECT PTR.STAGE FROM PROCESS_TYPE_ROWS AS PTR WHERE PTR.PROCESS_ROW_ID= ORGANIZATION.ORG_STAGE)
	FROM 
 		ORGANIZATION
	WHERE 
		ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfif not get_organizations.recordcount>
    <cfset hata  = 10>
    <cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cf_woc_header>
	<cfoutput>
        <cf_woc_elements>
            <cf_wuxi id="organization_cat" data="#get_organizations.ORGANIZATION_CAT#" label="57486" type="cell">
             <cf_wuxi id="organization_head" data="#get_organizations.ORGANIZATION_HEAD#" label="51770" type="cell">
            <cf_wuxi id="paper_no" data="#get_organizations.STAGE#" label="58859" type="cell">
            <cf_wuxi id="emp_name" data="#get_emp_info(get_organizations.ORGANIZER_EMP,0,0)#" label="49714" type="cell">
            <cf_wuxi id="start_date" data="#dateformat(get_organizations.start_date,dateformat_style)# #TimeFormat(get_organizations.start_date,timeformat_style)#" label="58053" type="cell">
            <cf_wuxi id="finish_date" data="#dateformat(get_organizations.finish_date,dateformat_style)# #TimeFormat(get_organizations.finish_date,timeformat_style)#" label="57700" type="cell">
            <cf_wuxi id="total_time" data="#get_organizations.total_date# #getLang('','Gün','57490')# #get_organizations.total_hour# #getLang('','Saat','57491')#" label="46294" type="cell">
            <cf_wuxi id="target" data="#get_organizations.organization_target#" label="55474" type="cell">
           	<cf_wuxi id="max_participant" data="#get_organizations.max_participant# #iif(len(get_organizations.additional_participant),DE('+ #get_organizations.additional_participant#'),DE(''))#" label="49343" type="cell">
             <cf_wuxi id="organization_place" data="#get_organizations.organization_place#" label="49712" type="cell">
            <cf_wuxi id="travel_type" data="#get_organizations.organization_place_manager#" label="49712+57544" type="cell">
            <cf_wuxi id="organization_place_address" data="#get_organizations.organization_place_address#" label="49712+58723" type="cell">
			<cf_wuxi id="organization_tel" data="#get_organizations.organization_place_tel#" label="49712+57499" type="cell">
			<cf_wuxi id="camp_name" data="#get_organizations.CAMPAIGN_NAME#" label="57446" type="cell">
			<cf_wuxi id="project_head" data="#get_organizations.PROJECT_NAME#" label="57416" type="cell">
        </cf_woc_elements>
		<cf_woc_footer>
	</cfoutput>
</cfif>