<!---
    File: setup_api_definitions.cfm
    Author: Özgür Barış Kayapınar <bariskayapinar@gmail.com>
    Date: 10.03.2019
    Controller:
    Description:
		Wodiba Gateway API bilgilerinin tanımlandığı ekran
--->

<cfscript>
    if(Not isDefined("attributes.form_submitted")){
        attributes.wdb_api_uri = '';
        attributes.wdb_api_username = '';
        attributes.wdb_api_password = '';
        attributes.wdb_api_server_id = '';
        attributes.wdb_emp_id = '';
        attributes.wdb_emp_name = '';
        attributes.wdb_start_date = '';
    }

    include "../cfc/Functions.cfc";

    if(isDefined("attributes.form_submitted")){

        if (attributes.company_id Neq session.ep.company_id) {
            writeOutput('<script type="text/javascript">alert("#getLang(dictionary_id=29456)#");history.back();</script>');
            abort;
        }

        if(Not isDefined('attributes.wdb_start_date')){
            attributes.wdb_start_date = '';
        }
        else{
            attributes.wdb_start_date = dateFormat(attributes.wdb_start_date,dateformat_style);
        }

        UpdateSettings(
            our_company_id: attributes.company_id,
            api_uri: attributes.wdb_api_uri,
            api_username: attributes.wdb_api_username,
            api_password: attributes.wdb_api_password,
            api_ip: attributes.wdb_api_server_id,
            emp_id: attributes.wdb_emp_id,
            start_date: attributes.wdb_start_date
        );
    }

    definitionDetail = GetSettings(our_company_id: session.ep.company_id);

    if(definitionDetail.recordcount){
       attributes.wdb_api_uri       = definitionDetail.WDB_API_URI;
       attributes.wdb_api_username  = definitionDetail.WDB_API_USERNAME;
       attributes.wdb_api_password  = definitionDetail.WDB_API_PASSWORD;
       attributes.wdb_api_server_id = definitionDetail.WDB_API_SERVER_IP;
       attributes.wdb_emp_id        = definitionDetail.WDB_EMP_ID;
       attributes.wdb_emp_name      = get_emp_info(definitionDetail.WDB_EMP_ID,0,0);
       attributes.wdb_start_date    = definitionDetail.WDB_START_DATE;
    };
</cfscript>

<cfset module_name = 'settings' />
<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='44094.WoDiBa API Tanımları'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />

<div>
    <div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze headerIsPopup">
        <span class="pageCaption font-green-sharp bold"><cf_get_lang dictionary_id='44094.WoDiBa API Tanımları'></span>
        <div id="pageTab" class="pull-right text-right">
            <nav class="detailHeadButton" id="tabMenu"></nav>
        </div>
    </div>
</div>
<cfoutput>
<form name="wdb_api_definition" id="wdb_api_definition" method="post" action="#request.self#?fuseaction=settings.popup_wodiba_api_definitions">
    <input type="hidden" name="form_submitted" value="1" />
    <input type="hidden" name="company_id" value="#session.ep.company_id#" />
     <div class="row">
         <div class="col col-12  uniqueRow">
            <div class="row formContent">
              <div class="row col-8" type="row">
                <div class="form-group" id="item-company">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                    <div class="col col-8 col-xs-12">#session.ep.company#</div>
                </div>
                <div class="form-group" id="item-api_uri">
                    <label class="col col-4 col-xs-12" for="wdb_api_uri">Api Url</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="wdb_api_uri" id="wdb_api_uri" style="width:65px" value="#attributes.wdb_api_uri#">
                    </div>
                </div>
                <div class="form-group" id="item-api_user_name">
                    <label class="col col-4 col-xs-12" for="wdb_api_username">Api Kullanıcı Adı</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="wdb_api_username" id="wdb_api_username" style="width:65px" value="#attributes.wdb_api_username#">
                    </div>
                </div>
                <div class="form-group" id="item-api_password">
                    <label class="col col-4 col-xs-12" for="wdb_api_password">Api Şifre</label>
                    <div class="col col-8 col-xs-12">
                        <input type="password" name="wdb_api_password" id="wdb_api_password" style="width:65px" value="#attributes.wdb_api_password#">
                    </div>
                </div>
                <div class="form-group" id="item-api_serverip">
                    <label class="col col-4 col-xs-12" for="wdb_api_server_id">Api Server IP</label>
                    <div class="col col-8 col-xs-12">
                        <input type="text" name="wdb_api_server_id" id="wdb_api_server_id" style="width:65px" value="#attributes.wdb_api_server_id#">
                    </div>
                </div>
                <div class="form-group" id="item-wdb_emp_name">
                    <label class="col col-4 col-xs-12" for="wdb_emp_name">WoDiBa Sistem Kullanıcısı</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="wdb_emp_id" id="wdb_emp_id" value="<cfif len(attributes.wdb_emp_id)>#attributes.wdb_emp_id#</cfif>">
                            <input type="text" name="wdb_emp_name" id="wdb_emp_name" value="<cfif len(attributes.wdb_emp_name)>#attributes.wdb_emp_name#</cfif>">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=wdb_api_definition.wdb_emp_name&field_emp_id=wdb_api_definition.wdb_emp_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-start_date">
                    <label class="col col-4 col-xs-12" for="wdb_start_date">Entegrasyon Başlangıç Tarihi</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="wdb_start_date" id="wdb_start_date" value="#dateformat(attributes.wdb_start_date,dateformat_style)#" />
                            <span class="input-group-addon"><cf_wrk_date_image date_field="wdb_start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                        </div>
                    </div>
                </div>
              </div>
              <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function="controlAddDefinition()">
                </div>
             </div>
            </div>
         </div>
     </div>
</form>
</cfoutput>

<script type="text/javascript">
    function controlAddDefinition()
        {
            if(!$("#wdb_api_uri").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: Api Url');
                $("#wdb_api_uri").focus();
                return false;	
            }
            if(!$("#wdb_api_username").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: Api Kullanıcı Adı');
                $("#wdb_api_username").focus();
                return false;	
            }
            if(!$("#wdb_api_password").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: Api Şifre');
                $("#wdb_api_password").focus();
                return false;	
            }
            if(!$("#wdb_api_server_id").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: Api Server IP');
                $("#wdb_api_server_id").focus();
                return false;	
            }
            if(!$("#wdb_emp_id").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: WoDiBa Sistem Kullanıcısı');
                $("#wdb_emp_name").focus();
                return false;	
            }
            if(!$("#wdb_start_date").val().length)
            {
                alert('<cf_get_lang_main no="782.girilmesi zorunlu alan">: Entegrasyon Başlangıç Tarihi');
                $("#wdb_start_date").focus();
                return false;	
            }
            return true;
        }
    $(document).keydown(function(e){
        // ESCAPE key pressed
        if (e.keyCode == 27) {
            window.close();
        }
    });
</script>