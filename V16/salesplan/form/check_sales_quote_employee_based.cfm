<cfparam name="attributes.quote_year" default='#session.ep.period_year#'>
<cfif not isdefined("attributes.is_submit")>
	<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
		SELECT 
			SZT.TEAM_ID,
			SZT.TEAM_NAME,
			SZT.SALES_ZONES,
			SZ.SZ_NAME,
			B.BRANCH_NAME,
			SZ.RESPONSIBLE_BRANCH_ID 
		FROM
			SALES_ZONES_TEAM SZT,
			SALES_ZONES SZ,
			BRANCH B
		WHERE
			B.BRANCH_ID = SZ.RESPONSIBLE_BRANCH_ID AND
			SZ.SZ_ID = SZT.SALES_ZONES
			<cfif isdefined("attributes.sales_zone_id")>
				AND SZ.SZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zone_id#">
			</cfif>
			<cfif not session.ep.ehesap>
				AND
				B.BRANCH_ID IN 
				(
                    SELECT
                        BRANCH_ID
                    FROM
                        EMPLOYEE_POSITION_BRANCHES
                    WHERE
                        POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
				)
			</cfif>
		ORDER BY SZ.SZ_NAME
	</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='41507.Satıcı Bazında Satış Hedefi'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
	<cfform name="form_basket" action="" method="post">
	<input type="hidden" name="is_submit" id="is_submit" value="1">
		<cf_box_elements>	
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57453.Şube'> / <cf_get_lang dictionary_id='58511.Takım'></label>
					<div class="col col-8 col-xs-12">
						<div>
							<select name="team_id" id="team_id">
								<cfoutput query="GET_SALES_ZONES_TEAM">
									<option value="#SALES_ZONES#-#team_id#-#RESPONSIBLE_BRANCH_ID#">#SZ_NAME# / #BRANCH_NAME# - #TEAM_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58472.Dönem'></label>
					<div class="col col-8 col-xs-12">
						<div>
							<select name="quote_year" id="quote_year" style="width:100px;">
								<cfoutput>
									<cfloop from="#session.ep.period_year#" to="#session.ep.period_year+10#" index="i">
										<option value="#i#" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='41590.Hedef Ver'></cfsavecontent>
			<cf_workcube_buttons type_format='1' is_upd='0' insert_info='#message#' insert_alert=''>
		</cf_box_footer>
	</cfform>	
</cf_box>
</div>
<cfelse>
	<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#dsn#">
		SELECT 
			SQ.SALES_QUOTE_ID,
			SQR.IMS_TEAM_ID
		FROM 
			SALES_QUOTES_GROUP SQ,
			SALES_QUOTES_GROUP_ROWS SQR
		WHERE
			SQR.EMPLOYEE_TEAM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.team_id,2,'-')#"> AND
			SQR.SALES_QUOTE_ID = SQ.SALES_QUOTE_ID AND
			SQ.QUOTE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="4"> AND
			SQ.QUOTE_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quote_year#"> AND
			SQ.SALES_ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.team_id,1,'-')#">
	</cfquery>
	<cfif GET_SALES_QUOTE_ZONE.recordcount>
		<cflocation url="#request.self#?fuseaction=salesplan.popup_upd_sales_quote_employee_based&SALES_QUOTE_ID=#GET_SALES_QUOTE_ZONE.SALES_QUOTE_ID#&branch_id=#listgetat(attributes.team_id,3,'-')#&employee_team_id=#listgetat(attributes.team_id,2,'-')#" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=salesplan.popup_add_sales_quote_employee_based&SALES_ZONE_ID=#listgetat(attributes.team_id,1,'-')#&branch_id=#listgetat(attributes.team_id,3,'-')#&quote_year=#attributes.quote_year#&employee_team_id=#listgetat(attributes.team_id,2,'-')#" addtoken="no">
	</cfif>
</cfif>
