<cfset login_cfc = createObject("component", "V16.hr.ehesap.cfc.mypdks_info")>
<cfset login_cfc.dsn = dsn/>
<cfset last_login = login_cfc.get_last_login()>
<cf_box_elements>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <div class="form-group">
        <label class="col col-12 col-xs-12 bold"><cf_get_lang dictionary_id='31608.İşyerine geldiğinizde giriş butonuna, ara verdiğinizde veya çıkış yaptığınızda çıkış butonuna basmayı unutmayın!'></label>
    </div>
</div>
<div class="col col-12 col-md-12 col-sm-12  col-xs-12">
    <div class="form-group"> 
         <cfif len(last_login.finish_date)>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-4">
                    <a href="javascript://" onclick="login_logout('login_')" class="ui-wrk-btn ui-wrk-btn-success ui-wrk-btn-addon-left"><i class="fa fa-sign-in"></i><cf_get_lang dictionary_id='57554.Giriş'></a>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                <label class="bold"><cf_get_lang dictionary_id='29398.Son'><cf_get_lang dictionary_id='57431.Çıkış'>: </label>
                    <label><cfoutput>#dateFormat(last_login.finish_date,dateformat_style)# #timeFormat(last_login.finish_date,timeformat_style)#</cfoutput></label>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                <cfoutput><a target="_blank" href="https://www.google.com/maps/place/#last_login.out_coordinate1#,#last_login.out_coordinate2#/@#last_login.out_coordinate1#,#last_login.out_coordinate2#,21z" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>"><img height="25" src="css/assets/icons/catalyst-icon-svg/google-maps.svg" alt=""></a></cfoutput>
            </div>
        <cfelseif not len(last_login.finish_date)>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-4">
                <a href="javascript://" onclick="login_logout('logout_')" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left"><i class="fa fa-sign-out"></i><cf_get_lang dictionary_id='57431.Çıkış'></a>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-6">
                <label class="bold"><cf_get_lang dictionary_id='29398.Son'><cf_get_lang dictionary_id='57554.Giriş'>: </label>
                <label><cfoutput>#dateFormat(last_login.start_date,dateformat_style)# #timeFormat(last_login.start_date,timeformat_style)#</cfoutput></label>
                <cfscript>
                    fromDate = lsParseDateTime("#last_login.start_date#", "English (UK)", "dd/MM/yyyy hh:mm");
                    toDate = lsParseDateTime("#now()#", "English (UK)", "dd/MM/yyyy hh:mm");
                    totalMinutes = datediff("n", fromDate, toDate);
                    days = int(totalMinutes /(24 * 60)) ;
                    minutesRemaining = totalMinutes - (days * 24 * 60);
                    hours = int(minutesRemaining / 60);
                    minutes = minutesRemaining mod 60;
                </cfscript>
                <label style="color:#1dc293"><cf_get_lang dictionary_id='65474.İşyerinde Geçirilen Süre'>: </label>
                <label style="color:#1dc293"><cfoutput>#days# <cf_get_lang dictionary_id='57490.Gün'> #hours# <cf_get_lang dictionary_id='57491.Saat'> #minutes# <cf_get_lang dictionary_id='58127.Dakika'></cfoutput></label>
            </div>
            <div class="col col-2 col-md-2 col-sm-2 col-xs-2">
                <cfoutput><a target="_blank" href="https://www.google.com/maps/place/#last_login.in_coordinate1#,#last_login.in_coordinate2#/@#last_login.in_coordinate1#,#last_login.in_coordinate2#,21z" title="<cf_get_lang dictionary_id='58849.Haritada Göster'>"><img height="25" src="css/assets/icons/catalyst-icon-svg/google-maps.svg" alt=""></a></cfoutput>
            </div>
        </cfif>
    </div>
</div>
</cf_box_elements>
<script type="text/javascript">
function login_logout(type) {
    const errorFunc = (e) => {
        <!--- console.error(e); console.error(e.message); --->
        if(e.code === 1 || e.message === 'User denied Geolocation'){
            var lat = 0;
            var lng = 0;
            console.log("İzin verilmedi")
        }
    };
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function (p) {
            var LatLng = new google.maps.LatLng(p.coords.latitude, p.coords.longitude);
            <cfset login_cfc = createObject("component", "V16.hr.ehesap.cfc.mypdks_info")>
            <cfset login_cfc.dsn = dsn/>
            <cfset last_login = login_cfc.get_last_login()>
            var lat = p.coords.latitude;
            var lng = p.coords.longitude;

            fetch("/V16/hr/ehesap/cfc/mypdks_info.cfc?method=add_login&row_id=<cfoutput>#last_login.row_id#</cfoutput>&type="+type+"&dsn=<cfoutput>#login_cfc.dsn#</cfoutput>&coordinate1="+lat+"&coordinate2="+lng, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                },
            }).then(response => {
                if (response.ok) {
                    response.text().then(response => {
                       if (type == 'login_') alert('<cf_get_lang dictionary_id='57554.Giriş'> <cf_get_lang dictionary_id='55387.Başarılı'>');
                       else  alert('<cf_get_lang dictionary_id='57431.Çıkış'> <cf_get_lang dictionary_id='55387.Başarılı'>');
                        refresh_box('mypdks','index.cfm?fuseaction=myhome.emptypopup_list_mypdks_info','1');
                       // location.href= document.referrer;
                        return true;
                    });

                }
                else 
                {
                    alert('İşlem hatalı');
                    return false;
                }
            });
        }, errorFunc);
    } else {
        alert('Tarayıcınız konum özelliğini desteklemiyor.');
    }
}
   
</script>