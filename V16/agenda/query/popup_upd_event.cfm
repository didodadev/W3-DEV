<cfinclude template="upd_dates.cfm">
<cfif isdefined('attributes.is_google_cal') and attributes.is_google_cal eq 1>
    <script async defer src="https://apis.google.com/js/api.js"></script>
    <script>
        <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
        <cfset get_api_key = googleapi.get_api_key()>
        if(<cfoutput>#len(get_api_key.GOOGLE_API_KEY)#</cfoutput> > 10 && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_ID)#</cfoutput> > 10 && <cfoutput>#len(get_api_key.GOOGLE_CLIENT_SECRET)#</cfoutput> > 10){
            var CLIENT_ID = '<cfoutput>#get_api_key.GOOGLE_CLIENT_ID#</cfoutput>';
            var CLIENT_SECRET = '<cfoutput>#get_api_key.GOOGLE_CLIENT_SECRET#</cfoutput>';
            var API_KEY = '<cfoutput>#get_api_key.GOOGLE_API_KEY#</cfoutput>';

            // Array of API discovery doc URLs for APIs used by the quickstart
            var DISCOVERY_DOCS = ["https://www.googleapis.com/discovery/v1/apis/calendar/v3/rest"];
            var GoogleAuth;
            // Authorization scopes required by the API; multiple scopes can be
            // included, separated by spaces.
            var SCOPES = "https://www.googleapis.com/auth/calendar.readonly https://www.googleapis.com/auth/calendar";

            /**
            *  On load, called to load the auth2 library and API client library.
            */
            function handleClientLoad() {
                gapi.load('client:auth2', initClient);
            }

            /**
            *  Initializes the API client library and sets up sign-in state
            *  listeners.
            */
            function initClient() {
                gapi.client.init({
                apiKey: API_KEY,
                clientId: CLIENT_ID,
                clientSecret: CLIENT_SECRET,
                discoveryDocs: DISCOVERY_DOCS,
                scope: SCOPES
                }).then(function () {
                    GoogleAuth = gapi.auth2.getAuthInstance();
                    // Giriş aşaması
                    GoogleAuth.isSignedIn.listen(updateSigninStatus);
                    updateSigninStatus(GoogleAuth.isSignedIn.get());
                    if (GoogleAuth.isSignedIn.get() == false){
                        GoogleAuth.signIn();
                    }
                    
                }, function(error) {
                    /* console.log(error.details); */
                    alert("<cf_get_lang dictionary_id='29917.Hata Oluştu'>");
                });
            }

            function updateSigninStatus(isSignedIn) {
                if (isSignedIn) {
                    var user = GoogleAuth.currentUser.get();
                    var isAuthorized = user.hasGrantedScopes(SCOPES);
                    if(isAuthorized){
                        updateEvent();
                    }else{
                        GoogleAuth.signOut();
                    }
                } else {
                    alert("<cf_get_lang dictionary_id='64111.Google Hesabınızla Giriş Yapmalısınız!'>");
                }
            }

            handleClientLoad();

            function updateEvent() {
                var eventStartTime = '<cfoutput>#DatePart("yyyy", attributes.startdate)#</cfoutput>'+"-"+'<cfoutput>#DatePart("m", attributes.startdate)#</cfoutput>'+"-"+'<cfoutput>#DatePart("d", attributes.startdate)#</cfoutput>'+"T"+"<cfoutput>#attributes.event_start_clock#</cfoutput>"+":"+"<cfoutput>#attributes.event_start_minute#</cfoutput>"+":00.000";
                var eventFinishTime = '<cfoutput>#DatePart("yyyy", attributes.finishdate)#</cfoutput>'+"-"+'<cfoutput>#DatePart("m", attributes.finishdate)#</cfoutput>'+"-"+'<cfoutput>#DatePart("d", attributes.finishdate)#</cfoutput>'+"T"+"<cfoutput>#attributes.event_finish_clock#</cfoutput>"+":"+"<cfoutput>#attributes.event_finish_minute#</cfoutput>"+":00.000";
                var timeZone = "<cfoutput>#server.system.properties.user.timezone#</cfoutput>";

                return gapi.client.calendar.events.update({
                    "calendarId": "primary",
                    "eventId": "<cfoutput>#attributes.googleEventId#</cfoutput>",
                    "resource": {
                        'summary': '<cfoutput>#attributes.event_head#</cfoutput>',
                        'location': '<cfoutput>#attributes.event_place#</cfoutput>',
                        'description': '<cfoutput>#EncodeForHTML(attributes.event_detail)#</cfoutput>',
                        'start': {
                            'dateTime': eventStartTime,
                            'timeZone': timeZone
                        },
                        'end': {
                            'dateTime': eventFinishTime,
                            'timeZone': timeZone
                        }
                    }
                })
                    .then(function(response) {
                            /* console.log("Response", response); */
                            console.log("Güncellendi...");
                        },
                        function(err) { console.error("Execute error", err);});
            }
        }
        
    </script>
