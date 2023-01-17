 <cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.position_code" default="#session.ep.position_code#">
<cfparam name="attributes.employee_name" default="#session.ep.name# #session.ep.surname#">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(date_add('d',7,now()),dateformat_style)#">
<cfparam name="attributes.visit_cat" default="">
<cfparam name="attributes.zone_director" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.sales_zones_team" default="">
<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.sz_ids" default="0">
<cfparam name="attributes.is_plan" default="">
<cfif len(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
	SELECT TEAM_NAME, TEAM_ID FROM SALES_ZONES_TEAM ORDER BY TEAM_NAME
</cfquery>
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
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfif len(attributes.form_submitted)>
	<cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
			SELECT DISTINCT
				ACTIVITY_PLAN_ROW.EVENT_PLAN_ID,
				ACTIVITY_PLAN_ROW.WARNING_ID,
				ACTIVITY_PLAN_ROW.START_DATE,
				ACTIVITY_PLAN_ROW.FINISH_DATE,
				ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID,
				ACTIVITY_PLAN_ROW.EXECUTE_STARTDATE,
				ACTIVITY_PLAN_ROW.EXECUTE_FINISHDATE,
				ACTIVITY_PLAN_ROW.VISIT_STAGE,
				ACTIVITY_PLAN_ROW.RESULT_RECORD_EMP,
				COMPANY.FULLNAME,
				COMPANY.COMPANY_ID,
				COMPANY_PARTNER.COMPANY_PARTNER_NAME,
				COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
				COMPANY_PARTNER.PARTNER_ID,
				SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE
			FROM
				ACTIVITY_PLAN_ROW,
				COMPANY,
				COMPANY_PARTNER,
				SETUP_ACTIVITY_TYPES,
				COMPANY_BRANCH_RELATED,
				BRANCH
			WHERE 
				<cfif len(attributes.company_name) and len(attributes.company_id)>COMPANY.COMPANY_ID = #attributes.company_id# AND</cfif>
				<cfif len(attributes.start_date)>ACTIVITY_PLAN_ROW.START_DATE >= #attributes.start_date# AND</cfif>
				<cfif len(attributes.finish_date)>ACTIVITY_PLAN_ROW.START_DATE < #DATEADD("d", 1, attributes.finish_date)# AND</cfif>
				<cfif len(attributes.visit_cat)>ACTIVITY_PLAN_ROW.WARNING_ID = #attributes.visit_cat# AND</cfif>
				<cfif len(attributes.ims_code_name) and len(attributes.ims_code_id)>COMPANY.IMS_CODE_ID = #attributes.ims_code_id# AND</cfif>
				<cfif len(attributes.employee_name) and len(attributes.position_code)>ACTIVITY_PLAN_ROW.POSITION_ID = #attributes.position_code# AND</cfif>
				<cfif len(attributes.is_plan) and (attributes.is_plan eq 1)>EVENT_PLAN_ID IS NOT NULL AND<cfelseif len(attributes.is_plan) and (attributes.is_plan eq 2)>EVENT_PLAN_ID IS NULL AND</cfif>
				<cfif len(attributes.zone_director)>BRANCH.BRANCH_ID = #attributes.zone_director# AND</cfif>
				<cfif get_sales_zones.recordcount>
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
							AND SZ.SZ_ID IN (#valuelist(GET_SALES_ZONES.SZ_ID)#)
							AND BR.BRANCH_ID = SZ.RESPONSIBLE_BRANCH_ID
							<cfif len(attributes.zone_director)>AND BR.BRANCH_ID = #attributes.zone_director#</cfif>
							<cfif len(attributes.employee_name) and len(attributes.position_code)>AND SZT.TEAM_ID IN ( SELECT TEAM_ID FROM SALES_ZONES_TEAM_ROLES WHERE POSITION_CODE = #attributes.position_code# )</cfif>
					) AND
				</cfif>
				COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
				COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
				COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
				ACTIVITY_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND 
				COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
				SETUP_ACTIVITY_TYPES.ACTIVITY_TYPE_ID = ACTIVITY_PLAN_ROW.WARNING_ID AND
				ACTIVITY_PLAN_ROW.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
				BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
			ORDER BY 
				ACTIVITY_PLAN_ROW.EVENT_PLAN_ROW_ID
			DESC
	</cfquery>
	<cfparam name='attributes.totalrecords' default='#get_event_plan.recordcount#'>
<cfelse>
	<cfparam name='attributes.totalrecords' default='0'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_big_list_search title="#lang_array.item[385]#">
 <cfform name="search_asset" action="#request.self#?fuseaction=crm.list_activity_result" method="post">
	<cf_big_list_search_area>
    <!-- sil -->
    <table>
        <tr>
            <td><input type="hidden" name="form_submitted" id="form_submitted" value="1"></td>
            <td><input type="hidden" name="employee_name" id="employee_name" value="<cfif len(attributes.employee_name)><cfoutput>#attributes.employee_name#</cfoutput></cfif>"></td>
                <input type="hidden" name="position_code" id="position_code" value="<cfif len(attributes.position_code) and len(attributes.employee_name)><cfoutput>#attributes.position_code#</cfoutput></cfif>">
            <td><cf_get_lang_main no='45.Müşteri'></td>
            <td><cfinput type="text" name="company_name" style="width:120px;" value="#attributes.company_name#" maxlength="255">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=search_asset.company_id&field_comp_name=search_asset.company_name&is_crm_module=1&select_list=2,6','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
                <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>"> 
            <td><cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz !'></cfsavecontent>
                <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65;">
                <cf_wrk_date_image date_field="start_date">
            </td>
            <td><cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65;">
            	<cf_wrk_date_image date_field="finish_date">
            </td>
            <td><select name="is_plan" id="is_plan" style="width:60px;">
                    <option value="" <cfif attributes.is_plan eq "">selected</cfif>><cf_get_lang_main no='296.Tümü'></option>
                    <option value="1" <cfif attributes.is_plan eq 1>selected</cfif>><cf_get_lang no='514.Planlı'></option>
                    <option value="2" <cfif attributes.is_plan eq 2>selected</cfif>><cf_get_lang no='278.Plansız'></option>
                </select>
            </td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
            	<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
        </tr>
    </table>
    <!-- sil -->
      </cf_big_list_search_area>
      <cf_big_list_search_detail_area>
	  	<!-- sil -->
        <table>
            <tr>
                <td>
                    <select name="zone_director" id="zone_director" style="width:300px;">
                        <option value=""><cf_get_lang_main no='41.Şube'></option>
                        <cfoutput query="get_branch">
                        	<option value="#branch_id#" <cfif branch_id eq attributes.zone_director>selected</cfif>>#branch_name#</option>
                        </cfoutput>
                    </select>
                </td>
                <td><cfsavecontent variable="text"><cf_get_lang_main no='74.Kategori'></cfsavecontent>
                    <cf_wrk_combo
                    name="visit_cat"
                    query_name="GET_ACTIVITY_TYPES"
                    option_name="activity_type"
                    option_value="activity_type_id"
                    option_text="#text#"
                    value="#attributes.visit_cat#"
                    width="170">
                </td>
                <td><cf_get_lang_main no='722.Mikro Bolge Kodu'></td>
                <td><input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
                    <cfinput type="text" name="ims_code_name" style="width:140px;" value="#attributes.ims_code_name#">
                    <a href="javascript://" onClick="pencere_ac();"><img src="/images/plus_thin.gif" border="0" align="absmiddle" ></a>
                </td>
            </tr>
        </table>
		<!-- sil -->
     </cf_big_list_search_detail_area>
  </cfform>
</cf_big_list_search>
<!-- sil -->
<cf_big_list>
	<thead>
		<tr>
            <th width="20"><cf_get_lang_main no='75.No'></th>
            <th><cf_get_lang no='273.Plan'></th>
            <th width="200"><cf_get_lang_main no='45.Müşteri'></th>
			<th width="120"><cf_get_lang_main no='74.Kategori'></th>
			<th width="120" nowrap><cf_get_lang no='271.Gerçekleşme Tarihi'></th>
			<th width="150"><cf_get_lang_main no='132.Sorumlu'></th>
			<th width="100"><cf_get_lang_main no='272.Sonuç'></th>
			 <!-- sil -->
			<th  class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=crm.popup_activity_info','medium');"><img src="/images/balon.gif" border="0"></a></th>
			<th class="header_icn_none"></th>
			 <!-- sil -->
	    </tr>
    </thead>
    <tbody>
			<cfif len(attributes.form_submitted)>
			<cfif get_event_plan.recordcount>
			<cfoutput query="get_event_plan" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
              <td>#currentrow#</td>
			  <td>
			<cfif len(event_plan_id)>
			<cfquery name="GET_ACTIVITY_PLAN" datasource="#dsn#">
				SELECT EVENT_PLAN_HEAD, ANALYSE_ID FROM ACTIVITY_PLAN WHERE EVENT_PLAN_ID = #event_plan_id#
			</cfquery>
			<a href="#request.self#?fuseaction=crm.form_upd_activity&visit_id=#event_plan_id#" class="tableyazi">#get_activity_plan.event_plan_head#</a><cfelse><font color="##990000"><cf_get_lang no='278.Plansız'></font></cfif></td>
              <td><a href="#request.self#?fuseaction=crm.detail_company&cpid=#company_id#&is_activity=1" class="tableyazi">#fullname#</a> - #company_partner_name# #company_partner_surname#</td>
			  <td>#activity_type#</td>
			  <td>#dateformat(execute_startdate,dateformat_style)#-#dateformat(execute_finishdate,dateformat_style)#</td>
			  <td><cfquery name="GET_POSIDS" datasource="#dsn#">
			  		SELECT POSITION_ID FROM ACTIVITY_PLAN_ROW WHERE EVENT_PLAN_ROW_ID = #event_plan_row_id#
			  </cfquery>
			  <cfloop query="get_posids">#get_emp_info(get_posids.position_id,1,0)#,</cfloop></td>
			 
			  <td><cfif len(visit_stage)>
			  <cfquery name="GET_STAGE" datasource="#dsn#">
			  	SELECT ACTIVITY_STAGE FROM SETUP_ACTIVITY_STAGES WHERE ACTIVITY_STAGE_ID = #visit_stage#
			  </cfquery>#get_stage.activity_stage#</cfif></td>
			   <!-- sil -->
			  <td width="20">
			  <cfif event_plan_id eq "">
			  		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_upd_activity&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'medium');"><img src="/images/balon.gif" border="0"></a>
			  <cfelse>
				  <cfif len(result_record_emp)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'medium');"><img src="/images/balon.gif" border="0"></a>
				  <cfelse>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_activity_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#partner_id#' ,'medium');"><img src="/images/balon.gif" border="0"></a>
				  </cfif>
			  </cfif>
			  </td>
			  <td width="20">
			  <cfif len(event_plan_id)>
			  	<cfif len(get_activity_plan.analyse_id)>
				  <cfquery name="GET_ANALYSIS_RES" datasource="#dsn#">
					SELECT RESULT_ID, PARTNER_ID FROM MEMBER_ANALYSIS_RESULTS WHERE PARTNER_ID = #partner_id#
				  </cfquery>
					<cfif get_analysis_res.recordcount>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_user_analysis_result&analysis_id=#get_activity_plan.analyse_id#&result_id=#get_analysis_res.result_id#&member_type=partner&partner_id=#partner_id#&is_popup=1','medium');"><img src="/images/question.gif" border="0" title="<cf_get_lang_main no='52.Güncelle'>"></a> 
					<cfelse>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_make_analysis&analysis_id=#get_activity_plan.analyse_id#&member_type=partner&member_id=#partner_id#&is_popup=1','list');"><img src="/images/question.gif" border="0" title="<cf_get_lang no='170.Ekle'>"></a>
					</cfif>
				</cfif>
			  </cfif></td>
			  <!-- sil -->
            </tr>
          </cfoutput>
          <cfelse>
          <tr class="color-row">
            <td height="20" colspan="12"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
          </tr>
        </cfif>
		<cfelse>
          <tr class="color-row">
            <td height="20" colspan="12"><cf_get_lang_main no='289.Filtre Ediniz'> !</td>
          </tr>
		</cfif>
   </tbody>
</cf_big_list>
<!-- sil -->
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
	<cfif len(attributes.visit_cat)>
	  <cfset url_str = "#url_str#&visit_cat=#attributes.visit_cat#">
	</cfif>
	<cfif len(attributes.zone_director)>
	  <cfset url_str = "#url_str#&zone_director=#attributes.zone_director#">
	</cfif>
	<cfif len(attributes.ims_code_id)>
	  <cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
	</cfif>
	<cfif len(attributes.ims_code_name)>
	  <cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
	</cfif>
	<cfif len(attributes.sz_ids)>
	  <cfset url_str = "#url_str#&sz_ids=#attributes.sz_ids#">
	</cfif>
	<cfif len(attributes.form_submitted)>
	  <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
    <tr>
      <td><cf_pages 
	  		page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="crm.list_activity_result#url_str#"></td>
      <td style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'><cfoutput>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
<cfelse>
<br/>
</cfif>
<!-- sil -->
<script type="text/javascript">
	function pencere_ac(selfield)
	{	
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=search_asset.ims_code_name&field_id=search_asset.ims_code_id&is_submitted=1','list');
	}
</script>
