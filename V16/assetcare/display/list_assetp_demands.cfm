
<cfsetting showdebugoutput="yes">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(CreateDate(year(now()),month(12),1));
</cfscript>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.assetp_catid" default="">
<cfparam name="attributes.assetp_sub_catid" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.req_emp" default="">
<cfparam name="attributes.make_year" default="">
<cfparam name="attributes.brand_type_id" default="">
<cfparam name="attributes.asset_p_status" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.startdate" default="1/1/#session.ep.period_year#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/12/#session.ep.period_year#">
<cfif len(attributes.startdate) and isdate(attributes.startdate) >
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cfset login_act = createObject("component", "V16.assetcare.cfc.demands")>
<cfset login_act.dsn = dsn />
<cfset get_assetp_demands = login_act.GET_DEMANDS_FNC(
								keyword : attributes.keyword,    
                                assetp_sub_catid : attributes.assetp_sub_catid, 
                               assetp_catid :  attributes.assetp_catid, 
                                req_emp_id : attributes.req_emp_id, 
                                comp_id : attributes.comp_id, 
                                branch_id : attributes.branch_id, 
								department : attributes.department, 
                                brand_type_id : attributes.brand_type_id,
                                make_year : attributes.make_year,
                                process_stage : attributes.process_stage, 
                                startdate : attributes.startdate,
                                finishdate : attributes.finishdate,
                                asset_p_status:attributes.asset_p_status
							)>
<cfelse>
	<cfset get_assetp_demands.recordcount = 0>
