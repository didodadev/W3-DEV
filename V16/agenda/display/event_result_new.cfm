<!---E.A 17.07.2012 select ifadeleri düzenlendi--->
<cfinclude template="../query/get_event.cfm">
<cfquery name="get_result" datasource="#DSN#">
	SELECT 
		EVENT_RESULT_EMP,
		EVENT_RESULT_PARTNER,
		EVENT_RESULT_CONS,
		EVENT_RESULT_WRKGROUP,
		EVENT_RESULT_CC_EMP,
		EVENT_RESULT_CC_PARTNER,
		EVENT_RESULT_CC_CONS,
		locked,
		EVENT_RESULT,
		record_emp,
		update_emp,
		record_date,
		update_date
	FROM 
		EVENT_RESULT 
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.event_id#">
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 6
</cfquery>
<cfquery name="SETUP_TEMPLATE" datasource="#dsn#">
	SELECT TEMPLATE_CONTENT FROM TEMPLATE_FORMS
	<cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
	WHERE
		TEMPLATE_ID = #attributes.template_id#
	</cfif>
</cfquery>
<cfif (get_result.recordcount eq 0) and  not (isdefined("url.struct_del") or isdefined("url.struct_del_cc"))>
  <cfset "session.agenda.event#url.event_id#.joinss" = "">
  <cfset "session.agenda.event#url.event_id#.specss"= "">
  <cfif len(get_event.EVENT_TO_POS)>
    <cfloop list="#get_event.EVENT_TO_POS#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"emp-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_TO_PAR)>
    <cfloop list="#get_event.EVENT_TO_PAR#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"par-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_TO_CON)>
    <cfloop list="#get_event.EVENT_TO_CON#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"con-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_TO_GRP)>
    <cfloop list="#get_event.EVENT_TO_GRP#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"grp-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_TO_WRKGROUP)>
    <cfloop list="#get_event.EVENT_TO_WRKGROUP#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"wrk-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_CC_POS)>
    <cfloop list="#get_event.EVENT_CC_POS#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"empcc-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_CC_PAR)>
    <cfloop list="#get_event.EVENT_CC_PAR#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"parcc-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_event.EVENT_CC_CON)>
    <cfloop list="#get_event.EVENT_CC_CON#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"concc-#i#")>
    </cfloop>
  </cfif>
<cfelseif get_result.recordcount and  not (isdefined("url.struct_del") or isdefined("url.struct_del_cc"))>
  <cfset "session.agenda.event#url.event_id#.joinss" = "">
  <cfset "session.agenda.event#url.event_id#.specss"= "">
  <cfif len(get_result.EVENT_RESULT_EMP)>
    <cfloop list="#get_result.EVENT_RESULT_EMP#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"emp-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_result.EVENT_RESULT_PARTNER)>
    <cfloop list="#get_result.EVENT_RESULT_PARTNER#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"par-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_result.EVENT_RESULT_CONS)>
    <cfloop list="#get_result.EVENT_RESULT_CONS#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"con-#i#")>
    </cfloop>
  </cfif>
   <cfif len(get_result.EVENT_RESULT_WRKGROUP)>
    <cfloop list="#get_result.EVENT_RESULT_WRKGROUP#" index="i">
      <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"wrk-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_result.EVENT_RESULT_CC_EMP)>
    <cfloop list="#get_result.EVENT_RESULT_CC_EMP#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"empcc-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_result.EVENT_RESULT_CC_PARTNER)>
    <cfloop list="#get_result.EVENT_RESULT_CC_PARTNER#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"parcc-#i#")>
    </cfloop>
  </cfif>
  <cfif len(get_result.EVENT_RESULT_CC_CONS)>
    <cfloop list="#get_result.EVENT_RESULT_CC_CONS#" index="i">
      <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"concc-#i#")>
    </cfloop>
  </cfif>
</cfif>
<!--- <cfsavecontent variable="img_">
 <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#url.event_id#&print_type=440</cfoutput>','page');"><img src="/images/print.gif" border="0" alt="<cf_get_lang_main no='62.Yazdır'>" title="<cf_get_lang_main no='62.Yazdır'>"></a>
