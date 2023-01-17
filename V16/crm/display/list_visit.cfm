<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(date_add('d',7,now()),dateformat_style)#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_id" default="">
<cfparam name="attributes.zone_director" default="">
<cfparam name="attributes.is_active" default='1'>
<cfparam name="attributes.employee_name" default='#session.ep.name# #session.ep.surname#'>
<cfparam name="attributes.search_emp_id" default='#session.ep.userid#'>
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
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
		  <cfloop query="get_hierarchies">
			<cfif get_hierarchies.currentrow gt 1> OR </cfif>SALES_ZONES.SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy#%'
		  </cfloop>
		ORDER BY
			SZ_HIERARCHY
	</cfquery>
<cfelse>
	<cfset get_sales_zones.recordcount = 0>
</cfif>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
        EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL
	ORDER BY 
		BRANCH.BRANCH_NAME
</cfquery>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
		SELECT 
			EVENT_PLAN.MAIN_START_DATE,
			EVENT_PLAN.MAIN_FINISH_DATE,
			EVENT_PLAN.SALES_ZONES,
			EVENT_PLAN.EVENT_PLAN_HEAD,
			EVENT_PLAN.EVENT_PLAN_ID,
			EVENT_PLAN.EVENT_STATUS,
			EVENT_PLAN.RECORD_EMP,
			EVENT_PLAN.ANALYSE_ID,
			EVENT_PLAN.CAMPAIGN_ID,
			EVENT_PLAN.SALES_ZONES_ID,
			EVENT_PLAN.EST_LIMIT,
			EVENT_PLAN.IMS_CODE_ID,
			PROCESS_TYPE_ROWS.STAGE,
			EVENT_PLAN.MONEY_CURRENCY
		FROM
			EVENT_PLAN,
			PROCESS_TYPE_ROWS
		WHERE
			<cfif len(attributes.employee_name) and len(attributes.search_emp_id)>EVENT_PLAN.RECORD_EMP = #attributes.search_emp_id# AND</cfif>
			<cfif isdefined("event_list") and len(event_list)>EVENT_PLAN.EVENT_PLAN_ID IN (#event_list#) AND<cfelseif isdefined("event_list") and not len(event_list)>EVENT_PLAN.EVENT_PLAN_ID IS NULL AND</cfif>
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID = EVENT_PLAN.EVENT_STATUS
			<cfif len(attributes.keyword)>AND EVENT_PLAN.EVENT_PLAN_HEAD LIKE '%#attributes.keyword#%'</cfif>
			<cfif len(attributes.zone_director)>
				AND EVENT_PLAN.SALES_ZONES = #attributes.zone_director#
			<cfelse>
				<cfif get_branch.recordcount>
					AND EVENT_PLAN.SALES_ZONES IN (#valuelist(get_branch.branch_id, ',')#)
				<cfelse>
					AND EVENT_PLAN.SALES_ZONES IN (0)
				</cfif>
			</cfif>
			<cfif get_sales_zones.recordcount><!--- sadece satis bolgelerine ait yetki varsa satis bolgelerinden hareketle IMS bakmali --->
				AND EVENT_PLAN.EVENT_PLAN_ID IN
				(
					SELECT
						DISTINCT
						EPR.EVENT_PLAN_ID
					FROM
						COMPANY C,
						EVENT_PLAN_ROW EPR,
						SETUP_IMS_CODE SIMS,
						SALES_ZONES SZ,
						SALES_ZONES_TEAM SZT,
						SALES_ZONES_TEAM_IMS_CODE SZIMS
					WHERE
						SIMS.IMS_CODE_ID = SZIMS.IMS_ID AND
						SZIMS.TEAM_ID = SZT.TEAM_ID AND
						SZ.SZ_ID = SZT.SALES_ZONES AND 
						C.IMS_CODE_ID = SZIMS.IMS_ID AND 
						EPR.COMPANY_ID = C.COMPANY_ID AND
						SZ.SZ_ID IN (#valuelist(get_sales_zones.sz_id)#)
				)
			</cfif>
			<cfif len(attributes.start_date)>AND EVENT_PLAN.MAIN_START_DATE >= #attributes.start_date#</cfif>
			<cfif len(attributes.finish_date)>AND EVENT_PLAN.MAIN_FINISH_DATE <= #attributes.finish_date#</cfif>
			<cfif len(attributes.is_active)>AND EVENT_PLAN.IS_ACTIVE = #attributes.is_active#</cfif>
		ORDER BY
			EVENT_PLAN.MAIN_START_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_event_plan.recordcount = 0>
</cfif>
<cfparam name='attributes.totalrecords' default='#get_event_plan.recordcount#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box>
	<cfform name="list_visit" method="post" action="#request.self#?fuseaction=crm.list_visit">
	<input type="hidden" name="is_submitted" id="is_submitted" value="1">
	<cf_box_search>
		<div class="form-group">
			<cfinput type="text" placeholder="#getlang('','Filtre','57460')#" name="keyword" value="#attributes.keyword#" maxlength="255">
        </div>
		<div class="form-group">
		    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz !'></cfsavecontent>
				<div class="input-group">
				<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
				<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
			</div>
        </div>
		<div class="form-group">
			<div class="input-group">
			<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
				<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date">
			</div>
        </div>
		<div class="form-group">
			<select name="is_active" id="is_active">
				<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.pasif'></option>
				<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.aktif'></option>
				<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
			</select>
        </div>
		<div class="form-group">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
        </div>
		<div class="form-group">
			<cf_wrk_search_button button_type="3"><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
			 </div>
	</cf_box_search>
    <cf_box_search_detail>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-in_out">
				<label> <cf_get_lang dictionary_id='51554.Yetkili Şubeler'></label>
                <select name="zone_director" id="zone_director" style="width:300px;">
                    <option value=""><cf_get_lang dictionary_id='51554.Yetkili Şubeler'></option>
                    <cfoutput query="get_branch">
                    	<option value="#branch_id#" <cfif attributes.zone_director eq branch_id>selected</cfif>>#branch_name#</option>
                    </cfoutput>
                </select>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-in">
				<label> <cf_get_lang dictionary_id='51960.Planlayan'></label>
				<div class="input-group">
                <input type="hidden" name="search_emp_id" id="search_emp_id" value="<cfif len(attributes.search_emp_id) and len(attributes.employee_name)><cfoutput>#attributes.search_emp_id#</cfoutput></cfif>">
                <input type="text" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>" maxlength="255" style="width:110px;">
				<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_visit.search_emp_id&field_name=list_visit.employee_name&select_list=1&keyword='+encodeURIComponent(document.list_visit.employee_name.value),'list');"></span>
			</div>
		</div>
		</div>
    </cf_box_search_detail>
   </cfform>
</cf_box>
<cf_box title="#getlang('','Ziyaret Planları','51824')#" uidrop="1">
	<cf_grid_list>
	<thead>
	  <tr>
		<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
		<th><cf_get_lang dictionary_id='51720.Plan'></th>
		<th width="80"><cf_get_lang dictionary_id='51825.Ziyaret Sayısı'></th>
		<th width="125"><cf_get_lang_main dictionary_id='57742.Tarih'></th> 
		<th width="300"><cf_get_lang dictionary_id='57453.Şube'></th>
		<th width="125"><cf_get_lang dictionary_id='51960.Planlayan'></th>
		<th width="90"><cf_get_lang dictionary_id='51826.Ziyaret Formu'></th>
		<th width="10" class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=crm.form_add_visit"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
	  </tr>
    </thead>
    <tbody>
	<cfif get_event_plan.recordcount>
		<cfscript>
			count_list = '';
			branch_zone_list = '';
			analyse_list = '';
			emp_list = '';
		</cfscript>
		<cfoutput query="get_event_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		  <cfif len(event_plan_id) and not listfind(count_list,event_plan_id)>
			<cfset count_list = listappend(count_list,event_plan_id,',')>
		  </cfif>
		  <cfif len(sales_zones) and not listfind(branch_zone_list,sales_zones)>
			<cfset branch_zone_list = listappend(branch_zone_list,sales_zones,',')>
		  </cfif>
		  <cfif len(analyse_id) and not listfind(analyse_list,analyse_id)>
			<cfset analyse_list = listappend(analyse_list, analyse_id,',')>
		  </cfif>
		  <cfif len(record_emp) and not listfind(emp_list,record_emp)>
			<cfset emp_list = listappend(emp_list, record_emp,',')>
		  </cfif>		  
		</cfoutput>
		
		<cfif len(count_list)>
			<cfset count_list=listsort(count_list,"numeric","ASC",",")>		
			<cfquery name="GET_COUNT" datasource="#dsn#">
				SELECT 
					COUNT(EVENT_PLAN_ROW_ID) AS SAYI,
					EVENT_PLAN_ID
				FROM
					EVENT_PLAN_ROW
				WHERE
					EVENT_PLAN_ID IN (#count_list#)
				GROUP BY
					EVENT_PLAN_ID ORDER BY EVENT_PLAN_ID 
			</cfquery>
			<cfset main_count_list = listsort(listdeleteduplicates(valuelist(get_count.event_plan_id,',')),'numeric','ASC',',')>
		</cfif>
		
		<cfif len(branch_zone_list)>
			<cfset branch_zone_list = listsort(branch_zone_list,'numeric','ASC',',')>
			<cfquery name="GET_BRANCH_ZONE" datasource="#DSN#">
				SELECT
					BRANCH_ID,
					BRANCH_NAME
				FROM
					BRANCH
				WHERE
					BRANCH_ID IN (#branch_zone_list#)
				ORDER BY
					BRANCH_ID  
			</cfquery>
			<cfset main_branch_zone_list = listsort(listdeleteduplicates(valuelist(get_branch_zone.branch_id,',')),'numeric','ASC',',')>
		</cfif>

		<cfif len(analyse_list)>
			<cfset analyse_list = listsort(analyse_list,'numeric','ASC',',')>
			<cfquery name="GET_ANALYSE" datasource="#DSN#">
				SELECT 
					ANALYSIS_ID, 
					ANALYSIS_HEAD
				FROM
					MEMBER_ANALYSIS
				WHERE
					ANALYSIS_ID IN (#analyse_list#)
				ORDER BY
					ANALYSIS_ID
			</cfquery>
			<cfset main_analyse_list = listsort(listdeleteduplicates(valuelist(get_analyse.analysis_id,',')),'numeric','ASC',',')>
		</cfif>
		
		<cfif len(emp_list)>
			<cfset emp_list = listsort(emp_list,'numeric','ASC',',')>
			<cfquery name="GET_EMP1" datasource="#DSN#">
				SELECT
					EMPLOYEE_NAME,
					EMPLOYEE_SURNAME,
					EMPLOYEE_ID				
				FROM
					EMPLOYEES
				WHERE
					EMPLOYEE_ID IN (#emp_list#)
				ORDER BY
					EMPLOYEE_ID
			</cfquery>
			<cfset emp_list = listsort(listdeleteduplicates(valuelist(get_emp1.employee_id,',')),'numeric','ASC',',')>
		</cfif>		
	<cfoutput query="get_event_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	  <tr>
		<td>#currentrow#</td>
		<td><a href="#request.self#?fuseaction=crm.form_upd_visit&visit_id=#event_plan_id#" class="tableyazi">#event_plan_head#</a></td>
		<td align="center"><cfif len(event_plan_id)>#get_count.sayi[listfind(main_count_list,event_plan_id,',')]#</cfif></td>
		<td>#dateformat(main_start_date,dateformat_style)# - #dateformat(main_finish_date,dateformat_style)#</td>
		<td><cfif len(sales_zones)>#get_branch_zone.branch_name[listfind(main_branch_zone_list,sales_zones,',')]#</cfif></td>
		<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#get_emp1.employee_name[listfind(emp_list,record_emp,',')]# #get_emp1.employee_surname[listfind(emp_list,record_emp,',')]#</a>
		<!--- BK 20061107 90 gune siline #get_emp_info(record_emp,0,1)# --->
		</td>
		<td><cfif len(analyse_id)><a href="#request.self#?fuseaction=member.analysis&analysis_id=#analyse_id#" class="tableyazi">#get_analyse.analysis_head[listfind(main_analyse_list,get_event_plan.analyse_id,',')]#</a></cfif></td>
		<td width="15"><a href="#request.self#?fuseaction=crm.form_upd_visit&visit_id=#event_plan_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
	  </tr>
	</cfoutput>
	<cfelse>
	  <tr>
		<td colspan="8"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif><!--- <cf_get_lang_main no='72.Kayıt Bulunamadı'> ! ---></td>
	  </tr>
	</cfif>
   </tbody>
	</cf_grid_list>
	<cfset url_str = "">
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfset url_str = "#url_str#&search_emp_id=#attributes.search_emp_id#">
	<cfset url_str = "#url_str#&employee_name=#attributes.employee_name#">
	<cfif len(attributes.zone_director)>
		<cfset url_str = "#url_str#&zone_director=#attributes.zone_director#">
	</cfif>
	
	<cfif len(attributes.is_active)>
		<cfset url_str = "#url_str#&is_active=#attributes.is_active#">
	</cfif>
	<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
		<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
	</cfif>
      <cf_paging
        page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="crm.list_visit#url_str#">
</cf_box>

