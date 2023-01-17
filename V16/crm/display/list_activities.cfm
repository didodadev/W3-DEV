<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.zone_director" default="">
<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfparam name="attributes.employee_name" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(date_add('d',7,now()),dateformat_style)#">
<cfparam name="attributes.is_submitted" default='1'>
<cfparam name="attributes.is_active" default="1">
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="GET_HIERARCHIES" datasource="#dsn#">
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ,
		SALES_ZONE_GROUP SZG
	WHERE
		SZG.SZ_ID = SZ.SZ_ID AND
		SZG.POSITION_CODE = #session.ep.position_code#
	UNION
	SELECT
		SZ.SZ_HIERARCHY
	FROM
		SALES_ZONES SZ
	WHERE
		SZ.RESPONSIBLE_POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_hierarchies.recordcount>
	<!--- satis bolgelerine ait yetki varsa (bolge yonetici veya satis grubu) satis bolgelerine hiyerarsi ile bakmali --->
	<cfquery name="GET_SALES_ZONES" datasource="#dsn#">
		SELECT
			SZ_ID,
			SZ_NAME,
			SZ_HIERARCHY
		FROM
			SALES_ZONES
		WHERE
			<cfloop query="GET_HIERARCHIES"><cfif get_hierarchies.currentrow gt 1>OR</cfif> SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'</cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_sales_zones.recordcount = 0>
</cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		ORDER BY BRANCH_NAME
</cfquery>
<cfif len(attributes.is_submitted)>
	<cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
		SELECT 
			ACTIVITY_PLAN.MAIN_START_DATE,
			ACTIVITY_PLAN.MAIN_FINISH_DATE,
			ACTIVITY_PLAN.RECORD_EMP,
			ACTIVITY_PLAN.SALES_ZONES,
			ACTIVITY_PLAN.EVENT_PLAN_HEAD,
			ACTIVITY_PLAN.EVENT_PLAN_ID,
			ACTIVITY_PLAN.EVENT_STATUS,
			ACTIVITY_PLAN.ANALYSE_ID,
			ACTIVITY_PLAN.CAMPAIGN_ID,
			ACTIVITY_PLAN.SALES_ZONES_ID,
			ACTIVITY_PLAN.EST_LIMIT,
			ACTIVITY_PLAN.IMS_CODE_ID,
			PROCESS_TYPE_ROWS.STAGE,
			ACTIVITY_PLAN.MONEY_CURRENCY,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
		FROM
			ACTIVITY_PLAN,
			PROCESS_TYPE_ROWS,
			EMPLOYEES
		WHERE
			EMPLOYEES.EMPLOYEE_ID = ACTIVITY_PLAN.RECORD_EMP AND
			<cfif len(attributes.employee_name) and len(attributes.employee_id)>ACTIVITY_PLAN.RECORD_EMP = #attributes.employee_id# AND</cfif>
			<cfif isdefined("event_list") and len(event_list)>ACTIVITY_PLAN.EVENT_PLAN_ID IN (#event_list#) AND<cfelseif isdefined("event_list") and not len(event_list)>EVENT_PLAN.EVENT_PLAN_ID IS NULL AND</cfif>
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID = ACTIVITY_PLAN.EVENT_STATUS
			<cfif len(attributes.keyword)>AND ACTIVITY_PLAN.EVENT_PLAN_HEAD LIKE '%#attributes.keyword#%'</cfif>
			<cfif len(attributes.zone_director)>
				AND ACTIVITY_PLAN.SALES_ZONES = #attributes.zone_director#
			<cfelse>
				<cfif get_branch.recordcount>
					AND ACTIVITY_PLAN.SALES_ZONES IN (#valuelist(get_branch.branch_id, ',')#)
				<cfelse>
					AND ACTIVITY_PLAN.SALES_ZONES IN (0)
				</cfif>
			</cfif>
			<cfif get_sales_zones.recordcount><!--- sadece satis bolgelerine ait yetki varsa satis bolgelerinden hareketle IMS bakmali --->
				AND ACTIVITY_PLAN.EVENT_PLAN_ID IN
				(
					SELECT 
						ACTIVITY_PLAN.EVENT_PLAN_ID
					FROM
						COMPANY,
						EVENT_PLAN_ROW
					WHERE
						COMPANY.COMPANY_ID = EVENT_PLAN_ROW.COMPANY_ID AND
						COMPANY.IMS_CODE_ID IN
						(
						SELECT
							SIMS.IMS_CODE_ID
						FROM
							SETUP_IMS_CODE SIMS,
							SALES_ZONES SZ,
							SALES_ZONES_TEAM SZT,
							SALES_ZONES_TEAM_IMS_CODE SZIMS
						WHERE
							SIMS.IMS_CODE_ID = SZIMS.IMS_ID
							AND SZIMS.TEAM_ID = SZT.TEAM_ID
							AND SZ.SZ_ID = SZT.SALES_ZONES
							AND SZ.SZ_ID IN (#valuelist(GET_SALES_ZONES.SZ_ID)#)
						)
				)
			</cfif>
			<cfif len(attributes.start_date)>AND ACTIVITY_PLAN.MAIN_START_DATE >= #attributes.start_date#</cfif>
			<cfif len(attributes.finish_date)>AND ACTIVITY_PLAN.MAIN_FINISH_DATE <= #attributes.finish_date#</cfif>
			<cfif len(attributes.is_active)>AND ACTIVITY_PLAN.IS_ACTIVE = #attributes.is_active#</cfif>
		ORDER BY
			ACTIVITY_PLAN.EVENT_PLAN_ID
		DESC
	</cfquery>
	<cfparam name='attributes.totalrecords' default='#get_event_plan.recordcount#'>
<cfelse>
	<cfparam name='attributes.totalrecords' default='0'>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_asset" action="#request.self#?fuseaction=crm.list_activities" method="post">
            <cf_box_search plus="0">
            	<input type="hidden" name="form_submitted" id="form_submitted" value="1">

                <div class="form-group" id="filter">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
                </div>
				<div class="form-group" id="dates">
					<div>
						<div class="input-group">
							<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Lütfen Tarih giriniz',58503)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
						</div>
					</div>
					<div>
						<div class="input-group">
							<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#getLang('','Başlama Tarihi',57655)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>    
				</div>
				<div class="form-group" id="status">
					<select name="is_active" id="is_active">
						<option value="1"<cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					  	<option value="" <cfif attributes.is_active eq ''>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
                <div class="form-group small" id="rows">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#"  maxlength="3">
                </div> 
                <div class="form-group" id="search">
                    <cf_wrk_search_button button_type="4">
                </div> 
                <div class="form-group" id="newact">    
                    <a href="<cfoutput>#request.self#?fuseaction=crm.form_add_activity</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="branch">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="zone_director" id="zone_director">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branch">
									<option value="#branch_id#" <cfif attributes.zone_director eq branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
							  </select>
                        </div>
                    </div>
                </div>
                <div class="col col-2 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="plannedby">
                        <label class="col col-12"><cf_get_lang dictionary_id='51960.Planlayan'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfoutput>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_name) and len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="text" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_asset.employee_id&field_name=search_asset.employee_name&select_list=1');"></span>
								</cfoutput>
							</div>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail> 
        </cfform>
    </cf_box>

	<cfsavecontent variable="title"><cf_get_lang dictionary_id='51836.Etkinlik Planları'></cfsavecontent>
	<cf_box title="#title#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='51720.Plan'></th>
					<th width="80"><cf_get_lang dictionary_id='51837.Katılım Sayısı'></th>
					<th width="150"><cf_get_lang dictionary_id='57742.Tarih'></th> 
					<th width="200"><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="130"><cf_get_lang dictionary_id='51774.Etkinlik Formu'></th>
					<th width="120"><cf_get_lang dictionary_id='51960.Planlayan'></th>
					<th width="90" style="text-align:right;"><cf_get_lang dictionary_id='51775.Tahmini Gider'></th>
					<th width="30" class="header_icn_none"></th>
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.is_submitted)>
					<cfif get_event_plan.recordcount>
						<cfoutput query="get_event_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							  <td>#currentrow#</td>
							  <td><a href="#request.self#?fuseaction=crm.form_upd_activity&visit_id=#event_plan_id#" class="tableyazi">#event_plan_head#</a></td>
							  <td align="center"><cfif len(event_plan_id)>#cfquery('SELECT EVENT_PLAN_ROW_ID FROM ACTIVITY_PLAN_ROW WHERE EVENT_PLAN_ID = #event_plan_id#','#dsn#','').recordcount#</cfif></td>
							  <td>#dateformat(main_start_date,dateformat_style)# - #dateformat(main_finish_date,dateformat_style)#</td>
							  <td><cfif len(sales_zones)>#cfquery('SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #sales_zones#','#dsn#','').branch_name#</cfif></td>
							  <td><cfif len(analyse_id)>
								<cfquery name="GET_ANALYSE" datasource="#dsn#">
									SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #analyse_id# 
								</cfquery><a href="#request.self#?fuseaction=member.analysis&analysis_id=#analyse_id#" class="tableyazi">#get_analyse.analysis_head#</a></cfif></td>
							  <td>#employee_name# #employee_surname#</td>
							  <td style="text-align:right;">#tlformat(est_limit)# #money_currency#</td>
								<!-- sil -->
							  <td width="15"><a href="#request.self#?fuseaction=crm.form_upd_activity&visit_id=#event_plan_id#"><i class="fa fa-pencil"></i></a></td>
							</tr>
					   </cfoutput>
				   <cfelse>
					  <tr>
						<td colspan="9"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</td>
					  </tr>
				  </cfif>
			  <cfelse>
				  <tr class="color-row">
					<td height="20" colspan="9"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
				  </tr>
			</cfif>
		</tbody>
		</cf_grid_list>
	</cf_box>
</div

<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.keyword)>
	  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.zone_director)>
	  <cfset url_str = "#url_str#&zone_director=#attributes.zone_director#">
	</cfif>
	<cfif len(attributes.start_date)>
	  <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
	<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	<cfif len(attributes.finish_date)>
	  <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.is_submitted)>
	  <cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
	<cfif len(attributes.is_active)>
	  <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
	</cfif>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages 
	  		page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="crm.list_visit#url_str#"></td>
      <td  style="text-align:right;"><cf_get_lang dictionary_id='57540.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
<cfelse>
<br/>
</cfif>
<!-- sil -->