</cfsavecontent> ---><!--- print işlemi cf_box a alınmış--->
<cfform name="event_result" action="#request.self#?fuseaction=agenda.emptypopup_event_result" method="post">
  <input type="hidden" name="header" id="header" value="<cfoutput>#get_event.event_head#</cfoutput>">
    <div class="col col-8 col-xs-12" style="margin-top:5px;">
      <cf_box title="#getLang('main',179)#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.event_id#&print_type=440">
        <div class="row">
          <div class="form-inline">
            <div class="form-group">
              <label class="col col-1 col-xs-12"><input type="checkbox" name="locked" id="locked" value="1" <cfif get_result.locked eq 1>checked</cfif>></label>
              <label class="col col-4 col-xs-12"><cf_get_lang_main no='1448.Kilitle'></label>
            </div>
            <div class="form-group">
              <div class="col col-12 col-xs-12">
                <select name="template_id" id="template_id" style="width:150px;" onchange="_load(this.value);">
                    <option value="" selected><cf_get_lang_main no ='1228.Şablon'>
                  <cfoutput query="get_cat">
                    <option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#TEMPLATE_HEAD# </option>
                  </cfoutput>
                </select>
              </div>
            </div> 
          </div>
          <div class="form-group">
            <cfset tr_topic = get_result.EVENT_RESULT>
            <cfif isdefined("attributes.corrcat_id")>
              <cfset tr_topic = SETUP_TEMPLATE.TEMPLATE_CONTENT>
            </cfif>
            <cfmodule
              template="/fckeditor/fckeditor.cfm"
              toolbarSet="Basic"
              basePath="/fckeditor/"
              instanceName="RESULT"
              value="#tr_topic#"
              width="650"
              height="400">
              <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#url.event_id#</cfoutput>">
          </div>
        </div>
        <div class="row formContentFooter">
          <cf_record_info query_name="get_result">
          <cfif get_result.locked neq 1 or (get_result.locked eq 1 and (get_result.record_emp eq session.ep.userid or get_result.update_emp eq session.ep.userid))>
            <cfif get_result.recordcount>
              <cfsavecontent variable="message"><cf_get_lang no ='89.Güncelle ve Mail Gönder'></cfsavecontent>
              <cfelse>
              <cfsavecontent variable="message"><cf_get_lang no ='92.Kaydet ve Mail Gönder'></cfsavecontent>
            </cfif>
            <cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function='control()'  insert_alert=''>				  
            <cfif get_result.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete="0">
              <cfelse>	
                <cf_workcube_buttons is_upd='0'>
            </cfif>
          </cfif>
        </div>
      </cf_box>
    </div>
    <div class="col col-4 col-xs-12" style="margin-top:5px;">
      <input type="hidden" name="joins" id="joins">
      <input type="hidden" name="specs" id="specs">
      <input type="hidden" name="tos" id="tos" value="">
      <input type="hidden" name="ccs" id="ccs" value="">
      <cf_get_workcube_asset asset_cat_id="-20" module_id='6' action_section='EVENT_ID' action_id='#attributes.event_id#'>
      <cf_box title="#getLang('main',178)#">
        <cfsavecontent variable="txt_2"><b><cf_get_lang_main no='178.Katılımcılar'></b></cfsavecontent>
        <cf_workcube_to_cc 
          is_update="0"
          to_dsp_name="#txt_2#" 
          form_name="event_result" 
          str_list_param="1,7,8" 
          data_type="1">
          <div id="td_joins"><!--- katılımcılar ---></div>
          <table>
            <tbody id="gizli1">
                <!--- katılımcılar --->
                <cfset attributes.partner_ids="">
                <cfset attributes.employee_ids="">
                <cfset attributes.consumer_ids="">
                <cfset attributes.group_ids="">
                <cfset attributes.wrk_group_ids="">
                <cfset attributes.struct_del="struct_del">
                <cfloop list="#evaluate('session.agenda.event#url.event_id#.joinss')#" index="i" delimiters=",">
                    <cfif i contains "par">
                        <cfset attributes.partner_ids = LISTAPPEND(attributes.partner_ids,LISTGETAT(I,2,"-"))>
                    </cfif>
                    <cfif i contains "emp">
                        <cfset attributes.employee_ids = LISTAPPEND(attributes.employee_ids,LISTGETAT(I,2,"-"))>
                    </cfif>
                    <cfif i contains "con">
                        <cfset attributes.consumer_ids = LISTAPPEND(attributes.consumer_ids,LISTGETAT(I,2,"-"))>
                    </cfif>
                    <cfif i contains "grp">
                        <cfset attributes.group_ids = LISTAPPEND(attributes.group_ids,LISTGETAT(I,2,"-"))>
                    </cfif>
                    <cfif i contains "wrk">
                        <cfset attributes.wrk_group_ids = LISTAPPEND(attributes.wrk_group_ids,LISTGETAT(I,2,"-"))>
                    </cfif>
                </cfloop>
                <cfif len(attributes.PARTNER_IDS)>
                    <cfinclude template="../query/get_partners.cfm">
                    <cfoutput query="GET_PARTNERS">
                      <tr><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_joins&id=par-#partner_id#&event_id=#url.event_id#&struct_del=#attributes.struct_del#','small');"><i class="fa fa-minus"></i></a> </td><td>#company_partner_name# #company_partner_surname#</td></tr>
                    </cfoutput>
                </cfif>
                <cfif len(attributes.EMPLOYEE_IDS)>
                    <cfquery name="GET_EMPLOYEES" datasource="#dsn#">
                        SELECT 
                            EMPLOYEE_ID,
                            EMPLOYEE_NAME, 
                            EMPLOYEE_SURNAME
                        FROM 
                            EMPLOYEE_POSITIONS
                        WHERE
                            EMPLOYEE_ID IN (#attributes.EMPLOYEE_IDS#)
                            AND IS_MASTER=1
                    </cfquery>
                    <cfoutput query="GET_EMPLOYEES">
                      <tr><td> <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_joins&id=emp-#employee_id#&event_id=#url.event_id#&struct_del=#attributes.struct_del#','small');"><i class="fa fa-minus" alt="İşçi İsmi"></i></a></td><td> #employee_name# #employee_surname#</td></tr>
                    </cfoutput>
                </cfif>
                <cfif len(attributes.consumer_ids)>
                    <cfinclude template="../query/get_consumers.cfm">
                    <cfoutput query="GET_CONSUMERS">
                      <tr><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_joins&id=con-#CONSUMER_ID#&event_id=#url.event_id#&struct_del=#attributes.struct_del#','small');"><i class="fa fa-minus" alt="Şirket ismi"></i></a></td> <td>#CONSUMER_NAME# #CONSUMER_SURNAME#</td></tr>
                    </cfoutput>
                </cfif>
                <cfif len(attributes.group_ids)>
                    <cfinclude template="../query/get_groups.cfm">
                    <cfoutput query="GET_GROUPS">
                      <tr> <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_joins&id=grp-#GROUP_ID#&event_id=#url.event_id#&struct_del=#attributes.struct_del#','small');"><i class="fa fa-minus" alt="Grup İsmi"></i></a></td><td> #GROUP_NAME#</td></tr>
                    </cfoutput>
                </cfif>
                <cfif len(attributes.wrk_group_ids)>
                    <cfinclude template="../query/get_wrkgroups.cfm">
                    <cfoutput query="get_wrkgroups">
                      <tr><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_joins&id=wrk-#WORKGROUP_ID#&event_id=#url.event_id#&struct_del=#attributes.struct_del#','small');"><i class="fa fa-minus" alt="Çalışma Grubu İsmi"></i></a></td> <td>#WORKGROUP_NAME#</td></tr>
                    </cfoutput>
                </cfif>
              </tbody>
            </table>
      </cf_box>
      <cf_box title="#getLang('agenda',16)#">
        <cf_ajax_list>
          <cfsavecontent variable="txt_3"><cf_get_lang no ='16.Bilgi Verilecekler'></cfsavecontent>
          <cf_workcube_to_cc 
            is_update="0"
            cc_dsp_name="#txt_3#" 
            form_name="event_result" 
            str_list_param="1,7,8" 
            data_type="1">
            <div id="td_joins_cc"><!---Bilgi Verilecekler---></div>
            <table>
                <tbody id="gizli2">
                  <cfset attributes.PARTNER_CC_IDS="">
                  <cfset attributes.EMPLOYEE_CC_IDS="">
                  <cfset attributes.CONSUMER_CC_IDS="">
                  <cfset attributes.struct_del_cc="struct_del_cc">
                  <cfloop list="#evaluate('session.agenda.event#url.event_id#.specss')#" index="x" delimiters=",">
                      <cfif x contains "parcc">
                          <cfset attributes.partner_cc_ids = LISTAPPEND(attributes.PARTNER_CC_IDS,LISTGETAT(X,2,"-"))>
                      </cfif>
                      <cfif x contains "empcc">
                          <cfset attributes.employee_cc_ids = LISTAPPEND(attributes.EMPLOYEE_CC_IDS,LISTGETAT(X,2,"-"))>
                      </cfif>
                      <cfif x contains "concc">
                          <cfset attributes.consumer_cc_ids = LISTAPPEND(attributes.CONSUMER_CC_IDS,LISTGETAT(X,2,"-"))>
                      </cfif>
                  </cfloop>
                  <cfif len(attributes.employee_cc_ids)>
                      <cfquery name="GET_EMPLOYEES_CC" datasource="#dsn#">
                          SELECT 
                              EMPLOYEE_ID,
                              EMPLOYEE_NAME, 
                              EMPLOYEE_SURNAME
                          FROM 
                              EMPLOYEE_POSITIONS
                          WHERE
                              EMPLOYEE_ID IN (#attributes.EMPLOYEE_CC_IDS#)
                              AND IS_MASTER=1
                      </cfquery>
                      <cfoutput query="GET_EMPLOYEES_CC">
                        <tr><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_specs&id=empcc-#EMPLOYEE_ID#&event_id=#url.event_id#&struct_del_cc=#attributes.struct_del_cc#','small');"><i class="fa fa-minus"></i></a></td><td> #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td></tr>
                      </cfoutput>
                  </cfif>
                  <cfif len(attributes.partner_cc_ids)>
                      <cfquery name="GET_PARTNERS_CC" datasource="#dsn#">
                          SELECT 
                              PARTNER_ID,
                              COMPANY_PARTNER_NAME,
                              COMPANY_PARTNER_SURNAME
                          FROM 
                              COMPANY_PARTNER
                          WHERE
                              COMPANY_PARTNER_STATUS = 1
                          <cfif isDefined("attributes.COMPANYCAT_ID")>
                              AND
                              COMPANYCAT_ID = #attributes.COMPANYCAT_ID#
                          <cfelseif isDefined("attributes.PARTNER_CC_IDS")>
                              AND
                              PARTNER_ID IN (#attributes.PARTNER_CC_IDS#)
                          </cfif>
                      </cfquery>
                      <cfoutput query="GET_PARTNERS_CC">
                      <tr> <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_specs&id=parcc-#partner_id#&event_id=#url.event_id#&struct_del_cc=#attributes.struct_del_cc#','small');"><i class="fa fa-minus"></i></a></td><td> #company_partner_name# #company_partner_surname#</td></tr>
                      </cfoutput>
                  </cfif>
                  <cfif len(attributes.CONSUMER_CC_IDS)>
                      <cfquery name="GET_CONSUMERS_CC" datasource="#dsn#">
                          SELECT 
                              CONSUMER_ID,
                              CONSUMER_NAME,
                              CONSUMER_SURNAME
                          FROM 
                              CONSUMER
                          WHERE
                              CONSUMER_STATUS = 1
                          <cfif isDefined("attributes.CONSUMER_CAT_ID")>
                              AND
                              CONSUMER_CAT_ID = #attributes.CONSUMER_CAT_ID#
                          <cfelseif isDefined("attributes.CONSUMER_CC_IDS")>
                              AND
                              CONSUMER_ID IN (#attributes.CONSUMER_CC_IDS#)
                          </cfif>
                      </cfquery>
                      <cfoutput query="GET_CONSUMERS_CC">
                      <tr><td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=agenda.emptypopup_del_specs&id=concc-#consumer_id#&event_id=#url.event_id#&struct_del_cc=#attributes.struct_del_cc#','small');"><i class="fa fa-minus"></i></a> </td><td>#CONSUMER_NAME# #CONSUMER_SURNAME#</td></tr>
                      </cfoutput> 
                  </cfif>
                </tbody>
            </table>
        </cf_ajax_list>
      </cf_box>
    </div>
</cfform>
<script type="text/javascript">
  $( document ).ready(function() {
    $("#tbl_to_names").append( $("#gizli1"));
    $("#tbl_to_names").html($("#gizli1").html());

    $("#tbl_cc_names").append( $("#gizli2"));
    $("#tbl_cc_names").html($("#gizli2").html());
});

	<cfif isdefined("attributes.template_id") and len(attributes.template_id)>
		document.event_result.RESULT.value = '<cfoutput>#SETUP_TEMPLATE.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>
 	<cfoutput>
		event_result.joins.value = '#evaluate("session.agenda.event#url.event_id#.joinss")#';
		event_result.specs.value = '#evaluate("session.agenda.event#url.event_id#.specss")#';
	</cfoutput>
	function control()
	{ 
		document.event_result.action = "<cfoutput>#request.self#?fuseaction=agenda.emptypopup_event_result&event_id=#url.event_id#&email=true</cfoutput>";
		return true;
	}
	function _load(template_id)
	{
		var template_id=document.event_result.template_id.value;
		if(template_id != null)
			window.open('<cfoutput>#request.self#?fuseaction=agenda.popup_event_result&event_id=#url.event_id#</cfoutput>&template_id='+template_id,'_self')
		else 
			return false;
	}
</script>
