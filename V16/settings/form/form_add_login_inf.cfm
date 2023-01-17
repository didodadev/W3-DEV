<cfquery name="get_security_login_inf" datasource="#dsn#">
    SELECT
        IS_ACTIVE,
        LOGIN_COUNT
    FROM
        SECURITY_LOGIN_CONTROL
</cfquery>
<cfsavecontent variable="head"><cf_get_lang no='70.Giriş Kontrol Sistemi'></cfsavecontent>
<cf_box title="#head#" uidrop="1" hide_table_column="1" responsive_table="1">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_add_login_inf" method="post" name="form1">
        <cf_box_elements>
            <div class="row">
                <div class="col col-12 form-inline">
                    <div class="form-group">
                        <div class="input-group">
                            <input type="hidden" name="is_upd" id="is_upd"  value="<cfoutput>#get_security_login_inf.recordcount#</cfoutput>">
                            <label class="col col-12"><cf_get_lang_main no='344.Durum'></label>
                        </div>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <label class="col col-12"><cf_get_lang_main no='81.Aktif'></label>
                            <input type="checkbox" name="IS_ACTIVE" id="ACTIVE" <cfif get_security_login_inf.recordcount and get_security_login_inf.IS_ACTIVE eq 1>checked="true"</cfif> />
                        </div>
                    </div>   
                    <div class="form-group">
                        <div class="input-group">
                            <label class="col col-12"><cf_get_lang no='203.Maksimum Hatalı Giris Sayisi'></label>
                            <select style="width:50px;" name="login_count" id="login_count">
                            <cfoutput>
                                <cfloop index="count" from="3" to="10">
                                    <option value="#count#" <cfif get_security_login_inf.recordcount and get_security_login_inf.LOGIN_COUNT eq count>selected="true"</cfif>>#count#</option>
                                </cfloop>
                            </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
            </div>               
        </cf_box_elements>
        <cf_box_footer>
            <cfif get_security_login_inf.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_add_login_inf&is_delete=1'>
            <cfelse>
                <cf_workcube_buttons is_upd='0'>
            </cfif>
        </cf_box_footer> 
    </cfform>
</cf_box>
<script>
    $(".catalyst-eye").hide();
    $(".catalyst-share-alt").hide()
</script>

