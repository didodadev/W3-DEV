<cfquery name="GET_WORK" datasource="#DSN#">
	SELECT 
		PW.TARGET_START,
		PW.TARGET_FINISH,
		PW.WORK_HEAD,
		PW.WORK_CAT_ID,
		PW.WORK_PRIORITY_ID,
		PW.WORK_DETAIL,
		PW.WORK_ID,
		PW.WORK_CURRENCY_ID,
        PW.PROJECT_ID,
		PW.RECORD_AUTHOR,
        PW.UPDATE_AUTHOR,
        PW.UPDATE_DATE,
		EP.POSITION_CODE,
		PW.RECORD_DATE
	FROM 
		PRO_WORKS PW,
		EMPLOYEE_POSITIONS EP
	WHERE 
		PW.PROJECT_EMP_ID = EP.EMPLOYEE_ID AND
		PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
</cfquery>
<cfquery name="GET_CATS" datasource="#DSN#">
	SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
</cfquery>
<cfif len(get_work.project_id)>
    <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
        SELECT PROJECT_ID, PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.project_id#">
    </cfquery>
</cfif>
<cfset url.id = attributes.work_id>
<cfinclude template="../../project/query/get_work_history.cfm">
<cfquery name="GET_STAGES" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.popup_add_work%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfscript>
	sdate=date_add('h', session.pda.time_zone, get_work.target_start);
	fdate=date_add('h', session.pda.time_zone, get_work.target_finish);
	shour=datepart('h',sdate);
	fhour=datepart('h',fdate);
</cfscript>
<cfinclude template="../../project/query/get_pro_work_cat.cfm">
	
<cfoutput>
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">İş Güncelle</td>
        <cfif isDefined('xml_project_material') and xml_project_material eq 1>
        	<td align="right"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=pda.list_stock_receipts&project_id=#get_work.project_id#&work_id=#attributes.work_id#','wide')"><img src="/images/forklift.gif" border="0" title="Stok Fişi"></a></td>
        </cfif>
	</tr>
</table>
</cfoutput>

