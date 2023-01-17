<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.position_code" default="#session.ep.position_code#">
<cfparam name="attributes.employee_name" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.ANALYSIS_ID" default="">
<cfparam name="attributes.zone_director" default="">
<cfparam name="attributes.visit_cat" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.is_plan" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.visit_emps" default="">
<cfparam name="attributes.visit_type" default="">
<cfparam name="attributes.company_type" default="">
<cfparam name="attributes.visit_stage" default="">
<cfparam name="attributes.is_plan" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.expense_item" default="">
<cfparam name="attributes.visit_expense_start" default="">
<cfparam name="attributes.visit_expense_finish" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.city_name" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.county_name" default="">
<cfparam name="attributes.money" default="">
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
	<cfquery name="GET_SALES_ZONES" datasource="#dsn#">
		SELECT
			SZ_ID,
			SZ_NAME,
			SZ_HIERARCHY
		FROM
			SALES_ZONES
		WHERE
			<cfloop query="GET_HIERARCHIES">
				<cfif get_hierarchies.currentrow gt 1>OR</cfif> SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'
			</cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_sales_zones.recordcount = 0>
</cfif>
<!--- <cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD,
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND 
		EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND 
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID  IS NULL AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# 
	ORDER BY 
		BRANCH.BRANCH_NAME
</cfquery> --->
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
	ORDER BY 
		BRANCH_NAME
