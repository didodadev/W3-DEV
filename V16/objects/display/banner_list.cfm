<cfquery name="GET_WRK_APPS" datasource="#DSN#">
	SELECT 
		USERID,
		USER_TYPE,
        COMPANY_ID,
		NAME,
		SURNAME,
		POSITION_NAME,
		USER_IP,
		DOMAIN_NAME,
		ACTION_DATE,
		FUSEACTION,
		SESSIONID,
		IS_MOBILE,
		COMPANY_NICK
	FROM 
		WRK_SESSION 
	WHERE 
		USER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.user_type#">
	ORDER BY 
		DOMAIN_NAME,
        COMPANY_NICK,
		NAME,
		SURNAME
</cfquery>
<cf_medium_list>
	<!---CP ve PDA icin baslıklar direkt gelmeli--->
    <cfif attributes.user_type eq 3 or attributes.user_type eq 5>
        <thead>
            <tr>
				<cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                    <th width="18">&nbsp;</th>          
                </cfif>
                <th><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
                <th width="18">&nbsp;</th>
				<cfif attributes.user_type eq 0>
                    <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                <cfelseif attributes.user_type eq 2>
                    <th width="120"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th> 
                </cfif>
                    <th width="100"><cf_get_lang dictionary_id='32421.IP'></th>
                <cfif get_module_user(7)>
                    <cfif attributes.user_type eq 3><th width="250"><cf_get_lang dictionary_id='58031.Server Adı'></th></cfif>
                    <th><cf_get_lang dictionary_id='32418.Sistem Kullanımı'></th>
                </cfif>
            </tr>
        </thead>
    </cfif>
    <!--- EP --->
    <cfif attributes.user_type eq 0>
        <cfif get_wrk_apps.recordcount>
            <cfoutput query="get_wrk_apps" group="DOMAIN_NAME">	
                <thead>
                    <tr>
						<cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                            <th width="18">&nbsp;</th>          
                        </cfif>
                            <th><cf_get_lang dictionary_id='57930.Kullanıcı'>(#domain_name#)</th>
                            <th width="18">&nbsp;</th>
                        <cfif attributes.user_type eq 0>
                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                        <cfelseif attributes.user_type eq 2>
                            <th width="120"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th> 
                        </cfif>
                            <th width="100"><cf_get_lang dictionary_id='32421.IP'></th>
                        <cfif get_module_user(7)>
                            <th><cf_get_lang dictionary_id='32418.Sistem Kullanımı'></th>
                        </cfif>
                    </tr>
                </thead>
				<cfoutput group="COMPANY_NICK">
                    <tr class="total">
                        <td colspan="7" class="txtbold" valign="top" style="width:120px;">#COMPANY_NICK#</td>
                    </tr>
                    <cfoutput>
                        <tbody>
                            <tr>
                                <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                    <td align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#userid#&user_type=#user_type#&session_id=#sessionid#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                                </cfif>			  
                                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#userid#','medium');" class="tableyazi">#name# #surname#</a></td>
                                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#userid#','medium');"><img src="<cfif IS_MOBILE neq 1>/images/onlineuser.gif<cfelse>/images/mobil.gif</cfif>" border="0" title="<cf_get_lang dictionary_id='32857.Mesaj At'>"></a></td>
                                    <td nowrap>#position_name#</td>
                                    <td>#user_ip#</td>
                                <cfif get_module_user(7)>
                                    <td>#timeformat(date_add('h',session.ep.time_zone,action_date),timeformat_style)# - #fuseaction#</td>
                                </cfif>		 
                            </tr>
                        </tbody>
                    </cfoutput>
				</cfoutput>
            </cfoutput>
        <cfelse>
            <tr class="color-row">
                <td colspan="6" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>     
    <!--- PP --->
    <cfelseif attributes.user_type eq 1>
        <tbody>
			<cfif get_wrk_apps.recordcount>
                <cfoutput query="get_wrk_apps" group="DOMAIN_NAME">	
                    <cfif (get_wrk_apps.domain_name[currentrow] eq get_wrk_apps.domain_name[currentrow+1]) or (get_wrk_apps.domain_name[currentrow] neq get_wrk_apps.domain_name[currentrow+1])>
                        <thead>
                            <tr> 
                            <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                <th width="18">&nbsp;</th>          
                            </cfif>
                                <th><cf_get_lang dictionary_id='57930.Kullanıcı'>(#domain_name#)</th>
                                <th width="18">&nbsp;</th>
                            <cfif attributes.user_type eq 0>
                                <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                            <cfelseif attributes.user_type eq 2>
                                <th width="120"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th> 
                            </cfif>
                                <th width="100"><cf_get_lang dictionary_id='32421.IP'></th>
                            <cfif get_module_user(7)>
                                <th><cf_get_lang dictionary_id='32418.Sistem Kullanımı'></th>
                            </cfif>
                            </tr>
                        </thead>
                	</cfif>
                    <cfoutput group="COMPANY_NICK">
                            <tr class="total">
                                <td colspan="7" class="txtbold" valign="top" style="width:120px;">#COMPANY_NICK#</td>
                            </tr>
                        <cfoutput>
                            <cfif session.ep.admin>
                                <tr>
                                    <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                        <td align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#get_wrk_apps.userid#&user_type=#user_type#&session_id=#sessionid#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                                    </cfif>			 
                                        <td nowrap><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_wrk_apps.userid#','medium');" class="tableyazi">#get_wrk_apps.name# #get_wrk_apps.surname# (#get_wrk_apps.company_nick#)</a></td>
                                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&partner_id=#get_wrk_apps.userid#','medium');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang dictionary_id='32857.Mesaj At'>"></a></td>
                                        <td nowrap>#position_name#</td>
                                        <td nowrap>#get_wrk_apps.user_ip#</td>
                                    <cfif get_module_user(7)>
                                        <td>#timeformat(date_add('h',session.ep.time_zone,action_date),timeformat_style)# - #get_wrk_apps.fuseaction#</td>
                                    </cfif>
                                </tr>
                            <cfelse>
                                <tr>
                                    <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                        <td align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#get_wrk_apps.userid#&user_type=#user_type#&session_id=#sessionid#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                                    </cfif>			 
                                    <td nowrap><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_wrk_apps.userid#','medium');" class="tableyazi">#get_wrk_apps.name# #get_wrk_apps.surname# (#get_wrk_apps.company_nick#)</a></td>
                                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&partner_id=#get_wrk_apps.userid#','medium');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang dictionary_id='32857.Mesaj At'>"></a></td>
                                    <td nowrap>#get_wrk_apps.user_ip#</td>
                                    <cfif get_module_user(7)><td>#timeformat(date_add('h',session.ep.time_zone,action_date),timeformat_style)# - #get_wrk_apps.fuseaction#</td></cfif>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </cfoutput>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                </tr>
        	</cfif>
        </tbody>
    <!--- WW --->
    <cfelseif attributes.user_type eq 2>
        <cfset cons_list = listsort(listdeleteduplicates(valuelist(get_wrk_apps.userid,',')),'numeric','ASC',',')>
        <cfif len(cons_list)>
            <cfquery name="GET_CONS_CAT" datasource="#DSN#">
                SELECT CC.CONSCAT,C.CONSUMER_ID FROM CONSUMER C,CONSUMER_CAT CC WHERE C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND C.CONSUMER_ID IN(#cons_list#) ORDER BY C.CONSUMER_ID
            </cfquery>
            <cfset main_cons_list = listsort(listdeleteduplicates(valuelist(get_cons_cat.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <tbody>
            <cfif get_wrk_apps.recordcount>
                <cfoutput query="get_wrk_apps" group="DOMAIN_NAME">     
                    <cfif (get_wrk_apps.domain_name[currentrow] eq  get_wrk_apps.domain_name[currentrow+1]) or (get_wrk_apps.domain_name[currentrow] neq  get_wrk_apps.domain_name[currentrow+1])>
                        <thead>
                            <tr> 
                            <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                <th width="18">&nbsp;</th>          
                            </cfif>
                                <th><cf_get_lang dictionary_id='57930.Kullanıcı'>(#domain_name#)</th>
                                <th width="18">&nbsp;</th>
                            <cfif attributes.user_type eq 0>
                                <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                            <cfelseif attributes.user_type eq 2>
                                <th width="120"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></th> 
                            </cfif>
                                <th width="100"><cf_get_lang dictionary_id='32421.IP'></th>
                            <cfif get_module_user(7)>
                                <th><cf_get_lang dictionary_id='32418.Sistem Kullanımı'></th>
                            </cfif>
                            </tr>
                        </thead> 
                    </cfif>
                    <cfoutput group="COMPANY_NICK">
                            <tr class="total">
                                <td colspan="7" class="txtbold" valign="top" style="width:120px;">#COMPANY_NICK#</td>
                            </tr>
						<cfoutput>
                            <tr>
                                <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                    <td align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#get_wrk_apps.userid#&user_type=#user_type#&session_id=#SESSIONID#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                                </cfif>			 
                                    <td nowrap>#get_wrk_apps.name# #get_wrk_apps.surname#</td>
                                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&consumer_id=#get_wrk_apps.userid#','medium');"><img src="/images/onlineuser.gif"  border="0" title="<cf_get_lang dictionary_id='32857.Mesaj At'>"></a></td>
                                    <td><cfif listlen(cons_list)>#get_cons_cat.conscat[listfind(cons_list,userid,',')]#</cfif></td>
                                    <td>#get_wrk_apps.user_ip#</td>
                                <cfif get_module_user(7)>
                                    <td>#timeformat(date_add('h',session.ep.time_zone,get_wrk_apps.action_date),timeformat_style)# - #get_wrk_apps.fuseaction#</td>
                                </cfif>
                            </tr>
                        </cfoutput>
					</cfoutput>                        
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="6" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                </tr>
            </cfif>
        </tbody>
    <!--- CP --->
    <cfelseif attributes.user_type eq 3>
    	<cfoutput query="get_wrk_apps" group="COMPANY_NICK">
            <tr class="total">
                <td colspan="7" class="txtbold" valign="top" style="width:120px;">#COMPANY_NICK#</td>
            </tr>
            <tbody>
                <cfif get_wrk_apps.recordcount>
                	<cfoutput>
                        <tr>
							<cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                                <td align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#get_wrk_apps.userid#&user_type=#user_type#&session_id=#sessionid#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                            </cfif>			 
                                <td>#get_wrk_apps.name# #get_wrk_apps.surname#</td>
                                <td><img src="/images/onlineuser.gif"></td>
                                <td nowrap>#position_name#</td>
                                <td>#get_wrk_apps.user_ip#</td>
                            <cfif get_module_user(7)>
                                <cfif attributes.user_type eq 3><td>#get_wrk_apps.domain_name#</td></cfif>
                                <td>#timeformat(date_add('h',session.ep.time_zone,get_wrk_apps.action_date),timeformat_style)# - #get_wrk_apps.fuseaction#</td>
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="6" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                    </tr>
                </cfif>
            </tbody>
		</cfoutput>
    <!--- PDA --->
    <cfelseif attributes.user_type eq 5>
        <cfoutput query="get_wrk_apps" group="COMPANY_NICK">
            <tr class="total">
                <td colspan="7" class="txtbold" valign="top" style="width:120px;">#COMPANY_NICK#</td>
            </tr>
            <tbody>
                <cfif get_wrk_apps.recordcount>
                    <cfoutput>
                        <tr>
                        <cfif get_module_user(7) and not listfindnocase(denied_pages,'home.act_ban')>
                            <td width="17" align="center"><a href="#request.self#?fuseaction=home.act_ban&userid=#get_wrk_apps.userid#&user_type=#user_type#&session_id=#sessionid#"><img src="/images/killme.gif" align="absmiddle" title="<cf_get_lang dictionary_id='32921.Öldür beni'> !" border="0"></a></td>	
                        </cfif>			 
                            <td nowrap>#name# #surname#</td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#get_wrk_apps.userid#','medium');"><img src="/images/onlineuser.gif" border="0" title="<cf_get_lang dictionary_id='32857.Mesaj At'>"></a></td>
                            <td nowrap>#position_name#</td>
                            <td nowrap>#user_ip#</td>
                            <cfif get_module_user(7)><td>#timeformat(date_add('h',session.ep.time_zone,get_wrk_apps.action_date),timeformat_style)# - #fuseaction#</td></cfif>
                        </tr>
                    </cfoutput>            
                <cfelse>
                    <tr>
                        <td colspan="5" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                    </tr>
                </cfif>
            </tbody>
        </cfoutput>
    </cfif>
</cf_medium_list>
