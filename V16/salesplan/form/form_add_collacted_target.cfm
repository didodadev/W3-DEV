<cfparam name="attributes.is_submit" default="">
<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
	SELECT 
		SALES_ZONES_TEAM.LEADER_POSITION_CODE,
		SALES_ZONES_TEAM.TEAM_ID,
		SALES_ZONES.SZ_ID,
		SALES_ZONES_TEAM.TEAM_NAME,
		SALES_ZONES.SZ_NAME
	FROM 
		SALES_ZONES_TEAM,
		SALES_ZONES
	WHERE 
		SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES AND 
		SALES_ZONES_TEAM.LEADER_POSITION_CODE IS NOT NULL
	ORDER BY 
		SALES_ZONES_TEAM.TEAM_NAME
</cfquery>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH.BRANCH_NAME,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME ,
		EMPLOYEE_POSITIONS.POSITION_CODE
	FROM 
		EMPLOYEES,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH 
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND 
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr height="35" class="color-list">
          <td class="headbold">&nbsp;Toplu Satış Takımı Hedefi Verme</td>
        </tr>
        <tr class="color-row">
          <td valign="top" headers="40">
            <table border="0">
			  <cfif not len(attributes.is_submit)>
			  <form name="add_target" id="add_target" action="" method="post">
			  <input type="hidden" name="is_submit" id="is_submit" value="1">
			  <tr>
					<td><cf_get_lang_main no='1060.Dönem'> *</td>
					<td><select name="quote_year" id="quote_year" style="width:180px;">
					<cfloop from="#session.ep.period_year#" to="#session.ep.period_year+3#" index="i">
						<cfoutput><option value="#i#" <cfif year(now()) eq i>selected</cfif>>#i#</option></cfoutput>
					 </cfloop>
					</select></td>	
			   </tr>
			   <tr>
					<td></td>
					<td><cfsavecontent variable="message">Hedef Ver</cfsavecontent><cf_workcube_buttons is_upd='0' insert_info='#message#' insert_alert=''></td>
        	   </tr>
			</form>
			<cfelse>
			  <form name="add_target_plan" action="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.emptypopup_add_collacted_target" method="post">
			  <input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#attributes.quote_year#</cfoutput>">
			  <tr>
				<td><cf_get_lang_main no='1060.Dönem'></td>
				<td> : <cfoutput>#attributes.quote_year#</cfoutput>&nbsp;&nbsp;&nbsp;<cf_workcube_buttons is_upd='0' insert_alert=''></td>	
			  </tr>
			  <tr>
				<td></td>
				<td></td>
        	</tr>
			</table>
		  </td>
		</tr>
		<tr class="color-row" height="100%">
          <td valign="top" colspan="2">
			<table name="table1" id="table1" width="100%">
              <tr class="color-header">
			  	<td>No</td>
				<td>Şube</td>
				<td>Lider</td>
				<cfloop from="1" to="4" index="i">
					<td colspan="9" align="center"><cfoutput>#i#</cfoutput>. Çeyrek</td>
				</cfloop>
				<td colspan="9" align="center">Yıl Sonu Toplamı</td>
			  </tr>
			  <tr class="color-header">
			  	<td colspan="3" align="center">&nbsp;</td>
			  	<cfloop from="1" to="5" index="i">
					<td colspan="3" align="center">Karlılık</td>
					<td colspan="3" align="center">IMS</td>
					<td colspan="3" align="center">Tahsilat</td>
				</cfloop>
			  </tr>
			  <tr class="color-header">
			  	<td colspan="3">&nbsp;</td>
				<cfloop from="1" to="15" index="k">
				<td align="center" width="50">Hedef</td>
				<td align="center" width="50">Gerçekleşen</td>
				<td align="center" width="50">Oran</td>
				</cfloop>
			  </tr>
			  <cfquery name="GET_PERIOD" datasource="#dsn#">
			  	SELECT QUARTER_PLAN_ID FROM SALES_QUARTER_PLAN WHERE PERIOD = #attributes.quote_year#
			  </cfquery>
			  <cfif get_period.recordcount>
			  	<input type="hidden" name="plan_id" id="plan_id" value="<cfoutput>#GET_PERIOD.QUARTER_PLAN_ID#</cfoutput>">
			  	<input type="hidden" name="is_upd" id="is_upd" value="1">
				<cfquery name="GET_PERIOD_ROW" datasource="#dsn#">
					SELECT 
    	                PLAN_ROW_ID, 
                        PLAN_YEAR, 
                        PLAN_ID, 
                        TEAM_ID, 
                        PERIOD_ID, 
                        TYPE_ID, 
                        CATEGORY_ID, 
                        ROW_VALUE 
                    FROM 
	                    SALES_QUARTER_PLAN_ROW 
                    WHERE 
                    	PLAN_YEAR = #attributes.quote_year#
				</cfquery>
			  </cfif>
				  <cfoutput query="get_sales_zones_team">
				  <tr height="20" class="color-list">
					<td width="30">#currentrow#</td>
					<cfif len(leader_position_code)>
						<cfquery name="GET_NAME" dbtype="query">
							SELECT * FROM GET_BRANCH WHERE POSITION_CODE = #leader_position_code#
						</cfquery>
						<td nowrap="nowrap">#get_name.branch_name#</td>
						<td nowrap="nowrap">#get_name.employee_name# #get_name.employee_surname#</td>
					<cfelse>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</cfif>
					<cfloop from="1" to="5" index="i">
						<cfset birincideger = i>
						<cfloop from="1" to="3" index="k">
							<cfset ikincideger = k>
							<cfloop from="1" to="3" index="s">
								<cfset ucuncudeger = s>
								<cfif get_period.recordcount>
									<cfquery name="GETROW" dbtype="query">
										SELECT ROW_VALUE FROM GET_PERIOD_ROW WHERE PLAN_ID = #get_period.quarter_plan_id# AND TEAM_ID = #get_sales_zones_team.team_id# AND PERIOD_ID = #birincideger# AND TYPE_ID = #ikincideger# AND CATEGORY_ID = #ucuncudeger#
									</cfquery>
									<td align="center"><input type="text" name="quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#" id="quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#" onkeyup="return(FormatCurrency(this,event,2));" class="box" value="#tlformat(getrow.row_value)#" style="width:50;"></td>
								<cfelse>
									<td align="center"><input type="text" name="quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#" id="quate_target_#get_sales_zones_team.team_id#_#birincideger#_#ikincideger#_#ucuncudeger#" value="" onkeyup="return(FormatCurrency(this,event,2));" class="box" style="width:50;"></td>
								</cfif>
							</cfloop>
						</cfloop>
					</cfloop>
				  </tr>
				  </cfoutput>
			  </form>
            </table>
			</cfif>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
