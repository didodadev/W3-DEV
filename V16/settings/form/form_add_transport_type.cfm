
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='44817.Ulaşım Yöntemleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_transport_type">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_transport_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_add_hr_transport_type" method="post" name="know_level">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="transport_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45122.Ulaşım Yöntemi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='29483.Ulaşım Yöntemi Giriniz'>!</cfsavecontent>
                                <cfinput type="text" name="transport_type" size="30" value="" maxlength="150" required="Yes" message="#message#">
							</div>	
						</div>
						<div class="form-group" id="item-branch_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfquery name="get_branchs" datasource="#DSN#">
                                    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
                                </cfquery>
                                <select name="branch_id" id="branch_id">
                                    <option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
                                    <cfoutput query="get_branchs">
                                        <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
							</div>	
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="transport_type_detail" id="transport_type_detail" cols="60" rows="2"></textarea>
							</div>	
						</div>
					</div>
				</cf_box_elements>
    	</div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        	<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
            </div>
        </cfform>
  	</cf_box>
</div>










<!---
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td class="headbold"><cfif not isdefined("attributes.upper")><cf_get_lang no='3137.Ulaşım Yöntemi'><cfelse><cf_get_lang no='2839.Ulaşım Türü'></cfif></td>
    </tr>
</table>
<table  width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
    <tr class="color-row">
        <td width="300" valign="top">
    
        </td>
        <td class="color-row" valign="top">
            <table>
                <cfform action="#request.self#?fuseaction=settings.emptypopup_add_hr_transport_type" method="post" name="know_level">
                    <cfif not isdefined("attributes.upper")>
                        <tr>
                            <td><cf_get_lang no='2839.Ulaşım Türü'></td>
                            <td>
                                <select name="upper_transport_type_id" id="upper_transport_type_id">
                                    <cfoutput query="get_uppers">
                                        <option value="#transport_type_id#">#transport_type#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                    
                        <tr>
                            <td><cf_get_lang_main no='41.Şube'></td>
                            <td>
                                <cfquery name="get_branchs" datasource="#DSN#">
                                    SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH ORDER BY BRANCH_NAME
                                </cfquery>
                                <select name="branch_id" id="branch_id">
                                    <option value=""><cf_get_lang no='773.Şube Seçiniz'></option>
                                    <cfoutput query="get_branchs">
                                        <option value="#BRANCH_ID#">#BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr> 
                    </cfif>                
                    <tr>
                        <td width="100" valign="top"><cf_get_lang no='3137.Ulaşım Yöntemi'> *</td>
                        <td valign="top">
                            <cfsavecontent variable="message"><cf_get_lang_main no='1686.Ulaşım Tipi girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" name="transport_type" size="30" value="" maxlength="150" required="Yes" message="#message#" style="width:200px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='26.Ayrıntı'></td>
                        <td>
                            <textarea name="transport_type_detail" id="transport_type_detail" cols="60" rows="2" style="width:200px;height:50px;"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td height="35"><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
--->