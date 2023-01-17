<cfparam name="attributes.requirement_member_id" default="">
<cfparam name="attributes.requirement_partner_id" default="">
<cfparam name="attributes.requirement_consumer_id" default="">
<cfparam name="attributes.requirement_pos_code" default="">
<cfparam name="attributes.requirement_member_type" default="">
<cfparam name="attributes.requirement_name" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="get_form" datasource="#dsn#">
	SELECT
		*
	FROM
		PERSONEL_REQUIREMENT_FORM
	WHERE
		PERSONEL_REQUIREMENT_ID IS NOT NULL
		<cfif isdefined('attributes.our_company_id') and len(attributes.our_company) and len(attributes.our_company_id)>
		AND OUR_COMPANY_ID=#attributes.our_company_id#
		</cfif>
		<cfif isdefined('attributes.branch_id') and len(attributes.branch_name) and len(attributes.branch_id)>
		AND BRANCH_ID=#attributes.branch_id#
		</cfif>
		<cfif isdefined('attributes.department_id') and len(attributes.department_name) and len(attributes.department_id)>
		AND DEPARTMENT_ID=#attributes.department_id#
		</cfif>
		<cfif isdefined('attributes.position_id') and len(attributes.app_position) and len(attributes.position_id)>
		AND POSITION_ID=#attributes.position_id#
		</cfif>
		<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat) and len(attributes.position_cat_id)>
		AND POSITION_CAT_ID=#attributes.position_cat_id#
		</cfif>
		<cfif isdefined('attributes.requirement_member_id') and len(attributes.requirement_name) and attributes.requirement_member_type eq 'employee'>
			AND REQUIREMENT_EMP=#attributes.requirement_pos_code#
		<cfelseif  isdefined('attributes.requirement_partner_id') and len(attributes.requirement_name) and attributes.requirement_member_type eq 'partner'>
			AND REQUIREMENT_PAR_ID=#attributes.requirement_partner_id#
		<cfelseif  isdefined('attributes.requirement_consumer_id') and len(attributes.requirement_name) and attributes.requirement_member_type eq 'consumer'>
			AND REQUIREMENT_CONS_ID=#attributes.requirement_consumer_id#
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND PERSONEL_REQUIREMENT_HEAD LIKE '#attributes.keyword#%'
		</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_form.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<script type="text/javascript">
	function gonder(list_id,list_name)
	{
        <cfif not(isdefined("attributes.draggable"))>
            <cfif isdefined("attributes.field_id")>
                opener.<cfoutput>#field_id#</cfoutput>.value=list_id;
            </cfif>
            <cfif isdefined("attributes.field_name")>
                opener.<cfoutput>#field_name#</cfoutput>.value=list_name;
            </cfif>
            window.close();
        <cfelse>
             <cfif isdefined("attributes.field_id")>
               $("#<cfoutput>#attributes.field_id#</cfoutput>").val(list_id);
            </cfif>
            <cfif isdefined("attributes.field_name")>
                $("#<cfoutput>#attributes.field_name#</cfoutput>").val(list_name);
            </cfif>
            closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
        </cfif>
	}
