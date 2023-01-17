<cfparam name="attributes.quote_year" default="#session.ep.period_year#">
<cfset list_target = "#getlang('','IMS Hedefi Ekle',829)# ,#getlang('','Karlılık Hedefi Ekle',828)#,#getlang('','Ciro Hedefi Ekle',827)#,#getlang('','Tahsilat Hedefi Ekle',826)#">
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
		AND SZ.SZ_ID = #attributes.sales_zone_id#
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
                POSITION_CODE = #session.ep.position_code#
		)
		</cfif>
	ORDER BY
		SZ.SZ_NAME
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfsavecontent variable="head"><cf_get_lang dictionary_id='41612.Satış Takımları Hedefleri'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
	<form name="form_ims_target" id="form_ims_target" action="" method="post">
	<input type="hidden" name="is_submit" id="is_submit" value="1">
		<cf_box_elements>						
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57453.Şube'> / <cf_get_lang dictionary_id='58511.Takım'> *</label>
					<div class="col col-8 col-xs-12">
						<div>
							<select name="team_id" id="team_id" style="width:300px">
								<cfoutput query="get_sales_zones_team">
									<option value="#sales_zones#-#team_id#-#responsible_branch_id#">#sz_name# / #branch_name# - #team_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id ='41613.Hedef Tipi'> *</label>
					<div class="col col-8 col-xs-12">
						<div>
							<select name="target_type" id="target_type" style="width:100px">
								<cfoutput>
									<cfloop from="1" to="#listlen(list_target)#" index="i">
										<option value="#i#">#Listgetat(list_target,i)#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58472.Dönem'> *</label>
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
			<cfsavecontent variable="message"><cf_get_lang dictionary_id ='41590.Hedef Ver'></cfsavecontent>
			<cf_workcube_buttons type_format='1' is_upd='0' insert_info='#message#' insert_alert=''>
		</cf_box_footer>
	</form>		
</cf_box>
</div>	
<cfelse>
	<cfquery name="GET_SALES_QUOTE_ZONE" datasource="#DSN#">
		SELECT 
			SQ.SALES_QUOTE_ID,
			SQR.IMS_TEAM_ID
		FROM 
			SALES_QUOTES_GROUP SQ,
			SALES_QUOTES_GROUP_ROWS SQR
		WHERE
			SQR.SALES_QUOTE_ID = SQ.SALES_QUOTE_ID AND
			SQ.QUOTE_TYPE = 3 AND
			SQ.TARGET_TYPE = #attributes.target_type# AND			
			SQ.QUOTE_YEAR = #attributes.quote_year# AND
			SQR.IMS_TEAM_ID = #listgetat(attributes.team_id,2,'-')# AND
			SQ.SALES_ZONE_ID = #listgetat(attributes.team_id,1,'-')#
	</cfquery>
	
	<cfif get_sales_quote_zone.recordcount>
		<cflocation url="#request.self#?fuseaction=salesplan.popup_upd_sales_quote_ims_based&sales_quote_id=#get_sales_quote_zone.sales_quote_id#&branch_id=#listgetat(attributes.team_id,3,'-')#&ims_team_id=#listgetat(attributes.team_id,2,'-')#&target_type=#attributes.target_type#" addtoken="no">
	<cfelse>
		<cflocation url="#request.self#?fuseaction=salesplan.popup_add_sales_quote_ims_based&sales_zone_id=#listgetat(attributes.team_id,1,'-')#&branch_id=#listgetat(attributes.team_id,3,'-')#&quote_year=#attributes.quote_year#&ims_team_id=#listgetat(attributes.team_id,2,'-')#&target_type=#attributes.target_type#" addtoken="no">
	</cfif>
</cfif>