</cfif>
<cfquery name="get_asset_cats" datasource="#dsn#">
    SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_branchs" datasource="#dsn#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>COMPANY_ID IN(#attributes.comp_id#)<cfelse>1=0</cfif>ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.list_assetp_demands%">
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_assetp_demands.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_demand" method="post" action="#request.self#?fuseaction=assetcare.list_assetp_demands">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
                    <cfinput type="text" name="keyword" id="keyword" maxlength="255" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group" id="item-department">
                    <select name="department" id="department" style="width:150px;">
                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
                            <cfquery name="get_department" datasource="#dsn#">
                                SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 ORDER BY DEPARTMENT_HEAD
                            </cfquery>
                            <cfoutput query="get_department">
                                <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
                            </cfoutput>
                        </cfif>
                    </select>
                </div>
                <div class="form-group" id="item-req_emp">
                    <div class="input-group">
                        <input type="hidden" name="req_emp_id" id="req_emp_id" value="">
                        <cfinput type="text" name="req_emp" value="#attributes.req_emp#" required="no" placeholder="#getLang(82,'Talep Eden',47953)#">
                        <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=search_demand.req_emp_id&field_name=search_demand.req_emp&select_list=1</cfoutput>','list')"></span>
                    </div>
                </div>
                <div class="form-group" id="item-process_stage">
                    <select name="process_stage" id="process_stage">
                        <option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
                        <cfoutput query="get_process_stage">
                            <option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-asset_p_status">
                    <select name="asset_p_status" id="asset_p_status">
                        <option value="1"<cfif isDefined("attributes.asset_p_status") and (attributes.asset_p_status eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0"<cfif isDefined("attributes.asset_p_status") and (attributes.asset_p_status eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                    </select>
                </div>
                <div class="form-group small" id="item-maxrows">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-assetp_catid">
                        <label class="col col-12"><cf_get_lang dictionary_id='48388.Varlık Tipi'></label>
                        <div class="col col-12">
                            <select name="assetp_catid" id="assetp_catid" onchange="get_assetp_sub_cat();">
                                <option value=""><cf_get_lang dictionary_id='48388.Varlık Tipi'></option>
                                <cfoutput query="get_asset_cats">
                                    <option value="#ASSETP_CATID#" <cfif isdefined("attributes.assetp_catid") and Len(attributes.assetp_catid) and attributes.assetp_catid eq ASSETP_CATID>selected</cfif>>#ASSETP_CAT#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-12"><cf_get_lang dictionary_id='58847.Marka'> / <cf_get_lang dictionary_id='30041.Marka Tipi'></label>
                        <div class="col col-12">
                            <cf_wrkbrandtypecat
                                returninputvalue="brand_name,brand_type_id"
                                returnqueryvalue="BRAND_TYPE_CAT_HEAD,BRAND_TYPE_ID"
                                brand_type_id="#attributes.brand_type_id#"
                                width="105"
                                compenent_name="getBrandType2"               
                                boxwidth="200"
                                boxheight="150"
                                is_type_cat_id=0>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-6 col-xs-12" type="column" sort="true" index="2">
                    <div class="form-group" id="item-assetp_sub_catid">
                        <label class="col col-12"><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></label>
                        <div class="col col-12">
                            <cfif len(attributes.assetp_catid)>
                                <cfquery name="GET_SUB_CAT" datasource="#dsn#">
                                    SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = #attributes.assetp_catid#
                                </cfquery>
                            </cfif>
                            <select name="assetp_sub_catid" id="assetp_sub_catid" style="width:120px;">
                                <option value=""><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></option>
                                <cfif len(attributes.assetp_sub_catid)>
                                    <cfoutput query="GET_SUB_CAT">
                                        <option value="#ASSETP_SUB_CATID#" <cfif  GET_SUB_CAT.ASSETP_SUB_CATID eq attributes.assetp_sub_catid> selected="selected"</cfif>>#ASSETP_SUB_CAT#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-make_year">
                        <label class="col col-12"><cf_get_lang dictionary_id='58225.Model'></label>
                        <div class="col col-12">
                            <select name="make_year" id="make_year" style="width:80px;">
                                <option value=""><cf_get_lang dictionary_id='58225.Model'></option>
                                <cfset yil = dateformat(dateadd("yyyy",1,now()),"yyyy")>
                                <cfoutput>
                                    <cfloop from="#yil#" to="1970" index="i" step="-1">
                                        <option value="#i#" <cfif attributes.make_year eq i>selected</cfif>>#i#</option>
                                    </cfloop>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-6 col-xs-12" type="column" sort="true" index="3">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                <cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
                                    <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
                                <cfelse>
                                    <cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#" >
                                </cfif>
                                <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-comp_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                        <div class="col col-12">
                            <select name="comp_id" id="comp_id" onchange="showBranch(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
                                <cfoutput query="get_company">
                                    <option value="#COMP_ID#" <cfif isdefined("attributes.comp_id") and attributes.comp_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-6 col-xs-12" type="column" sort="true" index="4">
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
                                    <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                <cfelse>
                                    <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                                </cfif>
                                <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id" style="width:150px;" onchange="showDepartment(this.value)">
                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
                                <cfoutput query="get_branchs">
                                    <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(115,'Talepler',47806)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='48388.Varlık Tipi'></th>
                    <th><cf_get_lang dictionary_id='47876.Varlık Alt Kategorisi'></th>
                    <th><cf_get_lang dictionary_id='47953.Talep Eden'></th>
                    <th><cf_get_lang dictionary_id='47901.Kullanım Amacı'></th>
                    <th><cf_get_lang dictionary_id='47994.Talep Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='55804.Onay Durumu'></th>
                    <th ><cf_get_lang dictionary_id='58515.Aktif / Pasif'></th>
                    <th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.list_assetp_demands&event=add')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></td>
                </tr>
            </thead>
            <tbody>
                <cfif get_assetp_demands.recordcount>
                    <cfoutput query="get_assetp_demands" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#assetp_cat#</td>
                            <td>#assetp_sub_cat#</td>
                            <td>#employee_name# #employee_surname#</td>
                            <td>#usage_purpose#</td>
                            <td>#dateformat(request_date,dateformat_style)#</td>
                            <td>
                                <cfif len(record_emp)>
                                    <cfquery name="get_emp_detail" datasource="#dsn#">
                                        SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #record_emp#
                                    </cfquery>
                                </cfif> 
                                #get_emp_detail.employee_name# #get_emp_detail.employee_surname# 
                            </td>
                            <td>#stage#</td>
                            <td><cfif asset_p_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                            <td width="15" style="text-align:center"><a href="#request.self#?fuseaction=assetcare.list_assetp_demands&event=upd&demand_id=#demand_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str = "">
        <cfif isdefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cfif isdefined("attributes.keyword")>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.assetp_catid")>
            <cfset url_str = "#url_str#&assetp_catid=#attributes.assetp_catid#">
        </cfif>
        <cfif isdefined("attributes.req_emp_id")>
            <cfset url_str = "#url_str#&req_emp_id=#attributes.req_emp_id#">
        </cfif>
        <cfif isdefined("attributes.req_emp")>
            <cfset url_str = "#url_str#&req_emp=#attributes.req_emp#">
        </cfif>
        <cfif isdefined("attributes.comp_id")>
            <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
        </cfif>
        <cfif isdefined("attributes.branch_id")>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isdefined("attributes.department")>
            <cfset url_str = "#url_str#&department=#attributes.department#">
        </cfif>
        <cfif isdefined("attributes.brand_type_id")>
            <cfset url_str = "#url_str#&brand_type_id=#attributes.brand_type_id#">
        </cfif>
        <cfif isdefined("attributes.assetp_sub_catid")>
            <cfset url_str = "#url_str#&assetp_sub_catid=#attributes.assetp_sub_catid#">
        </cfif>
        <cfif isdefined("attributes.make_year")>
            <cfset url_str = "#url_str#&make_year=#attributes.make_year#">
        </cfif>
        <cfif len(attributes.startdate) and isdate(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.process_stage) and isdate(attributes.process_stage)>
            <cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
        <cfif len(attributes.asset_p_status) and isdate(attributes.asset_p_status)>
            <cfset url_str = "#url_str#&asset_p_status=#attributes.asset_p_status#">
        </cfif>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="assetcare.list_assetp_demands#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	function get_assetp_sub_cat()
{
	for ( var i= $("#assetp_sub_catid option").length-1 ; i>-1 ; i--)
		{
				$('#assetp_sub_catid option').eq(i).remove();
		}
	var get_assetp_sub_cat = wrk_query("SELECT ASSETP_SUB_CATID,ASSETP_SUB_CAT FROM ASSET_P_SUB_CAT WHERE ASSETP_CATID = " + $("#assetp_catid").val()+" ORDER BY ASSETP_SUB_CAT","dsn");
	if(get_assetp_sub_cat.recordcount > 0)	
		
	{
		var selectBox = $("#assetp_sub_catid").attr('disabled');
		if(selectBox) $("#assetp_sub_catid").removeAttr('disabled');
		$("#assetp_sub_catid").append($("<option></option>").attr("value", '').text( "Seçiniz !" ));
			for(i = 1;i<=get_assetp_sub_cat.recordcount;++i)
			{
				$("#assetp_sub_catid").append($("<option></option>").attr("value", get_assetp_sub_cat.ASSETP_SUB_CATID[i-1]).text(get_assetp_sub_cat.ASSETP_SUB_CAT[i-1]));
			}
	}
	else{
			
		$("#assetp_sub_catid").attr('disabled','disabled');
		
	}
}
	function showBranch(comp_id)	
	{
		
		var comp_id = $('#comp_id').val();
		if (comp_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
			AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang dictionary_id="57453.Şube">');
		}
		else {
			var myList = $('#branch_id').val();
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode("<cf_get_lang dictionary_id='57453.Şube'>"));
			myList.appendChild(txtFld);
			var myList = $('#department').val();
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode("<cf_get_lang dictionary_id='57572.Departman'>"));
			myList.appendChild(txtFld);
			}
		//departman bilgileri sıfırla
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang dictionary_id='57572.Departman'>");
	}
	function showDepartment(branch_id)	
	{
		
		var branch_id = $('#branch_id').val();
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = $('#department').val();
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode("<cf_get_lang dictionary_id='57572.Departman'>"));
			myList.appendChild(txtFld);
		}
	}
</script>
