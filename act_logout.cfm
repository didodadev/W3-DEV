<cftry>
	<!--- ürün seri rezerve kullanılıyorsa sistemden çıkısta herhangi işlemle ilişkilendirilmemiş rezerveler silinir  --->
	<cfif fusebox.use_stock_speed_reserve>
		<!---<cfquery name="del_order_r" datasource="#dsn#">
			DELETE FROM #dsn3_alias#.ORDER_ROW_RESERVED WHERE PRE_ORDER_ID IS NOT NULL AND PRE_ORDER_ID='#CFTOKEN#' 
		</cfquery>--->
         <cfstoredproc procedure="DEL_ORDER_ROW_RESERVED" datasource="#dsn3#">
            <cfprocparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#">
        </cfstoredproc>
	</cfif>
	<cfcatch></cfcatch>
</cftry>
<cftry>
	<!--- basketten eklenmiş ama belgesi kaydedilmemiş seri nolar silinir  --->
	<cfif isdefined("session.ep.userid")>
		<cfquery name="del_order_r" datasource="#dsn#">
			DELETE FROM #dsn3_alias#.SERVICE_GUARANTY_NEW WHERE WRK_ROW_ID IS NOT NULL AND PROCESS_ID = 0 AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		</cfquery>
	</cfif>
	<cfcatch></cfcatch>
</cftry>

<cfquery name="del_wrk_session" datasource="#dsn#">
	DELETE FROM WRK_SESSION WHERE 
	<cfif isdefined("session.ep.userid")>
		USERID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	<cfelse>
		CFTOKEN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFTOKEN#"> AND CFID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CFID#">
	</cfif>
	AND USER_TYPE = 0
	AND (IS_MOBILE IS NULL OR IS_MOBILE = 0)
</cfquery>
<cfif isdefined("session.ep.userid")>
	<cfquery name="ADD_LAST_LOGIN" datasource="#DSN#">
		INSERT INTO 
			WRK_LOGIN
		(
			SERVER_MACHINE,
			DOMAIN_NAME,
			EMPLOYEE_ID,
			IN_OUT,
			IN_OUT_TIME,
			LOGIN_IP
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		)
	</cfquery>
    <!--- kullanıcı giriş konumu db'ye atılıyor --->
    <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
    <cfset get_api_key = googleapi.get_api_key()>
    <cfif isDefined("get_api_key.GOOGLE_API_KEY") and len(get_api_key.GOOGLE_API_KEY)>
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>"></script>
        <script type="text/javascript">
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
                    <cfset login_cfc = createObject("component", "WMO.login")>
                    <cfset login_cfc.dsn = dsn/>
                    <cfset last_login = login_cfc.get_last_login()>
                    var lat = p.coords.latitude;
                    var lng = p.coords.longitude;

                    fetch("/WMO/login.cfc?method=add_user_login_coord&dsn=<cfoutput>#login_cfc.dsn#</cfoutput>&login_id=<cfoutput>#last_login.login_id#</cfoutput>&coordinate1="+lat+"&coordinate2="+lng, {
                        method: 'GET',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        },
                    }).then(response => {
                        if (response.ok) {
                            response.text().then(response => {
                                console.log(response);
                                console.log("<cfoutput>#last_login.login_id#</cfoutput>");
                            });
                        }
                    });
                }, errorFunc);
            } else {
                alert('Tarayıcınız konum özelliğini desteklemiyor.');
            }
        </script>
    </cfif>
    <!--- //kullanıcı giriş konumu db'ye atılıyor --->
</cfif>

<cfif isdefined("session")>
	<cfloop collection=#session# item="key_field">
		<cfscript>
		if((key_field neq 'error_text') and (key_field neq 'plevne'))
            StructDelete(session, key_field);
		</cfscript>
	</cfloop>
	<cfcookie name="JSESSIONID" expires="now">
</cfif>
<cfif isdefined("attributes.secure_control")>
    <cfsavecontent variable="session.error_text"><cf_get_lang_main no="2144.Yaptığınız Saldırılardan Dolayı Uzaklaştırıldınız Sistem Yöneticinize Başvurunuz"></cfsavecontent>
</cfif>
<script>
    setTimeout(() => {
        window.location.href = '<cfoutput>#request.self#?fuseaction=home.login</cfoutput>';
    }, "3000");
</script>
<!--- <cflocation url="#request.self#?fuseaction=home.login" addtoken="No"> --->