</script>
<cfset url_str = "">
<cfif isdefined('attributes.field_id') and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined('attributes.field_name') and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" closable="1">
        <cfform name="search_form" action="#request.self#?fuseaction=hr.popup_personel_requirement#url_str#" method="post">
            <cf_box_search more="1">
                <div class="form-group" id="item-keyword">
                    <input type="text" name="keyword" id="keyword" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>" placeholder="<cfoutput>#getLang("","filtre",57460)#</cfoutput>">
                </div>
                <div class="form-group" id="item-our_company_id">
                    <div class="input-group" >
                        <input type="hidden" name="our_company_id" id="our_company_id" value="<cfif isdefined('attributes.our_company_id') and len(attributes.our_company)><cfoutput>#attributes.our_company_id#</cfoutput></cfif>">
                        <input type="text" name="our_company" placeholder="<cf_get_lang dictionary_id='57574.Şirket'>" id="our_company" value="<cfif isdefined('attributes.our_company_id') and len(attributes.our_company)><cfoutput>#attributes.our_company#</cfoutput></cfif>" style="width:100px;">
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_our_companies&field_name=search_form.our_company&field_id=search_form.our_company_id</cfoutput>','list');"></span>
                        <!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_our_company=search_form.our_company&field_our_company_id=search_form.our_company_id</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
                    </div>
                </div>
                <div class="form-group" id="item-branch_id">
                    <div class="input-group" >
                        <input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('attributes.branch_name') and len(attributes.branch_name)><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
                        <input type="text" name="branch_name" id="branch_name" value="<cfif isdefined('attributes.branch_name') and len(attributes.branch_name)><cfoutput>#attributes.branch_name#</cfoutput></cfif>" style="width:100px;">
                        <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_branch_id=search_form.branch_id&field_branch_name=search_form.branch_name</cfoutput>','list');"></span>
                    </div>
                </div>
                <div class="form-group small" id="item-maxrows">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group" id="item-button_type">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#">							
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="form-group" id="item-button_type">
                        <div class="input-group" >
                            <input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('attributes.department_name') and len(attributes.department_name)><cfoutput>#attributes.department_id#</cfoutput></cfif>">
                            <input type="text" name="department_name" placeholder="<cf_get_lang dictionary_id='57572.Departman'>" id="department_name" value="<cfif isdefined('attributes.department_name') and len(attributes.department_name)><cfoutput>#attributes.department_name#</cfoutput></cfif>" style="width:95px;">
                            <span  class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=search_form.department_id&field_name=search_form.department_name</cfoutput>','list');"></span>
                        </div>
                    </div>
                    <div class="form-group" id="item-button_type">
                        <div class="input-group" >
                            <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfif isdefined('attributes.position_cat') and len(attributes.position_cat)><cfoutput>#attributes.position_cat_id#</cfoutput></cfif>">
                            <input type="text" name="position_cat" placeholder="<cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>" id="position_cat" style="width:95px;" value="<cfif isdefined('attributes.position_cat') and len(attributes.position_cat)><cfoutput>#attributes.position_cat#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_cats&field_cat_id=search_form.position_cat_id&field_cat=search_form.position_cat','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="form-group" id="item-button_type">
                        <div class="input-group" >
                            <input type="hidden" name="position_id" id="position_id" value="<cfif isdefined('attributes.app_position') and len(attributes.app_position)><cfoutput>#attributes.position_id#</cfoutput></cfif>">
                            <input type="text" name="app_position" placeholder="<cf_get_lang dictionary_id='58497.Pozisyon'>" id="app_position" style="width:95px;"  value="<cfif isdefined('attributes.app_position') and len(attributes.app_position)><cfoutput>#attributes.app_position#</cfoutput></cfif>">
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=search_form.position_id&field_pos_name=search_form.app_position&show_empty_pos=1','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12 col-xs-12">
                    <div class="form-group" id="item-button_type">
                        <div class="input-group" >
                            
                            <input type="hidden" name="requirement_pos_code" id="requirement_pos_code" value="<cfif isdefined('attributes.requirement_pos_code') and len(attributes.requirement_pos_code)><cfoutput>#attributes.requirement_pos_code#</cfoutput></cfif>">
                            <input type="hidden" name="requirement_member_id" id="requirement_member_id" value="<cfif isdefined('attributes.requirement_member_id') and len(attributes.requirement_member_id)><cfoutput>#attributes.requirement_member_id#</cfoutput></cfif>">
                            <input type="hidden" name="requirement_partner_id" id="requirement_partner_id" value="<cfif isdefined('attributes.requirement_partner_id') and len(attributes.requirement_partner_id)><cfoutput>#attributes.requirement_partner_id#</cfoutput></cfif>">
                            <input type="hidden" name="requirement_consumer_id" id="requirement_consumer_id" value="<cfif isdefined('attributes.requirement_consumer_id') and len(attributes.requirement_consumer_id)><cfoutput>#attributes.requirement_consumer_id#</cfoutput></cfif>">
                            <input type="hidden" name="requirement_member_type" id="requirement_member_type" value="<cfif isdefined('attributes.requirement_member_type') and len(attributes.requirement_member_type)><cfoutput>#attributes.requirement_member_type#</cfoutput></cfif>">
                            <input type="text" name="requirement_name"  placeholder="<cf_get_lang dictionary_id='56219.İstekte Bulunan'>" id="requirement_name" value="<cfoutput>#attributes.requirement_name#</cfoutput>"  style="width:95px;">
                            <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1,2,3&field_code=search_form.requirement_pos_code&field_name=search_form.requirement_name&field_type=search_form.requirement_member_type&field_emp_id=search_form.requirement_member_id&field_partner=search_form.requirement_partner_id&field_consumer=search_form.requirement_consumer_id','list');"></span>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="50"><cf_get_lang dictionary_id='58820.Başlık'></th>
                    <th><cf_get_lang dictionary_id='57574.Sirket'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tip'></th>
                    <th><cf_get_lang dictionary_id='56205.Kadro Sayısı'></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_form.recordcount>
            <cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(get_form.position_id)>
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
                    EMPLOYEE_POSITIONS.POSITION_CODE = #get_form.position_id#
                </cfquery>
                <cfset app_position = "#get_position_name.position_name#   #get_position_name.employee_name# #get_position_name.employee_surname#">
                <cfelse>
                    <cfset app_position = "">
                </cfif>
                        
                <cfif len(get_form.position_cat_id)>
                    <cfset attributes.position_cat_id = get_form.position_cat_id>
                    <cfinclude template="../query/get_position_cat.cfm">
                    <cfset position_cat = "#GET_POSITION_CAT.POSITION_CAT#">
                <cfelse>
                    <cfset position_cat = "">
                </cfif>
                <cfif len(get_form.our_company_id)>
                    <cfquery name="get_dep" datasource="#dsn#">
                        SELECT 
                            BRANCH.BRANCH_NAME,
                            DEPARTMENT.DEPARTMENT_HEAD,
                            OUR_COMPANY.NICK_NAME
                        FROM 
                            DEPARTMENT,
                            BRANCH,
                            OUR_COMPANY
                        WHERE 
                            OUR_COMPANY.COMP_ID = #get_form.our_company_id# AND
                            BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
                            <cfif len(get_form.branch_id)>
                                AND BRANCH.BRANCH_ID = #get_form.branch_id#
                            </cfif>
                            <cfif len(get_form.department_id)>
                                AND DEPARTMENT_ID = #get_form.department_id#
                            </cfif>
                    </cfquery>
                </cfif>
                <tr>
                    <td><a href="javascript://" onClick="gonder('#get_form.personel_requirement_id#','#get_form.personel_requirement_head#')" class="tableyazi">#get_form.personel_requirement_head#</a></td>
                    <cfif len(get_form.our_company_id)>
                        <td>#get_dep.nick_name#</td>
                        <td>#get_dep.branch_name#</td>
                        <td>#get_dep.department_head#</td>
                    <cfelse>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                    </cfif>
                    <td><cfif len(get_form.position_id)>#app_position#</cfif></td>
                    <td><cfif len(get_form.position_cat_id)>#position_cat#</cfif></td>
                    <td>#get_form.personel_count#</td>
                </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                </tr>
            </cfif>
            </tbody>
        </cf_flat_list>
    </cf_box>
