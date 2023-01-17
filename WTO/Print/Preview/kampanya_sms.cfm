<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT
		CAMP_ID,
		USER_FRIENDLY_URL,
		PROJECT_ID,
		CAMP_HEAD,
		COMPANY_CAT,
		IS_EXTRANET,
		CONSUMER_CAT,
		IS_INTERNET,
		CAMP_STATUS,
		CAMP_NO,
		CAMP_TYPE,
		CAMP_TYPE_NAME=(SELECT CAMPAIGN_TYPES.CAMP_TYPE FROM CAMPAIGN_TYPES WHERE CAMPAIGN_TYPES.CAMP_TYPE_ID = CAMPAIGNS.CAMP_TYPE),
		CAMP_CAT_ID,
		SUB_CAT=(SELECT CAMPAIGN_CATS.CAMP_CAT_NAME  FROM CAMPAIGN_CATS WHERE CAMPAIGN_CATS.CAMP_CAT_ID= CAMPAIGNS.CAMP_CAT_ID),
		PROCESS_STAGE,
		CAMP_STARTDATE,
		CAMP_FINISHDATE,
		CAMP_OBJECTIVE,
		LEADER_EMPLOYEE_ID,
		RECORD_EMP,
		UPDATE_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		CAMP_STAGE_ID,
		PART_TIME
   	FROM
		CAMPAIGNS   
    WHERE
        1=1    
        <cfif isDefined("attributes.id") and len(attributes.id)>
        	AND	CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfif>
</cfquery>
<cfquery name="get_process_row_name" datasource="#DSN#">
	SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CAMPAIGN.PROCESS_STAGE#">
</cfquery>
<cfquery name="get_project" datasource="#dsn#">
	SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#CAMPAIGN.PROJECT_ID#">
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	    COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		 
</cfquery>
<!--- <cfdump var="#CAMPAIGN#" abort>
 --->
<table style="width:210mm">
    <tr>
        <td>
            <table style="width:100%;">
                <tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='31098.Kampanyalar'></td>
                    <td style="text-align:right;">
                        <cfif len(check.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                 </tr>
			</table>
		</td>
	</tr>
	<tr>
        <td>
			
            <table style="width:100%;" align="center">
				<cfoutput>
					<tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='33079.Kampanya No'></b></td>
                        <td style="width:170px">#CAMPAIGN.CAMP_NO#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57480.Konu'></b></td>
                        <td style="width:170px">#campaign.camp_head#</td>
                    </tr>
                    <tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57486.Kategori'></b></td>
							
                        <td style="width:170px">#CAMPAIGN.CAMP_TYPE_NAME#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='58859.Süreç'></b></td>
                        <td style="width:170px">#get_process_row_name.STAGE#</td>
                    </tr>
					<tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='31061.Alt Kategori'></b></td>
                        <td style="width:170px">#CAMPAIGN.SUB_CAT#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='49362.Katılım Taahhüt Süresi'></b></td>
                        <td style="width:170px">#campaign.part_time# <cf_get_lang dictionary_id='58724.Ay'></td>
                    </tr>
					<tr>
						<cfset start_date_ = date_add('h',session.ep.time_zone,campaign.camp_startdate)>
						<cfset finish_date_ = date_add('h',session.ep.time_zone,campaign.camp_finishdate)>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></b></td>
                        <td style="width:170px">#dateformat(start_date_,dateformat_style)#</td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
                        <td style="width:170px">#dateformat(finish_date_,dateformat_style)#</td>
                    </tr>
					<tr>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='33080.İlgili Proje'></b></td>
                        <td style="width:170px"><cfif get_project.recordCount>#get_project.PROJECT_HEAD#</cfif></td>
                        <td style="width:140px"><b><cf_get_lang dictionary_id='32800.Lider'></b></td>
                        <td style="width:170px">#get_emp_info(campaign.leader_employee_id,0,0)#</td>
                    </tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<br><br>
<table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
	</tr>
</table>
