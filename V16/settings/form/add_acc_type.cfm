<!---
    <cf_wrk_grid search_header = "#getLang('settings',217)#" table_name="SETUP_ACC_TYPE" sort_column="ACC_TYPE_NAME" u_id="ACC_TYPE_ID" datasource="#dsn#" search_areas = "ACC_TYPE_NAME">
    <cf_wrk_grid_column name="ACC_TYPE_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="ACC_TYPE_NAME" required="true" header="#getLang('report',2054)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_SALARY_ACCOUNT" width="250" header="#getLang('settings',1810)#" type="boolean" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_PAYMENT_ACCOUNT" width="250" header="#getLang('main',792)#" type="boolean" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_EHESAP_USER" width="250" header="#getLang('report',208)#" type="boolean" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_HR_USER" width="250" header="#getLang('main',32)#" type="boolean" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
    </cf_wrk_grid>
--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Cari Hesap Tipleri','42200')#" add_href="#request.self#?fuseaction=settings.form_add_acc_type" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_acc_type.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="add_acc_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_acc_type">
				<cfif isdefined("attributes.acc_type_id")>
                    <cfquery name="get_acc_type" datasource="#dsn#">
                        SELECT *,#dsn#.Get_Dynamic_Language(ACC_TYPE_ID,'#session.ep.language#','SETUP_ACC_TYPE','ACC_TYPE_NAME',NULL,NULL,ACC_TYPE_NAME) AS acc_type_name_new FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = #attributes.acc_type_id#
                    </cfquery>
                    <cfset is_ehesap_user = get_acc_type.is_ehesap_user>
                    <cfset is_hr_user = get_acc_type.is_hr_user>
                    <cfset is_salary_account = get_acc_type.is_salary_account>
                    <cfset is_payment_account = get_acc_type.is_payment_account>
                    <cfset acc_type_name = get_acc_type.acc_type_name_new>
                    <input type="hidden" name="acc_type_id" id="acc_type_id" value="<cfoutput>#attributes.acc_type_id#</cfoutput>">
                <cfelse>
                    <cfset acc_type_name = ''>
                    <cfset is_ehesap_user = ''>
                    <cfset is_salary_account = ''>
                    <cfset is_payment_account = ''>
                    <cfset is_hr_user = ''>
                </cfif>
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-acc_type_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42200.Cari Hesap Tipleri'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='50326.Cari Hesap Girmelisiniz'> !</cfsavecontent>
                                    <cfinput type="Text" name="acc_type_name" style="width:150px" value="#acc_type_name#" maxlength="50" required="Yes" message="#message#">
                                    <cfif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id)>
                                        <span class="input-group-addon">
                                            <cf_language_info
                                            table_name="SETUP_ACC_TYPE"
                                            column_name="ACC_TYPE_NAME" 
                                            column_id_value="#attributes.acc_type_id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="ACC_TYPE_ID" 
                                            control_type="0">
                                        </span>
                                    </cfif>     
                                </div>              
                            </div>
                        </div>
                        <div class="form-group" id="item-is_salary_account">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label><input type="checkbox" name="is_salary_account" id="is_salary_account" value="" <cfif is_salary_account eq 1>checked</cfif>><cf_get_lang dictionary_id='61163.Maaş Hesabı'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_payment_account">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label><input type="checkbox" name="is_payment_account" id="is_payment_account" value="" <cfif is_payment_account eq 1>checked</cfif>><cf_get_lang dictionary_id='61279.Avans Hesabı'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_ehesap_user">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label><input type="checkbox" name="is_ehesap_user" id="is_ehesap_user" value="" onclick="kontrol_type(1);" <cfif is_ehesap_user eq 1>checked</cfif>><cf_get_lang dictionary_id='61280.E-Hesap Yetkisi'></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_hr_user">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <label><input type="checkbox" name="is_hr_user" id="is_hr_user" value="" onclick="kontrol_type(2);" <cfif is_hr_user eq 1>checked</cfif>><cf_get_lang dictionary_id='61281.İnsan Kaynakları Yetkisi'></label>
                            </div>
                        </div>
                        <cfif isdefined("attributes.acc_type_id")>
                            <cfscript>
                                acc_type_pos = createObject("component","V16.settings.cfc.setup_acc_type_pos");
                                acc_type_pos.dsn = dsn;
                                get_acc_type_pos = acc_type_pos.getTypePos(
                                acc_type_id:attributes.acc_type_id
                                );
                            </cfscript>	
                        </cfif>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
				        <cfif session.ep.ehesap> <!---üst düzey ik yetkisi olan kişi ekleyebilir--->
                            <div class="form-group col col-8">
                                <td valign="top" id="gizli1" colspan="3">
                                        <cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></cfsavecontent>
                                        <cfif isdefined("attributes.acc_type_id")>
                                        <cf_workcube_to_cc 
                                            is_update="1" 
                                            to_dsp_name="#txt_1#" 
                                            form_name="add_acc_type" 
                                            str_list_param="1" 
                                            action_dsn="#DSN#"
                                            str_action_names = "POSITION_ID TO_POS"
                                            str_alias_names = "TO_POS"
                                            action_table="SETUP_ACC_TYPE_POSID"
                                            action_id_name="ACC_TYPE_ID"
                                            data_type="2"
                                            action_id="#attributes.acc_type_id#">
                                        <cfelse>
                                        <cf_workcube_to_cc 
                                            is_update="0"
                                            to_dsp_name="#txt_1#" 
                                            form_name="add_acc_type" 
                                            str_list_param="1">
                                        </cfif>
                                    </td>
                                </div>
                        <cfelse>
                            <cfif isdefined("attributes.acc_type_id")>
                                <div class="form-group col col-8">
                                    <cf_flat_list>
                                        <thead>
                                            <tr>
                                                <th><cf_get_lang dictionary_id='42683.Yetkili Pozisyonlar'></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>
                                                <cfscript>
                                                    acc_type_pos = createObject("component","V16.settings.cfc.setup_acc_type_pos");
                                                    acc_type_pos.dsn = dsn;
                                                    get_acc_type_pos = acc_type_pos.getTypePos(
                                                                                        acc_type_id:attributes.acc_type_id
                                                                                        );
                                                </cfscript>	
                                                <cfoutput query="get_acc_type_pos">
                                                    #NAMESURNAME#<BR />
                                                </cfoutput>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </cf_flat_list>
                                </div>
                            </cfif>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cfif isdefined("attributes.acc_type_id")><cf_record_info query_name="get_acc_type"></cfif>
                    <cfif not isdefined('attributes.acc_type_id') or (session.ep.ehesap or (session.ep.ehesap neq 1 and not get_acc_type_pos.recordcount))>
                        <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                    </cfif>
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>
<script language="javascript">
	function kontrol_type(type)
	{
		if(type == 1 && document.add_acc_type.is_ehesap_user.checked == true)
			document.add_acc_type.is_hr_user.checked = false;
		if(type == 2 && document.add_acc_type.is_hr_user.checked == true)
			document.add_acc_type.is_ehesap_user.checked = false;
	}
</script>
