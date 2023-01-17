<cfparam name="is_filtered" default="0">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.status" default="2">
<cfparam name="attributes.status_notice" default="0">
<cfparam name="attributes.notice_cat_id" default="">
<cfif is_filtered>
	<cfinclude template="../query/get_notices.cfm">
<cfelse>
	<cfset get_notices.recordcount = 0>
</cfif>
<cfquery name="get_notice_groups" datasource="#DSN#"><!--- İlan Grupları --->
	SELECT NOTICE_CAT_ID,NOTICE FROM SETUP_NOTICE_GROUP ORDER BY NOTICE
</cfquery>
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMPANY_NAME
</cfquery>
<cfset notice_cat_list="">
<cfif is_filtered>
	<cfoutput query="get_notices">
		<cfif len(NOTICE_CAT_ID) and not listfind(notice_cat_list,NOTICE_CAT_ID)>
			<cfset notice_cat_list = Listappend(notice_cat_list,NOTICE_CAT_ID)>
		</cfif>
	</cfoutput>
</cfif>
<cfif len(notice_cat_list)>
	<cfset notice_cat_list=listsort(notice_cat_list,"numeric","ASC",",")>
	<cfquery name="get_notice_groups_" dbtype="query">
		SELECT
			NOTICE_CAT_ID,NOTICE
		FROM
			get_notice_groups
		WHERE
			NOTICE_CAT_ID IN (#notice_cat_list#)
		ORDER BY
			NOTICE_CAT_ID
	</cfquery>
	<cfset notice_cat_list = listsort(listdeleteduplicates(valuelist(get_notice_groups_.NOTICE_CAT_ID,',')),'numeric','ASC',',')>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_notices.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="list_notice" action="#request.self#?fuseaction=hr.list_notice" method="post">
            <input type="hidden" name="is_filtered" id="is_filtered" value="1">            
            <cf_box_search>
                            <div class="form-group">
                                <cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
                            </div>
                            <div class="form-group">
                                <div class="input-group">
                                  
                                    <cfinput type="text" name="startdate" id="startdate"placeholder="#getLang(48,'yayın başlama tarihi',62385)#" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="input-group">
                                    
                                    <cfinput type="text" name="finishdate" id="finishdate"placeholder="#getLang(48,'yayın bitiş tarihi',38536)#" validate="#validate_style#"  maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" >
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                            <div class="form-group">
                                <select name="status" id="status">
                                    <option value="2" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                                    <option value="1" <cfif attributes.status eq 1> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                                    <option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>			                        
                                </select>
                            </div>
                            <div class="form-group">
                                <select name="status_notice" id="status_notice">
                                    <option value="0" <cfif attributes.status_notice eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
                                    <option value="-1" <cfif attributes.status_notice eq -1>selected</cfif>><cf_get_lang dictionary_id='56203.Hazırlık'>
                                    <option value="-2" <cfif attributes.status_notice eq -2> selected</cfif>><cf_get_lang dictionary_id='29479.Yayın'>
                                </select>
                            </div>
                            <div class="form-group small">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                                <cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                            </div>
                            <div class="form-group">
                                <cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                                <cf_wrk_search_button button_type="4" search_function="date_check(list_notice.startdate,list_notice.finishdate,'#message_date#')">                                                         
                            </div>             
            </cf_box_search>
            <cf_box_search_detail>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-notice_cat_id">
                            <label class="col col-12"><cf_get_lang dictionary_id="56510.İlan Grubu"></label>
                            <div class="col col-12">
                                <cf_wrk_combo 
                                name="notice_cat_id"
                                id="notice_cat_id"
                                query_name="GET_NOTICE_GROUP"
                                option_name="notice"
                                value=#attributes.notice_cat_id#
                                option_value="notice_cat_id"
                                width="170">
                            </div>
                        </div>
                        <div class="form-group" id="item-department">
                            <label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
                            <div class="col col-12"> 
                                <div width="125" id="DEPARTMENT_PLACE">
                                    <select name="department" id="department">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id) and attributes.branch_id is not "all">
                                            <cfquery name="get_department" datasource="#dsn#">
                                                SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE BRANCH_ID = #attributes.branch_id# AND DEPARTMENT_STATUS =1 AND IS_STORE<>1 ORDER BY DEPARTMENT_HEAD
                                            </cfquery>
                                            <cfoutput query="get_department">
                                                <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                        <div class="form-group" id="item-company">
                            <label class="col col-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                            <div class="col col-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                    <cf_wrk_members form_name='list_notice' member_name='company' company_id='company_id' select_list='2'>
                                    <input type="text" name="company" id="company" onkeyup="get_member();" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=list_notice.company&field_comp_id=list_notice.company_id&select_list=2&keyword='+encodeURIComponent(document.list_notice.company.value),'list');"></span>
                                </div>
                            </div>
                        </div>                    
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                        <div class="form-group" id="item-comp_id">
                            <label class="col col-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
                            <div class="col col-12">
                                <select name="comp_id" id="comp_id" onChange="showBranch(this.value)">
                                    <option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="get_our_company">
                                        <option value="#comp_id#"<cfif isdefined('attributes.comp_id') and attributes.comp_id eq comp_id>selected</cfif>>#company_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>                    
                    </div>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-12"><cf_get_lang dictionary_id="57453.Şube"></label>
                            <div class="col col-12">
                                <div width="150" id="BRANCH_PLACE">
                                    <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                                        <option value="all"><cfoutput>#getLang('main',322)#</cfoutput></option>
                                        <cfif isdefined("attributes.comp_id") and len(attributes.comp_id) and attributes.comp_id is not "all">
                                        <cfquery name="get_branch" datasource="#dsn#">
                                            SELECT * FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #attributes.comp_id# ORDER BY BRANCH_NAME
                                        </cfquery>
                                        <cfoutput query="get_branch"><option value="#branch_id#"<cfif isdefined('attributes.branch_id') and attributes.branch_id eq get_branch.branch_id>selected</cfif>>#branch_name#</option></cfoutput>
                                        </cfif>
                                    </select>
                                </div>
                            </div>
                        </div>                    
                    </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55174.İK İlanları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list> 
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></td>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='55761.İlan Başlığı'></th>
                    <th><cf_get_lang dictionary_id ='56510.İlan Grubu'></th>
                    <th><cf_get_lang dictionary_id='59004.Poziyon Tipi'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='57574.Sirket'></th>
                    <th><cf_get_lang dictionary_id='57501.Başlama'></th>
                    <th><cf_get_lang dictionary_id='57502.Bitiş'></th>
                    <th><cf_get_lang dictionary_id='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id ='56529.Başvuru Sayısı'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_notice&event=add"><i class="fa fa-plus" align="absbottom" title="<cf_get_lang_main no='170.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_notices.recordcount>
                    <cfoutput query="get_notices" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td width="20">#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#notice_id#" class="tableyazi">#NOTICE_NO#</a></td>
                            <td><a href="#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#notice_id#" class="tableyazi">#notice_head#</a></td>
                            <td><cfif len(NOTICE_CAT_ID)>
                                    #get_notice_groups_.NOTICE[listfind(notice_cat_list,get_notices.NOTICE_CAT_ID,',')]# 
                                    <cfelse>
                                    --
                                </cfif>
                            </td>
                            <td><!---TolgaS 20051208 position name ve position cat name de artık dbye atılıyor 90 dü sonra ona göre düzenlensin ifve querye gerek yok--->
                                <cfif len(get_notices.POSITION_CAT_ID) and not len(get_notices.POSITION_CAT_NAME)>
                                    <cfset attributes.POSITION_CAT_ID = POSITION_CAT_ID>
                                    <cfinclude template="../query/get_position_cat.cfm">
                                        #GET_POSITION_CAT.POSITION_CAT#
                                    <cfelse>
                                        #get_notices.POSITION_CAT_NAME#
                                </cfif> 
                            </td>
                            <td><cfif len(get_notices.POSITION_ID) and not len(get_notices.POSITION_NAME)>
                                    <cfquery name="get_position_name" datasource="#dsn#">
                                        SELECT
                                            EMPLOYEE_POSITIONS.POSITION_ID,
                                            EMPLOYEE_POSITIONS.POSITION_CODE,
                                            EMPLOYEE_POSITIONS.POSITION_NAME,
                                            EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                                            EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
                                        FROM
                                            EMPLOYEE_POSITIONS
                                        WHERE
                                            EMPLOYEE_POSITIONS.POSITION_CODE = #get_notices.POSITION_ID#
                                    </cfquery>
                                    #get_position_name.position_name# - #get_position_name.employee_name# #get_position_name.employee_surname#
                                    <cfelse>
                                    #get_notices.position_name#
                                </cfif>
                            </td>
                            <td><cfif len(get_notices.company_id)>
                                <cfquery name="get_company_name" datasource="#dsn#">
                                    SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #GET_NOTICES.COMPANY_ID#
                                </cfquery>
                                #get_company_name.fullname#
                                <cfelseif len(get_notices.department_id) and len(get_notices.branch_id) and len(get_notices.our_company_id)>
                                <cfquery name="get_branchs" datasource="#dsn#">
                                    SELECT 
                                        BRANCH.BRANCH_NAME,
                                        DEPARTMENT.DEPARTMENT_HEAD,
                                        OUR_COMPANY.NICK_NAME,
                                        OUR_COMPANY.COMPANY_NAME
                                    FROM 
                                        DEPARTMENT,
                                        BRANCH,
                                        OUR_COMPANY
                                    WHERE 
                                        OUR_COMPANY.COMP_ID=#get_notices.our_company_id# AND
                                        BRANCH.BRANCH_ID= #get_notices.branch_id# AND
                                        DEPARTMENT_ID = #get_notices.department_id#
                                </cfquery>
                                #get_branchs.nick_name#
                                <cfelse>
                                &nbsp;
                                </cfif>
                            </td>
                            <td><cfif len(get_notices.STARTDATE)>#dateformat(get_notices.STARTDATE,dateformat_style)#</cfif></td>
                            <td><cfif len(get_notices.FINISHDATE)>#dateformat(get_notices.FINISHDATE,dateformat_style)#</cfif></td>
                            <td><cfif get_notices.status eq 1>Aktif<cfelseif get_notices.status eq 0>Pasif</cfif></td>
                            <td align="center">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_notice_app_list&notice_id=#notice_id#','list');" class="tableyazi">
                                    #BASVURU_SAYISI#
                                </a>
                            </td>
                            <td><cfif len(record_emp)>
                                    <cfset attributes.employee_id = record_emp>
                                    <cfinclude template="../query/get_hr_name.cfm">
                                    #get_hr_name.employee_name# #get_hr_name.employee_surname#
                                    <cfset attributes.employee_id = "">
                                    Partner..
                                </cfif>
                            </td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                            <td width="20">	
                               <a href="#request.self#?fuseaction=hr.list_notice&event=upd&notice_id=#notice_id#"><i class="fa fa-pencil" title="<cf_get_lang_main no='52.Güncelle'>"></i></a>
                            </td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <cfif is_filtered><td colspan="14"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td><cfelse><td colspan="14"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td></cfif>
                        </tr>
                </cfif>
            </tbody>
        </cf_grid_list> 
        <cfset url_str = "">
        <cfset url_str = "#url_str#&status=#attributes.status#&status_notice=#attributes.status_notice#">
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
            <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
        </cfif>
        <cfif isdefined('attributes.comp_id') and len(attributes.comp_id)>
            <cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
        </cfif>
        <cfif isdefined('attributes.is_filtered')>
            <cfset url_str = "#url_str#&is_filtered=#attributes.is_filtered#">
        </cfif>
        <cfif len(attributes.startdate)>
            <cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finishdate)>
            <cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#">
        </cfif>
        <cfif isdefined('attributes.company') and len(attributes.company)>
            <cfset url_str = "#url_str#&company=#attributes.company#&company_id=#attributes.company_id#">
        </cfif>
        <cfif isdefined('attributes.department') and len(attributes.department)>
            <cfset url_str = "#url_str#&department=#attributes.department#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="hr.list_notice#url_str#">
    </cf_box>
</div>


<script type="text/javascript">
    	document.getElementById('keyword').focus();
		function showDepartment(branch_id)	
		{
			var branch_id = document.getElementById('branch_id').value;
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
		}
		function showBranch(comp_id)	
		{
			var comp_id = document.getElementById('comp_id').value;
			if (comp_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&comp_id="+comp_id;
				AjaxPageLoad(send_address,'BRANCH_PLACE',1,'<cf_get_lang no="684.İlişkili Şubeler">');
			}
			else {document.getElementById('branch_id').value = "";document.getElementById('department').value ="";}
			//departman bilgileri sıfırla
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id=0";
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'<cf_get_lang no="685.İlişkili Departmanlar">');
		}
    </script>
