<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_name" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.work_id" default="">
<cfparam name="attributes.material_stage" default="">
<cf_papers paper_type="pro_material">
<cfif isdefined("paper_full") and isdefined("paper_number")>
	<cfset system_paper_no = paper_full>
<cfelse>
	<cfset system_paper_no = "">
</cfif>
<cfif isDefined('attributes.project_id') and len(attributes.project_id)>
    <cfquery name="GET_PRO_PROJECTS" datasource="#DSN#">
        SELECT COMPANY_ID, CONSUMER_ID, PARTNER_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">	
    </cfquery>
</cfif>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.popup_add_project_material%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
        <td class="headbold">Proje Malzeme Planı</td>
    </tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=pda.emptypopup_add_project_material" onsubmit="return( pre_submit() );">
    <input type="hidden" name="search_process_date" id="search_process_date" value="action_date">
    <input type="hidden" name="basket_due_value" id="basket_due_value" value="">
    <input type="hidden" name="row_count" id="row_count" value="0">	
    <table cellpadding="2" cellspacing="1" class="color-border" align="center" style="width:98%">	
		<tr>
            <td class="color-row">
                <table align="left" style="width:99%">
					<cfoutput>
                    <tr>
                        <td style="width:10%"><cf_get_lang_main no='75.No'></td>
                        <td style="width:40%">
                            <cfif isDefined('system_paper_no')>
                                <cfinput type="text" name="pro_number" id="pro_number" value="#system_paper_no#" maxlength="50" required="Yes" message="" style="width:75px;">
                            <cfelse>
                                <cfinput type="text" name="pro_number" id="pro_number" value="" maxlength="50" required="Yes" message="" style="width:75px;">
                            </cfif>                     
                        </td>
                    </tr>
                   	<tr>
                        <td><cf_get_lang_main no='330.Tarih'></td>
                        <td><cfinput type="text" name="action_date" id="action_date" value="#dateformat(now(),'dd/mm/yyyy')#" style="width:75px;" required="Yes" message="" validate="eurodate" maxlength="10" passThrough="onblur=""change_money_info('form_basket','action_date');""">
                            <cf_wrk_date_image date_field="action_date" call_function="change_money_info">
                        </td>
               		</tr>
                    <cfif isDefined('is_company') and is_company eq 1>
                        <tr>
                            <td><cf_get_lang_main no='162.Şirket'>*</td>
                            <td><input type="hidden" name="company_id" id="company_id" value="<cfif isDefined('attributes.project_id') and len(attributes.project_id)><cfif len(get_pro_projects.company_id)>#get_pro_projects.company_id#</cfif></cfif>">
                                <input type="text" name="comp_name" id="comp_name" readonly value="<cfif isDefined('attributes.project_id') and len(attributes.project_id)><cfif len(get_pro_projects.company_id)>#get_par_info(get_pro_projects.partner_id,0,1,0)#</cfif></cfif>" style="width:150px;">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_basket.company_id&field_comp_name=form_basket.comp_name&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_consumer=form_basket.consumer_id&select_list=2,3','list')"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang_main no='166.Yetkili'>*</td>
                            <td><input type="hidden" name="partner_id" id="partner_id" value="<cfif isDefined('attributes.project_id') and len(attributes.project_id)><cfif len(get_pro_projects.partner_id)>#get_pro_projects.partner_id#</cfif></cfif>">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isDefined('attributes.project_id') and len(attributes.project_id)><cfif len(get_pro_projects.consumer_id)>#get_pro_projects.consumer_id#</cfif></cfif>">
                                <input type="text" name="partner_name" id="partner_name" value="<cfif isDefined('attributes.project_id') and len(attributes.project_id)><cfif len(get_pro_projects.partner_id)>#get_par_info(get_pro_projects.partner_id,0,-1,0)#<cfelseif len(get_pro_projects.consumer_id)>#get_cons_info(get_pro_projects.consumer_id,0,0)#</cfif></cfif>" readonly style="width:150px;">
                            </td>
                        </tr>
                    </cfif>
                    <cfif isDefined('is_budget') and is_budget eq 1>
                        <tr>
                            <td style="width:10%"><cf_get_lang_main no='147.Bütçe'></td>
                            <td style="width:40%">
                                <input type="hidden" name="budget_id" id="budget_id" value="">
                                <input type="text" name="budget_name" id="budget_name" value="" style="width:150px;" readonly="">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_budget&field_id=form_basket.budget_id&field_name=form_basket.budget_name&select_list=2','list');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
                            </td>
                        </tr>
                    </cfif>
                    <tr>
                     	<td>Planlayan</td>
                        <td><input type="hidden" name="planner_emp_id" id="planner_emp_id" value="#session.pda.userid#">
                            <input type="text" name="planner_emp_name" id="planner_emp_name" value="#session.pda.name# #session.pda.surname#">
							<a href="javascript://" onClick="get_employee_div();"><img src="/images/plus_list.gif" border="0" align="absmiddle" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr><td colspan="2"><div id="employee_div"></div></td></tr>
                    <tr>
                     	<td>İş</td>
                        <td><cfif len(attributes.work_id)>
                                <cfquery name="GET_WORK" datasource="#DSN#">
                                    SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
                                </cfquery>
                            </cfif>
                            <input type="hidden" name="work_id" id="work_id" value="#attributes.work_id#">
                            <input type="text" name="work_head" id="work_head" value="<cfif len(attributes.work_id)>#get_work.work_head#</cfif>" readonly="yes">
                        </td>
                    </tr>
                    <tr>
                      	<td><cf_get_lang_main no='4.Proje'></td>
                        <td><input type="hidden" name="project_id" id="project_id" value="<cfif Len(attributes.project_id)>#attributes.project_id#</cfif>">
                            <input type="text" name="project_head" id="project_head" value="<cfif Len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')" autocomplete="off" readonly="yes">
                        </td>
                    </tr>
                    <tr>
                        <td style="vertical-align:top;"><cf_get_lang_main no='217.Açıklama'></td>
                        <td style="vertical-align:top;"><textarea name="pro_material_detail" id="pro_material_detail"></textarea></td>
                    </tr>
                    <tr>
                        <td>Ürün Ara</td>
                        <td>
                        	<input type="text" name="search" id="search" value="" />
                        	<a onClick="get_products();"><img src="/images/buyutec.jpg" align="absbottom" border="0" class="form_icon"></a>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <table id="mydiv" style="display:none;">
                                <tr>
                                    <td></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                    	<td></td>
                    	<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                    </tr>
                    <tr>
                        <td colspan="2"><div id="products_div" style="display:none;"></div></td>
                    </tr>
                   <!--- <tr>
                        <td><cf_get_lang_main no='1447.Süreç'></td>
                        <td colspan="6" style="text-align:left"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></td>
                    </tr> --->
                    </cfoutput>
                </table>
            </td>
        </tr>
    </table><br/>
	<!---<cfset attributes.basket_id = 50>
    <cfif  not isdefined('url.is_copy')><!--- Eğer güncelleme sayfasından kopyalama yapılıyorsa basketteki işleri alması için --->
        <cfset attributes.form_add = 1>
    </cfif>
    <cfinclude template="../../objects/display/basket.cfm">--->
