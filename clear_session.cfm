<script type="text/javascript" src="JS/js_functions.js"></script>

<cfform name="clear_session" method="post" action="#request.self#?fuseaction=home.emptypopup_clear_session">
    <input type="hidden" name="user_type" id="user_type" value="<cfoutput>#attributes.user_type#</cfoutput>"> 
	<div class="login_content">   
        <div class="login-middle">
            <cfif attributes.user_type eq 1>   
                <div class="input-group">
                    <span class="icon">  
                        <cfinput type="text" name="member_code" id="member_code" value="" required="yes" placeholder="#getLang('main',146)#"  message="#getLang('main',146)#" passthrough="autocomplete=off" maxlength="50">
                    </span>
                </div>                  
            </cfif>
            <div class="input-group">
                <label><cfoutput>#getLang('main',139)#</cfoutput></label>
                 <cfinput type="text" name="username" id="username" class="input_cont" value="" required="yes"  message="#getLang('main',139)#" passthrough="autocomplete=off" maxlength="50">
            </div> 
            <div class="input-group">
                <label><cfoutput>#getLang('main',140)#</cfoutput></label>
                <cfinput type="password" name="password" id="password" class="input_cont" value="" required="yes" message="#getLang('main',140)#" passthrough="autocomplete=off" maxlength="50">
            </div>
            <div class="loginError"> <cf_get_lang_main no='1882.Sistemde ayni kullanici adi ve sifresiyle acilmis oturum kapatilacaktir'></div> 
        </div>
        <div class="form-buttons"> 
            <div class="login-links">          
                <a href="javascript:void(0)" id="sessionControl" onClick="window.parent.togglePanel('firstLogin')"><cf_get_lang_main no='20.geri'></a>
            </div>
            <div class="login"> 
            <button id="buttonpassword" class="btn btn-red" value="" onClick="AjaxFormSubmit('clear_session','sessionControlDiv',1,'Güncelleniyor','Güncellendi');"/>
                 <cf_get_lang_main no='2187.Oturumu Kurtar'> 
            </button>
            </div>  
        </div>
        <div id="sessionControlDiv" style="display:none;"></div>
         
        <div class="ui_social">
            <ul>
                <li>
                    <a data-original-title="facebook" href="https://www.facebook.com/Workcube.ERP"><i class="fab fa-facebook-f"></i></a>
                </li>
                <li>
                    <a data-original-title="Twitter" href="https://twitter.com/workcube"><i class="fab fa-twitter"></i></a>
                </li>
                <li>
                    <a data-original-title="Youtube" href="https://www.youtube.com/user/workcubecom"><i class="fab fa-youtube"></i></a>
                </li>
                <!--- <li>
                    <a data-original-title="Google Plus" href="https://plus.google.com/+workcube-erp"><i class="fa fa-google-plus"></i></a>
                </li> --->
                <li>
                    <a data-original-title="Linkedin" href="https://www.linkedin.com/company/workcube"><i class="fab fa-linkedin-in"></i></a>
                </li>
            </ul>
        </div>
        </div>
</cfform>