</cfif>
<cfif (link_id is "") and (not isdefined("warning") or (warning eq 0))>
<!--- tek olayı tek olarak güncelle --->
	<cfinclude template="upd_event.cfm">
<cfelseif (link_id is "") and (not isdefined("warning") or (warning eq 1))>
<!--- tek olayı cogalt --->
	<cfset link_id = event_id>
	<!--- kaydı güncelle --->
	<cfinclude template="upd_event.cfm">
	<!--- çoğalt --->
	<cfloop from="1" to="#evaluate(attributes.warning_count-1)#" index="i">
        <cfif warning_type eq 1>
			<!--- günde bir--->
			<cfset attributes.startdate = date_add("d",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("d",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("d",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("d",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("d",1,attributes.warning_start)>
			</cfif>
		<cfelseif warning_type eq 7>
			<!--- hafta ekle --->
			<cfset attributes.startdate = date_add("ww",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("ww",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("ww",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("ww",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("ww",1,attributes.warning_start)>
			</cfif>
		<cfelseif warning_type eq 30>
			<!--- ay ekle --->
			<cfset attributes.startdate = date_add("m",1,attributes.startdate)>
			<cfset attributes.finishdate = date_add("m",1,attributes.finishdate)>
			<cfif session.ep.our_company_info.sms eq 1>
				<cfset attributes.SMS_ALERT_DAY = date_add("m",1,attributes.SMS_ALERT_DAY)>
			</cfif>
			<cfset attributes.email_ALERT_DAY = date_add("m",1,attributes.email_ALERT_DAY)>
			<cfif len(attributes.warning_start)>
				<cfset attributes.warning_start = date_add("m",1,attributes.warning_start)>
			</cfif>
		</cfif>
		<cfinclude template="add_event.cfm">
	</cfloop>
<cfelseif (len(link_id)) and (not isdefined("warning") or (warning eq 1))>
<!--- çokluyu çoklu olarak güncelle --->
	<cfinclude template="upd_event.cfm">
<cfelseif (len(link_id)) and (warning eq 0)>
<!--- çokluyu tekli yap --->
	<cfset link_id = "">
	<!--- kaydı güncelle --->
	<cfinclude template="upd_event.cfm">
</cfif>
<cfif not isdefined("link_id") or not len(link_id)>
	<cfset link_id = attributes.event_id>
</cfif>
<cfset attributes.actionid = link_id>
<cf_workcube_process
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='EVENT'
	action_column='EVENT_ID'
	action_id='#attributes.event_id#' 
	action_page='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#attributes.event_id#' 
	warning_description='Ajanda : #attributes.event_id#'>
<cfif isdefined("attributes.is_popup")>
	<script language="javascript">
		window.close();
		opener.location.reload();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location='<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#link_id#</cfoutput>';
	</script>
</cfif>