</cfform> 
<script type="text/javascript">
	function get_products()
	{
		if(document.getElementById('search').value.length < 3)
		{
			alert("Lütfen ürün ara alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(products_div);
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_get_product_div','products_div');
	}
	function kontrol()
	{
		x=document.getElementById('row_count').value+1;
		for(i=1;i<x;i++)
		{
			eval("document.getElementById('price"+i+"')").value = filterNum(eval("document.getElementById('price"+i+"')").value);
			eval("document.getElementById('price_other"+i+"')").value = filterNum(eval("document.getElementById('price_other"+i+"')").value);
			eval("document.getElementById('other_money_"+i+"')").value = filterNum(eval("document.getElementById('other_money_"+i+"')").value);
			eval("document.getElementById('other_money_value_"+i+"')").value = filterNum(eval("document.getElementById('other_money_value_"+i+"')").value);
		}return false;
		/*if(document.form_basket.company_id.value == "" && document.form_basket.consumer_id.value == "")
		{ 
			alert ("<cf_get_lang no='162.Cari Hesabı Seçmelisiniz !'>");
			return false;
		}
		return process_cat_control(); */
	}	
		
	function get_employee_div()
	{
		if(document.getElementById('planner_emp_name').value.length < 3)
		{
			alert("Lütfen görevli alanı için en az 3 karakter giriniz !");
			return false;
		}
		goster(employee_div);
		AjaxPageLoad(<cfoutput>'#request.self#</cfoutput>?fuseaction=pda.emptypopup_list_employee_div&project_emp_id='+ encodeURI(document.getElementById('planner_emp_name').value) +'','employee_div');		
		return false;
	}
	
	function add_employee_div(employee_id, proj_emp_name_sur)
	{
		document.getElementById('planner_emp_id').value = employee_id;
		document.getElementById('planner_emp_name').value = proj_emp_name_sur;
		gizle(employee_div);
	}
</script>
