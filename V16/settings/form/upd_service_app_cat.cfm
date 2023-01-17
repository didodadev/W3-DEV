<cfquery name="GET_SERVICE_CAT_ID" datasource="#DSN3#" maxrows="1">
	SELECT
		SERVICECAT_ID
	FROM
		SERVICE
	WHERE
		SERVICECAT_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td  class="headbold"><cf_get_lang no='650.Servis Başvuru Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_service_app_cat"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="100%" class="color-border">
    <tr class="color-row" valign="">
        <td width="200"><cfinclude template="../display/list_service_app_cat.cfm">
        </td>
        <td>
            <table border="0">
                <cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_service_app_cat_upd">
                    <cfquery name="CATEGORY" datasource="#dsn3#">
                        SELECT 
        	                SERVICECAT_ID, 
                            SERVICECAT, 
                            IS_INTERNET, 
                            RECORD_DATE, 
                            RECORD_EMP, 
                            RECORD_IP, 
                            UPDATE_DATE, 
                            UPDATE_EMP, 
                            UPDATE_IP 
                        FROM 
    	                    SERVICE_APPCAT 
                        WHERE 
	                        SERVICECAT_ID=#URL.ID#
                    </cfquery>
                    <input type="hidden" name="serviceCat_ID" id="serviceCat_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                    <tr>
                        <td></td>
                        <td><input type="checkbox" name="is_internet" id="is_internet" value="1" <cfif category.is_internet eq 1>checked</cfif>><cf_get_lang no='1673.Herkes Görsün'></td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang no='20.Kategori Adı'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1143.Kategori Adı girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="serviceCat" size="60" value="#category.serviceCat#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                        </td>
                    </tr>
                    <tr height="25">
                        <td colspan="2" align="right" style="text-align:right;">
							<cfif get_service_cat_id.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_service_app_cat_del&servicecat_id=#URL.ID#'>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="left">
							<cfoutput>
								<cfif len(category.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(category.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>