</cfquery>
<!--- <cfif len(attributes.form_submitted)> --->
	<!--- <cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
			SELECT
			DISTINCT
				EVENT_PLAN_ROW.EVENT_PLAN_ID,
				EVENT_PLAN_ROW.WARNING_ID,
				EVENT_PLAN_ROW.START_DATE,
				EVENT_PLAN_ROW.FINISH_DATE,
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
				EVENT_PLAN_ROW.EXECUTE_STARTDATE,
				EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
				EVENT_PLAN_ROW.VISIT_STAGE,
				EVENT_PLAN_ROW.RESULT_RECORD_EMP,
				COMPANY.FULLNAME,
				COMPANY.COMPANY_ID,
				COMPANY_PARTNER.COMPANY_PARTNER_NAME,
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
				COMPANY_PARTNER.PARTNER_ID,
				SETUP_VISIT_TYPES.VISIT_TYPE
			FROM
				EVENT_PLAN_ROW,
				COMPANY,
				COMPANY_PARTNER,
				SETUP_VISIT_TYPES,
				COMPANY_BRANCH_RELATED,
				BRANCH
			WHERE 
				<cfif len(attributes.company_name) and len(attributes.company_id)>COMPANY.COMPANY_ID = #attributes.company_id# AND</cfif>
				<cfif len(attributes.start_date)>EVENT_PLAN_ROW.START_DATE >= #attributes.start_date# AND</cfif>
				<cfif len(attributes.finish_date)>EVENT_PLAN_ROW.START_DATE < #DATEADD("d", 1, attributes.finish_date)# AND</cfif>
				<cfif len(attributes.visit_cat)>EVENT_PLAN_ROW.WARNING_ID = #attributes.visit_cat# AND</cfif>
				<cfif len(attributes.ims_code_name) and len(attributes.ims_code_id)>COMPANY.IMS_CODE_ID = #attributes.ims_code_id# AND</cfif>
				<cfif len(attributes.is_plan) and (attributes.is_plan eq 1)>EVENT_PLAN_ID IS NOT NULL AND<cfelseif len(attributes.is_plan) and (attributes.is_plan eq 2)>EVENT_PLAN_ID IS NULL AND</cfif>
				<cfif len(attributes.employee_name) and len(attributes.position_code)>EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN (SELECT EVENT_ROW_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_POS_ID = #attributes.position_code#) AND</cfif>				
					COMPANY.IMS_CODE_ID IN
					(
						SELECT
							SIMS.IMS_CODE_ID
						FROM
							SETUP_IMS_CODE SIMS,
							SALES_ZONES SZ,
							SALES_ZONES_TEAM SZT,
							SALES_ZONES_TEAM_IMS_CODE SZIMS,
							BRANCH BR
						WHERE
							SIMS.IMS_CODE_ID = SZIMS.IMS_ID
							AND SZIMS.TEAM_ID = SZT.TEAM_ID
							AND SZ.SZ_ID = SZT.SALES_ZONES
							AND BR.BRANCH_ID = SZ.RESPONSIBLE_BRANCH_ID
							<cfif len(attributes.zone_director)>AND BR.BRANCH_ID = #attributes.zone_director#</cfif>
					) AND
				COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
				COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
				COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
				EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
				COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
				SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID AND
				EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
				BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
			ORDER BY 
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
			DESC
	</cfquery> --->
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT
			BRANCH_NAME,
			BRANCH_ID
		FROM 
			BRANCH
		WHERE
			BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		ORDER BY 
			BRANCH_NAME
	</cfquery>
	<cfquery name="GET_MONEY" datasource="#DSN#">
		SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
	</cfquery>
	<cfquery name="GET_EXPENSE" datasource="#dsn2#">
		SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
	</cfquery>
	<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	<!--- 	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_TYPE = 0 ORDER BY COMPANYCAT
	 --->	SELECT DISTINCT	
			COMPANYCAT_ID,
			COMPANYCAT,
			COMPANYCAT_TYPE
		FROM
			GET_MY_COMPANYCAT
		WHERE
			EMPLOYEE_ID = #session.ep.userid# AND
			OUR_COMPANY_ID = #session.ep.company_id#
		ORDER BY
			COMPANYCAT
	</cfquery>
	<cfquery name="GET_CONSCAT" datasource="#DSN#">
		<!--- SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY HIERARCHY --->
		SELECT DISTINCT	
			CONSCAT_ID,
			CONSCAT,
			HIERARCHY
		FROM
			GET_MY_CONSUMERCAT
		WHERE
			EMPLOYEE_ID = #session.ep.userid# AND
			OUR_COMPANY_ID = #session.ep.company_id#
		ORDER BY
			HIERARCHY		
	</cfquery>
	
	<cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1>
		<cfset Company_Member = "">
	<cfset Consumer_Member = "">
	<cfif ListLen(attributes.company_type)>
		<cfset Number_=ListLen(attributes.company_type)>
		<cfloop from="1" to="#Number_#" index="n">
			<cfset CatList = listgetat(attributes.company_type,n,',')>
			<cfif listlen(CatList) and listfirst(CatList,'-') eq 1>
				<cfset Company_Member = listappend(Company_Member,ListLast(CatList,'-'))>
			<cfelseif listlen(CatList) and listfirst(CatList,'-') eq 2>
				<cfset Consumer_Member = listappend(Consumer_Member,ListLast(CatList,'-'))>
			</cfif>
		</cfloop>
		<cfset Company_Member = ListSort(Company_Member,'numeric','asc',',')>
		<cfset Consumer_Member = ListSort(Consumer_Member,'numeric','asc',',')>
	</cfif>
		
		<cfquery name="GET_VISIT_MAIN" datasource="#DSN#">
	
				SELECT DISTINCT
				
					EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID,
					EVENT_PLAN_ROW.EVENT_PLAN_ID,
					EVENT_PLAN_ROW.WARNING_ID,
					EVENT_PLAN_ROW.START_DATE,
					EVENT_PLAN_ROW.FINISH_DATE,
					EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
					EVENT_PLAN_ROW.EXECUTE_STARTDATE,
					EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
					EVENT_PLAN_ROW.VISIT_STAGE,
					EVENT_PLAN_ROW.RESULT_RECORD_EMP,
					COMPANY.FULLNAME FULLNAME,
					COMPANY.COMPANY_ID ,
					COMPANY.CITY CITY,
					COMPANY.COUNTY COUNTY,
					COMPANY.IMS_CODE_ID,
					EVENT_PLAN_ROW.WARNING_ID,
					COMPANY_PARTNER.COMPANY_PARTNER_NAME ,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME ,
					COMPANY_PARTNER.PARTNER_ID ,
					<!--- EVENT_CAT.EVENTCAT, --->
					SETUP_VISIT_TYPES.VISIT_TYPE,
					EVENT_PLAN_ROW.EXPENSE_ITEM,
					EVENT_PLAN_ROW.EXPENSE,
					EVENT_PLAN_ROW.MONEY_CURRENCY,
					EVENT_PLAN_ROW.RESULT_UPDATE_EMP,
					SETUP_VISIT_RESULT.VISIT_RESULT,
					SETUP_VISIT_RESULT.VISIT_RESULT_ID
				FROM
					EVENT_PLAN_ROW,
					COMPANY,
					COMPANY_PARTNER,
					SETUP_VISIT_TYPES,
					COMPANY_BRANCH_RELATED,
					SETUP_VISIT_RESULT,
					EVENT_PLAN_ROW_PARTICIPATION_POS
				WHERE 
					EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IS NOT NULL
					<cfif len(attributes.visit_cat)> AND EVENT_PLAN_ROW.WARNING_ID IN( #attributes.visit_cat#)</cfif>
					 <cfif len(attributes.company_name) and len(attributes.company_id)> AND COMPANY.COMPANY_ID IN( #attributes.company_id#) </cfif> 
					<cfif len(attributes.branch_id)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IN ( SELECT EVENT_PLAN_ID FROM EVENT_PLAN WHERE SALES_ZONES IN (#attributes.branch_id#))</cfif>
					<cfif len(attributes.ims_code_id)>AND COMPANY.IMS_CODE_ID IN (#attributes.ims_code_id#)</cfif>
					<cfif len(Company_Member)>AND COMPANY.COMPANYCAT_ID IN (#Company_Member#)</cfif>
					<cfif len(attributes.is_plan) and (attributes.is_plan eq 1)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NOT NULL<cfelseif len(attributes.is_plan) and (attributes.is_plan eq 2)>AND EVENT_PLAN_ROW.EVENT_PLAN_ID IS NULL</cfif>
					<cfif len(attributes.expense_item)>AND EVENT_PLAN_ROW.EXPENSE_ITEM = #attributes.expense_item#</cfif>
					<cfif len(attributes.start_date) and attributes.start_date neq 'NULL'>AND EVENT_PLAN_ROW.START_DATE >= #attributes.start_date#</cfif>
					<cfif len(attributes.finish_date) and attributes.finish_date neq 'NULL'>AND EVENT_PLAN_ROW.FINISH_DATE < #date_add("d", 1, attributes.finish_date)#</cfif>
					<cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID IN ( SELECT EVENT_ROW_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_POS_ID IN (#attributes.visit_emps#) )</cfif>
					<cfif len(attributes.visit_type)>AND EVENT_PLAN_ROW.WARNING_ID IN (#attributes.visit_type#)</cfif>
					<cfif len(attributes.visit_stage)>AND EVENT_PLAN_ROW.VISIT_STAGE IN (#attributes.visit_stage#)</cfif>
					<cfif len(attributes.visit_expense_start)>AND EVENT_PLAN_ROW.EXPENSE >= #attributes.visit_expense_start#</cfif>
					<cfif len(attributes.visit_expense_finish)>AND EVENT_PLAN_ROW.EXPENSE <= #attributes.visit_expense_finish#</cfif>
					<cfif len(attributes.money)>AND EVENT_PLAN_ROW.MONEY_CURRENCY = '#attributes.money#'</cfif>
					<cfif Len(attributes.city_name) and Len(attributes.city_id)>AND COMPANY.CITY = #attributes.city_id#</cfif>
					<cfif Len(attributes.county_name) and Len(attributes.county_id)>AND COMPANY.COUNTY = #attributes.county_id#</cfif>
					AND COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID 
					AND EVENT_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
					AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
					AND SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID
					AND SETUP_VISIT_RESULT.VISIT_RESULT_ID=EVENT_PLAN_ROW.VISIT_RESULT_ID
					<!--- AND EVENT_CAT.EVENTCAT_ID = EVENT_PLAN_ROW.WARNING_ID --->
					AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_ROW_ID=EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
					 <cfif len(attributes.visit_emps)>AND EVENT_PLAN_ROW_PARTICIPATION_POS.EVENT_POS_ID IN (#attributes.visit_emps#)</cfif> 
					ORDER BY 
				EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID
			DESC
			
		</cfquery>
		<cfquery name="GET_PLAN" datasource="#DSN#">
			SELECT EVENT_PLAN_HEAD,EVENT_PLAN_ID ,ANALYSE_ID FROM EVENT_PLAN
		
		</cfquery>
			<cfquery name="GET_VISIT" dbtype="query">
				SELECT
					GET_VISIT_MAIN.*,
					GET_PLAN.EVENT_PLAN_HEAD AS EVENT_PLAN_HEAD
				FROM
					GET_VISIT_MAIN,
					GET_PLAN
				WHERE
					GET_PLAN.EVENT_PLAN_ID = GET_VISIT_MAIN.EVENT_PLAN_ID
				UNION
				SELECT
					GET_VISIT_MAIN.*,
					'Plansız' AS EVENT_PLAN_HEAD
				FROM
					GET_VISIT_MAIN
				WHERE
					GET_VISIT_MAIN.EVENT_PLAN_ID IS NULL
			</cfquery>
	<cfparam name='attributes.totalrecords' default='#GET_VISIT.recordcount#'>
<cfelse>
	<cfparam name='attributes.totalrecords' default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam  name="attributes.branch_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box >
		<cfform name="search_asset" action="#request.self#?fuseaction=crm.list_event_plan_result" method="post">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<!-- sil -->
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.employee_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
				<div class="form-group">
					<input type="hidden" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfoutput>
							<input type="text" name="company_name"  value="#attributes.company_name#" placeholder="<cf_get_lang dictionary_id ='57457.Müşteri'>">
							<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
							<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=search_asset.company_id&field_comp_name=search_asset.company_name&is_crm_module=1&select_list=2,6');"></span>
						</cfoutput>
					</div>
				</div>
				<div class="form-group" id="item-start_date">
					<div class="input-group">                                  
						<input type="text" name="start_date" id="start_date"  autocomplete="off" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='34179.Planlanan Tarih'>">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<div class="input-group">                      
						<input type="text" name="finish_date" id="finish_date" autocomplete="off" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='51830.Gerçekleşen Tarih'>">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="is_plan" id="is_plan" style="width:60px;">
						<option value="" <cfif attributes.is_plan eq "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
						<option value="1" <cfif attributes.is_plan eq 1>selected</cfif>><cf_get_lang dictionary_id ='39771.Planlı'></option>
						<option value="2" <cfif attributes.is_plan eq 2>selected</cfif>><cf_get_lang dictionary_id ='39770.Plansız'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="branch_id" id="branch_id" >
						<cfoutput query="get_branch">
							<option value="#branch_id#" <cfif listfind(attributes.branch_id, branch_id,',')> selected</cfif>>#branch_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfsavecontent variable="text"><cf_get_lang dictionary_id='34030.Ziyaret Nedeni'></cfsavecontent>
					<cf_wrk_combo
						name="visit_cat"
						query_name="GET_VISIT_TYPES"
						option_name="visit_type"
						option_value="visit_type_id"
						value="#attributes.visit_cat#"
						option_text="#text#"
						width="170">
				</div>
				<div class="form-group">
					<div class="input-group">  
						<cfoutput>
							<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
							<input type="text" name="ims_code_name" style="width:150px;" value="#attributes.ims_code_name#" placeholder ="<cf_get_lang dictionary_id='58134.Micro Bölge Kodu'>">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&is_form_submitted=1&field_name=search_asset.ims_code_name&field_id=search_asset.ims_code_id');"></span>
						</cfoutput>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
</div>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang_main dictionary_id='62423.Ziyaret Sonuçları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1">
		<cf_grid_list>
			<thead>
				<tr>
				<th><cf_get_lang_main dictionary_id ='57487.No'></th>
				<th><cf_get_lang dictionary_id='41214.Plan'></th>
				<th><cf_get_lang dictionary_id='41033.Ziyaret Edilecek'></th>
				<th ><cf_get_lang dictionary_id='34030.Ziyaret Nedeni'></th>
				<th ><cf_get_lang dictionary_id='34179.Planlanan Tarih'></th>
				<th ><cf_get_lang dictionary_id='51830.Gerçekleşen Tarih'></th>
				<th ><cf_get_lang dictionary_id='39773.Ziyaret Eden'></th>
				<th ><cf_get_lang_main dictionary_id='58437.Sonuç'></th>
				<!-- sil -->
				<th width="20"><i class="fa fa-pencil-square-o title="<cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'>"></i></th>
					<th><i class="fa fa-question" title="<cf_get_lang dictionary_id ='57560.Analiz'>" alt="<cf_get_lang dictionary_id ='57560.Analiz'>"></i></th>
				</tr>
				<!-- sil -->
			</thead>
			<tbody>
				<cfif len(attributes.form_submitted)>	
					<cfif GET_VISIT.recordcount>
						<cfoutput query="GET_VISIT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr <!--- height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" --->>
								<td>#currentrow#</td>
								<td><cfif len(event_plan_id)>
									<cfquery name="GET_VISIT_analyse" datasource="#dsn#">
										SELECT EVENT_PLAN.EVENT_PLAN_HEAD, 
										EVENT_PLAN.ANALYSE_ID,
										MEMBER_ANALYSIS.ANALYSIS_ID
										FROM EVENT_PLAN ,
										MEMBER_ANALYSIS
										WHERE EVENT_PLAN_ID = #event_plan_id# and 
										MEMBER_ANALYSIS.ANALYSIS_ID =EVENT_PLAN.ANALYSE_ID 
									</cfquery><a href="#request.self#?fuseaction=sales.list_visit&event=upd&visit_id=#event_plan_id#" class="tableyazi">#GET_VISIT_analyse.event_plan_head#</a><cfelse><font color="##990000"><cf_get_lang no='278.Plansız'></font></cfif></td>
								<td> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_VISIT.COMPANY_ID#','list');" class="tableyazi">#fullname#</a> - #GET_VISIT.company_partner_name# #GET_VISIT.company_partner_surname#</td>
								<td>#visit_type#</td>
								<td>#dateformat(start_date,dateformat_style)# #timeformat(start_date,timeformat_style)# - #timeformat(finish_date,timeformat_style)#</td>
								<td>#dateformat(execute_startdate,dateformat_style)# #timeformat(execute_startdate,timeformat_style)# - #timeformat(execute_finishdate,timeformat_style)#</td>
								<td><!--- ><cfquery name="GET_POSIDS" datasource="#dsn#">
										SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = #event_plan_row_id#
								</cfquery><cfloop query="get_posids"> --->#get_emp_info(event_pos_id,1,0)#<!--- ,</cfloop> ---></td>
								<td nowrap>
									<cfif len(visit_stage)>
									<cfquery name="GET_STAGE" datasource="#dsn#">
										SELECT VISIT_RESULT FROM SETUP_VISIT_RESULT WHERE VISIT_RESULT_ID = #visit_result_id#
									</cfquery>#get_stage.visit_result#</cfif></td>
								<!-- sil -->
								<td width="20" style="text-align:center">
								<!--- <cfif event_plan_id eq ""> --->
									<!--- <cfif len(GET_VISIT_MAIN.result_record_emp)>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#','medium');"><img src="/images/time.gif" border="0"></a>
									<cfelse>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_form_upd_visit&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#','medium');"><img src="/images/time.gif" border="0"></a>
									</cfif>
								<cfelse> --->
									<cfif len(GET_VISIT.RESULT_UPDATE_EMP)>
										<font color="4AA02C" a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.event_plan_result&event=upd&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-pencil-square-o title="<cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'>"></i></a>	
									<cfelse>
										<font color="FF000" a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#');"><i class="fa fa-pencil-square-o title="<cf_get_lang dictionary_id ='58437.Ziyaret Sonucu'>"></i></a>	
									</cfif>
								<!--- </cfif> --->
								<td width="20">
									<cfif len(event_plan_id)>
									<cfif len(GET_VISIT_analyse.analyse_id)>
								<cfquery name="GET_ANALYSIS_RES" datasource="#dsn#">
									SELECT RESULT_ID,PARTNER_ID FROM MEMBER_ANALYSIS_RESULTS WHERE PARTNER_ID = #partner_id#
								</cfquery>
										<cfif GET_VISIT_analyse.recordcount>
											<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=member.popup_add_member_analysis_result&analysis_id=#GET_VISIT_analyse.analysis_id#&member_type=partner&action_type=MEMBER&partner_id=#partner_id#&partner=#company_id#');"><i class="fa fa-question" title="<cf_get_lang dictionary_id ='57560.Analiz'>" alt="<cf_get_lang dictionary_id ='57560.Analiz'>"></i></a>
												
									
										</cfif>
									</cfif>
								</cfif>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row">
							<td height="20" colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
						</tr> 
					</cfif>
					<cfelse>
					<tr class="color-row">
						<td height="20" colspan="10"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
			</tbody>
    	</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
			<cfif len(attributes.is_plan)>
			<cfset url_str = "#url_str#&is_plan=#attributes.is_plan#">
			</cfif>
			<cfset url_str = "#url_str#&position_code=#attributes.position_code#">
			<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
			<cfif len(attributes.company_id)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
			</cfif>
			<cfif len(attributes.company_name)>
			<cfset url_str = "#url_str#&company_name=#attributes.company_name#">
			</cfif>
			<cfif len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif len(attributes.zone_director)>
			<cfset url_str = "#url_str#&zone_director=#attributes.zone_director#">
			</cfif>
			<cfif len(attributes.visit_cat)>
			<cfset url_str = "#url_str#&visit_cat=#attributes.visit_cat#">
			</cfif>
			<cfif len(attributes.ims_code_id)>
			<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
			</cfif>
			<cfif len(attributes.ims_code_name)>
			<cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
			</cfif>
			<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="crm.list_event_plan_result#url_str#">
		</cfif>  
	</cf_box>
</div>
<!-- sil -->
<script type="text/javascript">
	function pencere_ac(selfield)
	{	
		openBOxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_asset.ims_code_name&field_id=search_asset.ims_code_id');
	}
	
</script>