</div>
<cfif isdefined('attributes.requirement_name') and len(attributes.requirement_name)>
	<cfset url_str = "#url_str#&requirement_name=#attributes.requirement_name#">
</cfif>
<cfif isdefined('attributes.requirement_partner_id') and len(attributes.requirement_partner_id)>
	<cfset url_str = "#url_str#&requirement_partner_id=#attributes.requirement_partner_id#">
</cfif>
<cfif isdefined('attributes.requirement_consumer_id') and len(attributes.requirement_consumer_id)>
	<cfset url_str = "#url_str#&requirement_consumer_id=#attributes.requirement_consumer_id#">
</cfif>
<cfif isdefined('attributes.requirement_pos_code') and len(attributes.requirement_pos_code)>
	<cfset url_str = "#url_str#&requirement_pos_code=#attributes.requirement_pos_code#">
</cfif>
<cfif isdefined('attributes.our_company') and len(attributes.our_company)>
	<cfset url_str = "#url_str#&our_company=#attributes.our_company#&our_company_id=#attributes.our_company_id#">
</cfif>
<cfif isdefined('attributes.branch_name') and len(attributes.branch_name)>
	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#&branch_name=#attributes.branch_name#">
</cfif>
<cfif isdefined('attributes.department_name') and len(attributes.department_name)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#&department_name=#attributes.department_name#">
</cfif>
<cfif isdefined('attributes.requirement_emp') and len(attributes.requirement_emp)>
	<cfset url_str = "#url_str#&requirement_emp=#attributes.requirement_emp#&requirement_emp_id=#attributes.requirement_emp_id#">
</cfif>
<cfif isdefined('attributes.position_cat') and len(attributes.position_cat)>
	<cfset url_str = "#url_str#&position_cat=#attributes.position_cat#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif isdefined('attributes.app_position') and len(attributes.app_position)>
	<cfset url_str = "#url_str#&app_position=#attributes.app_position#&position_id=#attributes.position_id#">
</cfif>
<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
		<tr>
			<td> <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="hr.popup_personel_requirement#url_str#"> </td>
			<td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
