<style>
	.ajax_list {border-bottom: none;}
</style>
<cfsetting showdebugoutput="no">
<cfparam name="attributes.month" default="#month(now())#">
<cfparam name="attributes.period" default="#year(now())#">
<cfset query_first = createDateTime(attributes.period,attributes.month,1,0,0,0)>
<cfset query_last = createDateTime(attributes.period,attributes.month,DaysinMonth(query_first),23,59,59)>

<cfquery name="total_time_cost_cat" datasource="#dsn#">
	SELECT
		TCC.TIME_COST_CAT,
		ISNULL(TCC.COLOUR,'000000') AS COLOUR,
		SUM(TC.EXPENSED_MINUTE) AS TOTAL_MIN
	FROM
		TIME_COST TC
		LEFT JOIN TIME_COST_CAT TCC ON TC.TIME_COST_CAT_ID = TCC.TIME_COST_CAT_ID
	WHERE
		TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#query_first#">
		AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#query_last#">
	GROUP BY
		TCC.TIME_COST_CAT,
		TCC.COLOUR
	ORDER BY
		TCC.TIME_COST_CAT
</cfquery>

<cfquery name="total_time_cost_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE AS TIME_COST_STAGE,
		SUM(TC.EXPENSED_MINUTE) AS TOTAL_MIN,
		PTR.PROCESS_ROW_ID
	FROM
		TIME_COST TC
		LEFT JOIN PROCESS_TYPE_ROWS PTR ON TC.TIME_COST_STAGE = PTR.PROCESS_ROW_ID
	WHERE
		TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#query_first#">
		AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#query_last#">
	GROUP BY
		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	ORDER BY
		PTR.PROCESS_ROW_ID
</cfquery>
<div id="body_total">
	<cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform action="#request.self#?fuseaction=myhome.popup_time_cost_total" method="post" name="form_time_cost">
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-4">
				<select name="month" id="month">
					<cfloop from="1" to="12" index="j">
						<option value="<cfoutput>#j#</cfoutput>"<cfif isdefined('attributes.month') and attributes.month eq j>selected</cfif>><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option>
					</cfloop>
				</select>
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-4">
				<select name="period" id="period">
					<cfloop from="#year(now())-1#" to="#year(now())+2#" index="j">
						<option value="<cfoutput>#j#</cfoutput>" <cfif isdefined('attributes.period') and attributes.period eq j>selected</cfif>><cfoutput>#j#</cfoutput></option>
					</cfloop>
				</select>
			</div>
			<div class="form-group col col-2 col-md-4 col-sm-4 col-xs-2">
				<cf_wrk_search_button button_type="4" id="wrk_search_button" name="wrk_search_button" search_function="list_total()">
			</div>
		</cfform>
	</div>
	</cf_box_elements>
	<cf_grid_list>
		<thead>
			<cfif total_time_cost_cat.recordcount>
				<cfoutput query="total_time_cost_cat">
					<tr>
						<th>#time_cost_cat#</th>
						<th class="txtbold" style="text-align:right;"><font color="#colour#">#tlformat(total_min/60,2)#</font></th>
					</tr>
				</cfoutput>
				<cfquery name="get_total_cat" dbtype="query">
					SELECT SUM(TOTAL_MIN) AS ALL_TOTAL FROM total_time_cost_cat
				</cfquery>
				<tr style="border-bottom:solid 1px;">
					<td class="txtbold">Toplam</td>
					<td class="txtbold" style="text-align:right;"><cfoutput>#tlformat(get_total_cat.all_total/60,2)#</cfoutput></td>
				</tr>
			</cfif>
		</thead>
		<tbody>
			<cfif total_time_cost_stage.recordcount>
				<cfoutput query="total_time_cost_stage">
					<tr>
						<td>#time_cost_stage#</td>
						<td class="txtbold" style="text-align:right;">#tlformat(total_min/60,2)#</td>
					</tr>
				</cfoutput>
				<cfquery name="get_total_stage" dbtype="query">
					SELECT SUM(TOTAL_MIN) AS ALL_TOTAL FROM total_time_cost_stage
				</cfquery>
				<tr>
					<td class="txtbold">Toplam</td>
					<td class="txtbold" style="text-align:right;"><cfoutput>#tlformat(get_total_stage.all_total/60,2)#</cfoutput></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif total_time_cost_cat.recordcount eq 0>
		<div class="ui-info-bottom">
			<p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
		</div>
	</cfif>
</div>
<script type="text/javascript">
function list_total()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=myhome.popup_time_cost_total</cfoutput>&month='+document.getElementById('month').value+'&period='+document.getElementById('period').value,'body_total',1);
}
</script>