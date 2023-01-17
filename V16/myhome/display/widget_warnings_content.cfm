<!--- 
    Author: Uğur Hamurpet
    Date: 04.11.2020
    Desc: Get teams process and stages count
    widget Name: myProcess
--->

<cfparam  name="attributes.start_response_date" default="#dateformat(date_add('m',-1,now()),dateformat_style)#">
<cfparam  name="attributes.finish_response_date" default="#dateformat(now(),dateformat_style)#">
<cfparam  name="attributes.new_position_code" default="#session.ep.position_code#"><!---- Vekalet edilen kullanıcılar için kontrol uygulanır! ---->

<cfif len( attributes.start_response_date ) and isDate( attributes.start_response_date )><cf_date tarih = "attributes.start_response_date"></cfif>
<cfif len( attributes.finish_response_date ) and isDate( attributes.finish_response_date )><cf_date tarih = "attributes.finish_response_date"></cfif>

<cfset my_team = createObject("component","V16.myhome.cfc.my_team") />
<cfset get_warnings = my_team.get_warnings( 
    start_response_date: attributes.start_response_date, 
    finish_response_date:attributes.finish_response_date,
    position_code: attributes.new_position_code
)/>


<cfif get_warnings.recordcount>
    <cfquery name = "get_process" datasource="#dsn#" dbtype="query">
        SELECT
            PROCESS_ID, PROCESS_NAME, SUM(PROCESS_STAGE_COUNT) AS PROCESS_STAGE_COUNT
        FROM GET_WARNINGS 
        GROUP BY PROCESS_ID, PROCESS_NAME
    </cfquery>
    <div class="ui-dashboard ui-dashboard_type3">
    <cfoutput query="get_process">
            <div class="ui-dashboard-item">
                <div class="ui-dashboard-item-title">
                    #PROCESS_NAME#
                </div>
                <div class="ui-dashboard-item-text ui-dashboard-item-text_type2 ui-dashboard-item-text_type3">
                    <cfquery name="get_process_stage" datasource="#dsn#" dbtype="query">
                        SELECT PROCESS_ROW_ID, STAGE, PROCESS_STAGE_COUNT FROM GET_WARNINGS WHERE PROCESS_ID = #PROCESS_ID# ORDER BY STAGE ASC
                    </cfquery>
                    <cfif get_process_stage.recordcount>
                        <cfloop query="get_process_stage">
                            <a href="javascript://" onclick="gotoWorkflow('#get_process.PROCESS_ID#','#get_process_stage.PROCESS_ROW_ID#')">#get_process_stage.PROCESS_STAGE_COUNT# - #get_process_stage.STAGE#</a>
                        </cfloop>
                    </cfif>
                </div>    
            </div>   
    </cfoutput>
    </div>
<!--- <cfelse>
    <div class="pdn-r-0 pt-3"><cf_get_lang dictionary_id='57484.Kayit Yok'>!</div> --->
</cfif>

<script>

    function gotoWorkflow( process_id, process_row_id ) {
        window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=2&process_id='+ process_id +'&process_row_id='+ process_row_id +'','Workflow');
    }

</script>