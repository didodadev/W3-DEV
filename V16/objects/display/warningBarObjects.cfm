<link href="/css/assets/template/message.css" rel="stylesheet">
    <div id="mySidenav" class="sidenav">
      <a href="javascript://" class="closebtn" onclick="closeNav()">&times;</a>
        <div class="col col-12 col-md-12 col-xs-12" style="padding-right:3px !important;">
        <cf_tab defaultOpen="#attributes.divid#" divId="chat_page,warning_page" divLang="#getLang('settings',859)#;#getLang('agenda',8)#" tabcolor="fff">
            <cf_box id="chat_page" uniquebox_height="100%" style="height:100%;box-shadow:none;" box_page="#request.self#?fuseaction=objects.popup_message&employee_id=#attributes.employee_id#"></cf_box>
            <cf_box id="warning_page" style="box-shadow:none;" box_page="#request.self#?fuseaction=#attributes.fuseact#"></cf_box>
        </cf_tab>
        </div>
    </div>
  

   