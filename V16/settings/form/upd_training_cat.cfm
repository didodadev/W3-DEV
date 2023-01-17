<cfinclude template="../query/get_language.cfm">
<cfinclude template="../query/get_training_cat_relations.cfm">
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='717.Eğitim Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;">
        <cfif listfirst(url.fuseaction,'.') is 'training_management'>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.form_add_training_cat&is_training_management=1"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang no='531.Eğitim Kategorisi Ekle'>"></a>
        <cfelse>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_training_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a>
        </cfif>
        </td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_training_cat.cfm"></td>
        <td>
            <table>
                <cfform name="zoneForm" method="post" action="#request.self#?fuseaction=settings.emptypopup_training_cat_upd">
                <cfquery name="CATEGORY" datasource="#dsn#">
               		SELECT 
        	            TRAINING_CAT_ID, 
                        TRAINING_CAT, 
                        DETAIL, 
                        TRAINING_LANGUAGE, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        UPDATE_DATE, 
                        UPDATE_EMP
                    FROM 
    	                TRAINING_CAT 
                    WHERE 
	                    TRAINING_CAT_ID=#URL.ID#
                </cfquery>
                <input type="hidden" name="TRAINING_CAT_ID" id="TRAINING_CAT_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                    <td width="100"><cf_get_lang_main no='74.Kategori'><font color="#000000">*</font></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='10.Kategori girmelisiniz'></cfsavecontent>
                        <cfinput required="Yes" message="#message#" type="Text" name="training_cat" size="30" value="#category.training_cat#" maxlength="75" style="width:150px;">
                        <cf_language_info 
                            table_name="TRAINING_CAT" 
                            column_name="TRAINING_CAT" 
                            column_id_value="#url.id#" 
                            maxlength="500" 
                            datasource="#dsn#" 
                            column_id="TRAINING_CAT_ID" 
                            control_type="0">
                    </td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='217.Açıklama'></td>
                    <td><cfinput type="text" name="DETAIL" style="width:150px;" value="#category.detail#"></td>
                </tr>
                <tr>
                    <td><cf_get_lang_main no='1584.Dil'></td>
                    <td>
                        <select name="LANGUAGE_ID" id="LANGUAGE_ID" style="width:150px;">
                            <cfoutput query="get_language">
                                <cfif category.TRAINING_LANGUAGE EQ LANGUAGE_ID>
                                    <option value="#LANGUAGE_ID#" selected>#LANGUAGE_SET#
                                <cfelse>
                                    <option value="#LANGUAGE_ID#">#LANGUAGE_SET#
                                </cfif>
                            </cfoutput>
                        </select>
                </tr>
                <tr height="35">
                    <td></td>
                    <td align="right" style="text-align:right;">
						<cfif get_training_sec_rel.recordcount>
                        	<cf_workcube_buttons is_upd='1' is_delete='0'>
                        <cfelse>
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_training_cat_del&training_cat_id=#url.id#&is_training_management=1'>
                        </cfif> 
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="2"><p><br/>
						<cfoutput>
                            <cfif len(category.RECORD_EMP)>
                                <cf_get_lang_main no='71.Kayit'> : #get_emp_info(category.RECORD_EMP,0,0)# - #dateformat(category.RECORD_DATE,dateformat_style)#
                            </cfif><br/>
                            <cfif len(category.UPDATE_EMP)>
                                <cf_get_lang_main no='291.Son Gncelleme'> : #get_emp_info(category.UPDATE_EMP,0,0)# - #dateformat(category.UPDATE_DATE,dateformat_style)#
                            </cfif>
                        </cfoutput>
                    </td>
                </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>

