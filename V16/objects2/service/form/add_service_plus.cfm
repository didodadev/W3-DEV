<cfinclude template="../query/get_com_method.cfm">
<cfform name="add_service_meet" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_service_plus">
    <table cellspacing="0" cellpadding="0" border="0" style="width:100%; height:100%;">
        <input type="Hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
        <input type="Hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
        <input type="Hidden" name="clicked" id="clicked" value="">
        <tr class="color-border">
          	<td style="vertical-align:top;">
            	<table cellspacing="1" cellpadding="2" border="0" style="width:100%; height:100%;">
              		<tr class="color-list" style="height:35px;">
                		<td class="headbold">
                			&nbsp;<cf_get_lang no='607.Takip'>
                        </td>
              		</tr>
              		<tr class="color-row">
                		<td style="vertical-align:top;">
                  			<table>
                    			<tr>
                      				<td>&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'>*&nbsp;
                        				<input type="text" name="header" id="header" style="width:275px;"  value="">
                        				<cfinput type="text" name="plus_date" id="plus_date" style="width:70px;" value="#dateformat(now(),'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="Tarih !" readonly>
                        				<select name="commethod_id" id="commethod_id" style="width:140px;">
                          					<option value="0" selected><cf_get_lang_main no='678.İletişim Yöntemi'></option>
                          					<cfoutput query="GET_COM_METHOD">
                                            <option value="#commethod_id#">#commethod#</option>
                                          </cfoutput>
                                        </select>
                                  	</td>
                                </tr>
                                <tr>
                      				<td style="vertical-align:top;">
                                    	<cfmodule template="../../../fckeditor/fckeditor.cfm"
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
                      				<td align="right" style="text-align:right;">
                        				<cf_workcube_buttons is_upd='0'>&nbsp;
                                    </td>
                    			</tr>
                  			</table>
                		</td>
              		</tr>
            	</table>
          	</td>
        </tr>
	</table>
</cfform>
