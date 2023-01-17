<cf_xml_page_edit fuseact="settings.form_add_user_group">
<cfinclude template="../query/get_user_groups.cfm">
<cfinclude template="../query/get_modules.cfm">
<div class="row">
    <div class="divBox-Head text-center"><cf_get_lang no='161.Yetki Grupları'></div>
    <div class="profile-usermenu">    
        <ul class="navBox scroll-md">
			<cfif get_user_groups.recordcount>
				<cfoutput query="get_user_groups">        
                    <li><a onclick="spaPageLoad('#request.self#?fuseaction=settings.form_add_user_group&spa=1&event=upd&ID=#user_group_ID#','userGroup','#attributes.fuseaction#','upd',1,1)" href="javascript://"> #user_group_name#</a> <span class="badge pull-right">#USER_COUNT#</span></li>     
                </cfoutput>
			<cfelse>
                <li class="font-red-flamingo"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></li>  
            </cfif>
        </ul>
    </div>
</div>