<cfset get_cmp = createObject("component","V16.report.standart.cfc.ban") />
<cfset GET_FAILED_LOGINS = get_cmp.GET_FAILED_LOGINS(
    user_name: attributes.user_name
)>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box closable="1" collapsable="1" title="#getLang('','ban tarihçe','63928')#"  popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_box_elements>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57487.No'></th>
                        <th><cf_get_lang dictionary_id='57551.Kullanıcı Adı'></th>
                        <th><cf_get_lang dictionary_id='29921.Kullanıcı IP'></th>
                        <th><cf_get_lang dictionary_id='63929.Son Giriş Tarihi'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_FAILED_LOGINS">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#USER_NAME#</td>
                            <td>#USER_IP#</td>
                            <td>#dateFormat(LOGIN_DATE,dateformat_style)#-#timeFormat(LOGIN_DATE,timeformat_style)#</td>
                            <cfif isdefined("attributes.status") and (attributes.status eq 0 or not len(attributes.status))>
                                <td style="width:210px;">#get_emp_info(OPEN_BAN_USER_EMP,0,1)#</td>
                                <td style="width:250px;">#dateFormat(OPEN_BAN_DATE,dateformat_style)#-#timeFormat(OPEN_BAN_DATE,timeformat_style)#</td>
                            </cfif>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box_elements>
    </cf_box>
</div>