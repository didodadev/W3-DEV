<cfif isdefined("session.pp.userid")>
	<cfset url.event_id = Decrypt(url.event_id,session.pp.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.event_id = Decrypt(attributes.event_id,session.pp.userid,"CFMX_COMPAT","Hex")>
<cfelseif isdefined("session.ww.userid")>
	<cfset url.event_id = Decrypt(url.event_id,session.ww.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.event_id = Decrypt(attributes.event_id,session.ww.userid,"CFMX_COMPAT","Hex")>
</cfif>
<cfinclude template="../query/get_event.cfm">
<cfquery name="GET_RESULT" datasource="#DSN#">
	SELECT 
		EVENT_RESULT_CC_EMP,
		EVENT_RESULT_CC_PARTNER,
		EVENT_RESULT_CC_CONS,* 
	FROM 
		EVENT_RESULT 
	WHERE 
		EVENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.event_id#">
</cfquery>
<cfif (get_result.recordcount eq 0) and  not (isdefined("url.struct_delete") or isdefined("url.struct_delete_cc"))>
  	<cfset "session.agenda.event#url.event_id#.joinss" = "">
  	<cfset "session.agenda.event#url.event_id#.specss"= "">
  	<cfif len(get_event.event_to_pos)>
        <cfloop list="#get_event.event_to_pos#" index="i">
          <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"emp-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_to_par)>
        <cfloop list="#get_event.event_to_par#" index="i">
          <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"par-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_to_con)>
        <cfloop list="#get_event.event_to_con#" index="i">
          <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"con-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_to_grp)>
		<cfloop list="#get_event.event_to_grp#" index="i">
      		<cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"grp-#i#")>
    	</cfloop>
  	</cfif>
  	<cfif len(get_event.event_to_wrkgroup)>
        <cfloop list="#get_event.event_to_wrkgroup#" index="i">
          	<cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"wrk-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_cc_pos)>
        <cfloop list="#get_event.event_cc_pos#" index="i">
          	<cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"empcc-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_cc_par)>
        <cfloop list="#get_event.event_cc_par#" index="i">
            <cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"parcc-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_event.event_cc_con)>
        <cfloop list="#get_event.event_cc_con#" index="i">
          	<cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"concc-#i#")>
        </cfloop>
  	</cfif>
<cfelseif get_result.recordcount and  not (isdefined("url.struct_delete") or isdefined("url.struct_delete_cc"))>
  	<cfset "session.agenda.event#url.event_id#.joinss" = "">
  	<cfset "session.agenda.event#url.event_id#.specss"= "">
  	<cfif len(get_result.event_result_emp)>
        <cfloop list="#get_result.event_result_emp#" index="i">
			<cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"emp-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_result.event_result_partner)>
    	<cfloop list="#get_result.event_result_partner#" index="i">
      		<cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"par-#i#")>
    	</cfloop>
  	</cfif>
  	<cfif len(get_result.event_result_cons)>
        <cfloop list="#get_result.event_result_cons#" index="i">
            <cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"con-#i#")>
        </cfloop>
  	</cfif>
   	<cfif len(get_result.event_result_wrkgroup)>
        <cfloop list="#get_result.event_result_wrkgroup#" index="i">
          	<cfset "session.agenda.event#url.event_id#.joinss"=listappend(evaluate("session.agenda.event#url.event_id#.joinss"),"wrk-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_result.event_result_cc_emp)>
        <cfloop list="#get_result.event_result_cc_emp#" index="i">
          	<cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"empcc-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_result.event_result_cc_partner)>
        <cfloop list="#get_result.event_result_cc_partner#" index="i">
          	<cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"parcc-#i#")>
        </cfloop>
  	</cfif>
  	<cfif len(get_result.event_result_cc_cons)>
        <cfloop list="#get_result.event_result_cc_cons#" index="i">
          	<cfset "session.agenda.event#url.event_id#.specss"=listappend(evaluate("session.agenda.event#url.event_id#.specss"),"concc-#i#")>
        </cfloop>
  	</cfif>
</cfif>
<cf_popup_box title="#getLang('objects2',179)#"><!---Olay tutanağı--->
	<cfform name="event_result" action="#request.self#?fuseaction=objects2.emptypopup_event_result" method="post">
        <input type="hidden" name="header" id="header" value="<cfoutput>#get_event.event_head#</cfoutput>">
        <table>
            <tr>
                <td>
                    <cfset tr_topic = get_result.event_result>
                    <cfif isdefined("attributes.corrcat_id")>
                        <cfset tr_topic = setup_template.template_content>
                    </cfif>
                    <cfmodule
                        template="../../../fckeditor/fckeditor.cfm"
                        toolbarSet="Basic"
                        basePath="/fckeditor/"
                        instanceName="RESULT"
                        value="#tr_topic#"
                        width="550"
                        height="350">
                    <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#url.event_id#</cfoutput>">
                </td>
            </tr>
            <tr>
            	<td><input type="checkbox" name="is_email" id="is_email" value="1" /> <cf_get_lang no='193.E-posta Gönder'></td>
            </tr>
        </table>
        <cf_popup_box_footer>
        	<cf_record_info query_name="get_result">
            <cfif isdefined('attributes.is_butons') and attributes.is_butons eq 1>
                <cfsavecontent variable="message"><cf_get_lang no='1561.Kaydet ve E-posta Gönder'></cfsavecontent>
                <!---<cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function='control()' insert_alert=''>	--->			  
                <cf_workcube_buttons is_upd='1' is_delete='1' add_function='control()'>
            </cfif>
        </cf_popup_box_footer>
        <input type="hidden" name="joins" id="joins">
        <input type="hidden" name="specs" id="specs">
        <input type="hidden" name="tos" id="tos" value="">
        <input type="hidden" name="ccs" id="ccs" value="">
    </cfform>
</cf_popup_box>
<script type="text/javascript">
 	<cfoutput>
		document.getElementById('joins').value = '#evaluate("session.agenda.event#url.event_id#.joinss")#';
		document.getElementById('specs').value = '#evaluate("session.agenda.event#url.event_id#.specss")#';
	</cfoutput>
	function control()
	{ 
		document.event_result.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_event_result"; 
		var aaa = document.getElementById('joins').value;
		var bbb = document.getElementById('specs').value;
		if (aaa == '' && bbb == '')
		{ 
			alert("<cf_get_lang no='198.Katılımcı Veya Bilgi Verilecek Seçmediniz ya da Seçtiklerinizin E-posta Adresleri Yok'>!!");
			document.event_result.action = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_event_result</cfoutput>";
			return false;
		}
		return true;
	}
</script>
