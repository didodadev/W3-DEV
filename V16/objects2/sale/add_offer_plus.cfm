<cfquery name="GET_OFFER_PLUS" datasource="#DSN3#">
	SELECT
		OFFER_ID,
        EMPLOYEE_ID
	FROM
		OFFER_PLUS
	WHERE
		OFFER_PLUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.offer_plus_id#">
</cfquery>

<cfform name="upd_offer_meet" method="post" action="#request.self#?fuseaction=objects2.popup_add_offer_plus">
    <input type="Hidden" name="clicked" id="clicked" value="">
    <input type="Hidden" name="offer_plus_id" id="offer_plus_id" value="<cfoutput>#offer_plus_id#</cfoutput>">
    <input type="Hidden" name="offer_id" id="offer_id" value="<cfoutput>#get_offer_plus.offer_id#</cfoutput>">
    <table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
        <tr class="color-list" style="height:35px;">
        	<td class="headbold">
        		&nbsp;&nbsp;<cf_get_lang no='239.Yazışma'>
        	</td>
        </tr>
      	<tr>
            <td style="vertical-align:top;">
                <table>
                    <tr>
                        <td>&nbsp;&nbsp;&nbsp;<cf_get_lang no='240.Bilgi Verilecek'></td>
                        <td>
                        	<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_offer_plus.employee_id#</cfoutput>">
                        	<cfif Len(get_offer_plus.employee_id)>
                        		<cfset attributes.employee_id = get_offer_plus.employee_id>
                        		<cfquery name="GET_EMPLOYEE_NAME" datasource="#DSN#">
                        			SELECT 
                                        EMPLOYEE_EMAIL,
                                        EMPLOYEE_NAME,
                                        EMPLOYEE_SURNAME
                        			FROM 
                        				EMPLOYEES
                        			WHERE
                        				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
                        		</cfquery>
                        		<input type="text" name="employee" id="employee" style="width:425px;" value="<cfoutput>#get_employee_name.employee_email#</cfoutput>">
                        	<cfelse>
                        		<input type="text" name="employee" id="employee" style="width:425px;" value="">
                        	</cfif>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>&nbsp;</td>
                        <td><input type="text" name="opp_head" id="opp_head" style="width:425px;" value="<cfif isdefined("get_offer_plus.subject")><cfoutput>#get_offer_plus.subject#</cfoutput></cfif>"></td>
                    </tr>
                    <tr>
                    	<td colspan="2">
                            <cfmodule template="/fckeditor/fckeditor.cfm"
                                toolbarset="Basic"
                                basepath="/fckeditor/"
                                instancename="plus_content"
                                valign="top"
                                value=""
                                width="550"
                                height="300">
                        </td>		
                    </tr>
                    <tr>
                        <td colspan="2" align="right">   
                            <cfsavecontent variable="message"><cf_get_lang no='1561.Kaydet ve E-posta Gönder'></cfsavecontent>
                            <cf_workcube_buttons 
                                is_upd='0'
                                insert_info='#message#'
                                is_cancel='0'
                                add_function="OnFormSubmit()&&control()"
                                insert_alert=''>          
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
	 function control()
	 {
		 document.getElementById('clicked').value='&email=true';
		 document.upd_offer_meet.action = document.upd_offer_meet.action + document.getElementById('clicked').value;
		 
		 var aaa = document.getElementById('employee').value;		 
		 if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == '&email=true'))
		 { 
				   alert("<cf_get_lang no='1072.Lütfen e-posta alanına geçerli bir e-posta giriniz'>!");
				   document.upd_offer_meet.action = "<cfoutput>#request.self#?fuseaction=objects2.popup_upd_offer_plus</cfoutput>";
				   return false;
		 }			  
		 return true;
	 }	 
</script>          