<cfform name="upd_work" action="#request.self#?fuseaction=pda.emptypopup_upd_work" method="post">
<input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">	
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<table align="center" style="width:99%">
				<tr>
					<td style="width:30%"><cf_get_lang_main no="1408.Başlık">*</td>
					<td><cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="1408.Başlık"></cfsavecontent>
						<cfinput type="text" name="work_head" id="work_head" value="#get_work.work_head#" required="yes" message="#msg#" style="width:193px;">
                	</td>
				</tr>
                <cfif isDefined('xml_project') and xml_project eq 1>
                    <tr>
                        <td><cf_get_lang_main no="4.Proje">*</td>
                        <td>
                            <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_project_name.project_id#</cfoutput>">
                            <cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="4.Proje"></cfsavecontent>
                            <cfif len(get_work.project_id)>
                                <cfinput type="text" name="project_head" id="project_head" value="#get_project_name.project_head#" required="yes" message="#msg#" style="width:163px;">
                            <cfelse>
                                <cfinput type="text" name="project_head" id="project_head" value="" required="yes" message="#msg#" style="width:163px;">                        
                            </cfif>
                            <a href="javascript://" onClick="get_project_div();"><img src="/images/buyutec.jpg" title="<cf_get_lang_main no='1385.Proje Seçiniz'>" align="absmiddle" border="0" class="form_icon"></a>
                        </td>
                    </tr>
					<tr><td colspan="2"><div id="project_div" style="display:none;"></div></td></tr>                
				</cfif>
				<tr>
					<td><cf_get_lang_main no="157.Görevli">*</td>
					<cfif get_work.position_code neq 0 and len(get_work.position_code)>
						<cfset person="#get_emp_info(get_work.position_code,1,0)#">
					<cfelse>
						<cfset person="">
					</cfif>
					<td>
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.pda.userid#</cfoutput>">
                        <cfsavecontent variable="msg"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="157.Görevli"></cfsavecontent>
						<cfinput type="text" name="responsable_name" id="responsable_name" value="#person#" required="yes" message="#msg#" style="width:163px;"> 
						<a href="javascript://" onClick="get_employee_div();"><img src="/images/buyutec.jpg" border="0" align="absmiddle" class="form_icon"></a>
					</td>
				</tr>
				<tr><td colspan="2"><div id="employee_div" style="display:none;"></div></td></tr>
				<tr>
					<td>Kategori *</td>
					<td>
						<select name="pro_work_cat" id="pro_work_cat" style="width:200px;">
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<cfoutput query="get_work_cat">
								<option value="#work_cat_id#" <cfif len(get_work.work_cat_id) and (get_work.work_cat_id eq work_cat_id)>selected</cfif>>#work_cat# 
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>Öncelik</td>
					<td>
						<select name="priority_cat" id="priority_cat" style="width:200px;">
							<cfoutput query="get_cats">
								<option value="#priority_id#" <cfif get_work.work_priority_id eq priority_id>selected</cfif>>#priority#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr>
					<td>Aşama</td>
					<td>
						<select name="work_currency" id="work_currency" style="width:200px;">
							<cfoutput query="get_stages">
								<option value="#process_row_id#" <cfif process_row_id eq get_work.work_currency_id>selected</cfif>>#stage#</option>
							</cfoutput>
					  	</select>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="1055.Başlama"></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="243.Başlama tarihi"></cfsavecontent>
						<cfinput type="text" name="work_h_start" id="work_h_start" value="#dateformat(sdate,'dd/mm/yyyy')#" maxlength="10" required="yes" validate="eurodate" message="#message#" style="vertical-align:top;width:85px;">
						<cf_wrk_date_image date_field="work_h_start">
						<cfoutput>
							<select name="start_hour" id="start_hour" style="width:65px;">
								<cfloop from="0" to="23" index="i">
									<option value="#i#" <cfif i eq shour>selected</cfif>>#i#:00</option>
								</cfloop>
							</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td><cf_get_lang_main no="90.Bitiş"></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no="288.Bitiş Tarihi"></cfsavecontent>
						<cfinput type="text" name="work_h_finish" id="work_h_finish" value="#dateformat(fdate,'dd/mm/yyyy')#" maxlength="10" required="yes" validate="eurodate" message="#message#" style="vertical-align:top;width:85px;">
						<cf_wrk_date_image date_field="work_h_finish">
						<cfoutput>
							<select name="finish_hour" id="finish_hour" style="width:65px;">
								<cfloop from="0" to="23" index="i">
									<option value="#i#" <cfif i eq fhour>selected</cfif>>#i#:00</option>
								</cfloop>
							</select>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="vertical-align:top"><cf_get_lang_main no="217.Açıklama"></td>
					<td><textarea name="work_detail" id="work_detail"></textarea></td>
				</tr>
				<tr>
					<td colspan="2" align="right"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=pda.emptypopup_delwork&id=#get_work.work_id#' add_function='kontrol()'></td>
				</tr>
				<!---<tr>
					<td colspan="2">Kayıt : <cfoutput>#get_emp_info(get_work.record_author,0,0)# - #dateformat(get_work.record_date,'dd/mm/yyyy')#</cfoutput></td>
				</tr>  --->
                <tr>
                	<td colspan="2"><cf_record_info query_name='get_work' record_emp="record_author" update_emp="update_author"></td>
                </tr>
			</table>
            <cfoutput>
				<cfif get_work_history.recordcount>
                    <cf_seperator title="#getLang('main',61)#" id="tarihce_">
                    <table id="tarihce_" style="width:99%">
          <tr id="works_history">
                            <td><div id="_works_history_"></div></td>
                        </tr>		
                    </table>
                    <script type="text/javascript">
                        <cfoutput>
                            AjaxPageLoad('#request.self#?fuseaction=pda.emptypopup_updwork_ajaxhistory&id=#attributes.work_id#','_works_history_',1); 
                        </cfoutput>
                    </script>
            	</cfif>
           	</cfoutput>
		</td>
    </tr>
    <tr>
		<td class="color-row" style="vertical-align:top;">
			<cfinclude template="../../objects2/project/display/work_relation_asset.cfm">
			<br/>
			<cfsavecontent variable="info"><cf_get_lang_main no="1361.Bilgi Verilecekler"></cfsavecontent>
			<cf_workcube_to_cc 
				is_update="1" 
				cc_dsp_name="#info#" 
				form_name="upd_work" 
				str_list_param="1,7" 
				action_dsn="#dsn#"
				str_action_names="CC_EMP_ID AS CC_EMP, CC_PAR_ID AS CC_PAR"
				action_table="PRO_WORKS_CC"
				action_id_name="WORK_ID"
				action_id="#attributes.work_id#"
				data_type="2"
				str_alias_names="">
		</td>
	</tr>
</table>
</cfform>
<br/>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('work_head').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1408.Başlık'>");
			return false;
		}
		x = document.getElementById('pro_work_cat').selectedIndex;
		if (document.getElementById('pro_work_cat')[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}
	}
	
	function get_employee_div()
	{
		if(document.getElementById('responsable_name').value.length < 3)
		{
			alert("Lütfen görevli alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(employee_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_employee_div&project_emp_id='+ encodeURI(document.getElementById('responsable_name').value) +'','employee_div');		
		return false;
	}
	
	function add_employee_div(employee_id, proj_emp_name_sur)
	{
		document.getElementById('position_code').value = employee_id;
		document.getElementById('responsable_name').value = proj_emp_name_sur;
		gizle(employee_div);
	}
	
	function get_project_div()
	{
		goster(project_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_project_div&project_id='+ encodeURI(document.getElementById('project_head').value) +'','project_div');		
		return false;
	}
		
	function add_project_div(project_id, project_head)
	{
		document.getElementById('project_id').value = project_id;
		document.getElementById('project_head').value = project_head;
		gizle(project_div);
	}
</script>
