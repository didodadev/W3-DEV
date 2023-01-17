<cfsetting showdebugoutput="no">
<cfparam name="attributes.keyword" default="">
<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
	SELECT
		EVENT_PLAN_ID,
		EVENT_PLAN_HEAD,
		MAIN_START_DATE,
		MAIN_FINISH_DATE,
        ANALYSE_ID
	FROM
		EVENT_PLAN
	WHERE
    	RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> AND
		<cfif len(attributes.keyword)>
			EVENT_PLAN_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		<cfelse>
			1 = 1		
		</cfif>
	ORDER BY
    	RECORD_DATE DESC
</cfquery>
<cfquery name="GET_ANALYSISES" datasource="#DSN#">
	SELECT ANALYSIS_ID, ANALYSIS_HEAD FROM MEMBER_ANALYSIS
</cfquery>
<cf_box title="Ziyaret Planları" body_style="overflow-y:scroll;height:100px;">
	<table cellspacing="0" cellpadding="0" border="0" align="center" style="width:98%">
  		<tr class="color-border">
			<td class="color-row">
				<table cellspacing="1" cellpadding="2" border="0" style="width:100%">
	  				<tr class="color-header" style="height:22px;">		
						<td class="form-title" style="width:30px;"><cf_get_lang_main no='75.No'></td>
						<td class="form-title">Plan Adı</td>
	  				</tr>
	  				<cfif get_event_plan.recordcount>
	  					<cfoutput query="get_event_plan">
                        	<cfif len(analyse_id)>	
                                <cfquery name="GET_ANALYSIS" dbtype="query">
                                    SELECT * FROM GET_ANALYSISES WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#analyse_id#">
                                </cfquery>
                            </cfif>
	  						<tr class="color-row" style="height:20px;">
								<td style="width:30px;">#currentrow#</td>
								<td>
									<input type="hidden" name="event_plan_head_#currentrow#" id="event_plan_head_#currentrow#" value="#event_plan_head#">
                                   	<cfif len(analyse_id)>
										<a href="javascript://" onClick="add_event_plan_div('#currentrow#','#DateFormat(main_start_date,'dd/mm/yyyy')#','#DateFormat(main_finish_date,'dd/mm/yyyy')#','#get_analysis.analysis_id#','#get_analysis.analysis_head#');" class="tableyazi">#event_plan_head#</a>
                                    <cfelse>
										<a href="javascript://" onClick="add_event_plan_div('#currentrow#','#DateFormat(main_start_date,'dd/mm/yyyy')#','#DateFormat(main_finish_date,'dd/mm/yyyy')#','','');" class="tableyazi">#event_plan_head#</a>                                    
                                    </cfif>
								</td>
	  						</tr>		
	  					</cfoutput>
	  				<cfelse>
	  					<tr class="color-row" style="height:30px;">
							<td colspan="3"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
	  					</tr>
	  				</cfif>
				</table>
   			</td>
  		</tr>
	</table>
</cf_box> 

