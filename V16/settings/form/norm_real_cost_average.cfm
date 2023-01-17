<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#dateformat(now(),'MM')#">

<cfquery name="get_branches" datasource="#DSN#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = #SESSION.EP.POSITION_CODE#
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY
</cfquery>
<cfsavecontent  variable="title"><cf_get_lang dictionary_id='44820.Norm Kadro Toplam Maliyet Aktarımı'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title#">
		<cfform name="export_form"  action="#request.self#?fuseaction=settings.emptypopup_norm_real_cost_average">
			<cf_box_elements>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group " id="item-sal_mon">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<select name="sal_mon" id="sal_mon">
								<cfloop from="1" to="12" index="i">
								<cfoutput><option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group " id="item-sal_year">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58455.Yıl'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
							<input name="sal_year" id="sal_year" type="text" value="<cfoutput>#attributes.sal_year#</cfoutput>" style="width:45px;">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-related_company">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='38955.İlgili Şirket'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
								<select name="related_company" id="related_company">
									<option value=""><cf_get_lang dictionary_id='38955.İlgili Şirket'></option>
									<cfoutput query="get_branches">
											<option value="#related_company#">#related_company#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
			<cf_box_footer>	
				<cf_workcube_buttons is_upd='0' >
			</cf_box_footer>	
		</cfform>
	</cf_box>
</div>