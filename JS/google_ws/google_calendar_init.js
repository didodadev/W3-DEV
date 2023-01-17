/*
    Google Calendar ile Workcube Ajanda entegrasyonu işlemleri için oluşturuldu. 30/12/2021 Alper Ç.
    Kullanıldığı dosyalar:
        - V16\agenda\form\form_add_event.cfm
        - V16\agenda\form\form_upd_event.cfm
        - V16\agenda\display\view_daily.cfm
    Kullanıldığı sayfada JS type değişkeni tanımlanmalı. (add, upd, list)
        - var type = "add"
*/
var GoogleAuth;
var eventStartTime1;
var eventFinishTime1;
var timeZone1;
var eventId1;
var sonuc;
var authId;
// Ajandada ekli olan Google Eventi, güncellemek için.
function updEventToCalendar() { 
    return gapi.client.calendar.events.get({
        "calendarId": "primary",
        "eventId": gEventId
    })
        .then(function (response) {
            if (response.result.id == gEventId && response.result.status == "confirmed") {
                let user = GoogleAuth.currentUser.get();
                if (user.getAuthResponse().session_state.extraQueryParams.authuser ){
                    let authId = user.getAuthResponse().session_state.extraQueryParams.authuser;
                }else{
                    let authId = 0;
                }
                let googleUrl = "https://calendar.google.com/calendar/u/" + authId + "/r/month?eid=";
                let eventId = response.result.htmlLink.split("eid=")[1];
                $("#item-is_google_cal div").append('<a target="_blank" href="' + googleUrl + eventId + '">(Link)</a>');
                document.getElementById("delGoogleEventButton").style.display = "";
                return false;
            } else {
                document.getElementById("delGoogleEventButton").style.display = "none";
            }
        },
            function (err) { console.error("Execute error", err); });
}

/* function deleteGoogleEvent(evntId) {
    return gapi.client.calendar.events.delete({
        "calendarId": "primary",
        eventId: evntId
    }).then(function (response) {
        console.log("Event Silindi!");
        sonuc = "1";
        alert(sonuc);
    },
        function (err) { console.error("Execute error", err); });
} */

// Ajandadaya Google Eventi, eklemek için.
function addEventToCalendar(eventStartTime1, eventFinishTime1, timeZone1) {
    var eventContent = {
        'summary': document.add_event.event_head.value,
        'location': document.add_event.event_place.value,
        'description': document.add_event.event_detail.value,
        'start': {
            'dateTime': eventStartTime1,
            'timeZone': timeZone1
        },
        'end': {
            'dateTime': eventFinishTime1,
            'timeZone': timeZone1
        }
    };

    var request = gapi.client.calendar.events.insert({
        'calendarId': 'primary',
        'resource': eventContent
    });

    request.execute(function (createdEvent) {
        /* console.log('Event created: ', createdEvent.htmlLink, createdEvent.id); */
        
        /* Google meet linki oluşturuluyor */
        var eventPatch = {
            conferenceData: {
                createRequest: { requestId: createdEvent.id }
            }
        };

        var event_place = document.getElementById('event_place').value;
        if( event_place == 4){
            gapi.client.calendar.events.patch({
                calendarId: "primary",
                eventId: createdEvent.id,
                resource: eventPatch,
                sendNotifications: true,
                conferenceDataVersion: 1
            }).execute(function (event) {
                /* console.log(event); */
                $("#meetLink").val("https://meet.google.com/"+event.conferenceData.conferenceId);
                eventId = createdEvent.id;
                $("#googleEventId").val(eventId);
                document.getElementById("add_event").submit();
            });
        }else{
            eventId = createdEvent.id;
            $("#googleEventId").val(eventId);
            document.getElementById("add_event").submit();
        }
        
        /* //Google meet linki oluşturuluyor */

        
    });
}

// Google Takvimde olan eventleri, ajandada listelemek için.
function listUpcomingEvents() { // yaklaşan olaylar
    var today = new Date();
    gapi.client.calendar.events.list({
        'calendarId': "primary",
        'timeMin': (new Date()).toISOString(),
        /* 'timeMax': (new Date(today.getFullYear(), today.getMonth()+2, 0)).toISOString(), */
        'showDeleted': false,
        'singleEvents': true,
        'maxResults': 10,
        'orderBy': 'startTime'
    }).then(function (response) {
        var gCalEvents = response.result.items;
        console.log(response.result);

        var endTime = new Date(today.getFullYear(), today.getMonth(), 1);
        var upcomingEvents = [];
        if (gCalEvents.length > 0) {
            for (i = 0; i < gCalEvents.length; i++) {
                var event = gCalEvents[i];
                var startTime = event.start.dateTime;
                var endTime = event.end.dateTime;
                if (!startTime) {
                    startTime = event.start.date;
                }
                var newEvent = { // google'dan gelen takvim etkinlikleri
                    id: i,
                    title: event.summary + '(Google Cal)',
                    start: startTime,
                    end: endTime,
                    color: '#ffa500',
                    url8: event.htmlLink
                };
                if (googleCalEventsListed == 0) {
                    $('#calendar').fullCalendar('renderEvent', newEvent, true); // google takvim etkinlikleri takvime yansıyor
                }
            }
            googleCalEventsListed = 1;
            console.log(eventListedMessage);
            alert(eventListedMessage);
        } else {
            console.log(noEventMessage);
            alert(noEventMessage);
        }
    });
}

function handleClientLoad(eventStartTime = '', eventFinishTime = '', timeZone = '', eventId='') {
    eventStartTime1 = eventStartTime;
    eventFinishTime1 = eventFinishTime;
    timeZone1 = timeZone;
    eventId1 = eventId;
    gapi.load('client:auth2', initClient);
}

function initClient() {
    // Google hesabına giriş
    gapi.client.init({
        'apiKey': API_KEY,
        'clientId': CLIENT_ID,
        'clientSecret': CLIENT_SECRET,
        'discoveryDocs': DISCOVERY_DOCS,
        'scope': SCOPES
    }).then(function () {
        GoogleAuth = gapi.auth2.getAuthInstance();

        // Listen for sign-in state changes.
        GoogleAuth.isSignedIn.listen(updateSigninStatus);

        // Handle initial sign-in state. (Determine if user is already signed in.)
        var user = GoogleAuth.currentUser.get();
        setSigninStatus();
    });
}

function handleAuthClick() {
    if (GoogleAuth.isSignedIn.get()) {
        // User is authorized and has clicked "Sign out" button.
        GoogleAuth.signOut();
    } else {
        // User is not signed in. Start Google auth flow.
        GoogleAuth.signIn();
    }
}

function revokeAccess() {
    // Google hesabı bağlantısını kesmek için
    GoogleAuth.disconnect();
}

function setSigninStatus() {
    // Google hesabına giriş sonrası yapılacak işlemler
    // type değişkenine göre çalışıyor.
    var user = GoogleAuth.currentUser.get();
    var isAuthorized = user.hasGrantedScopes(SCOPES);
    if (isAuthorized) {
        if (type === 'list') {
            $("#googleIcon").removeClass('iconic fa fa-google color-I');
            $("#googleIcon").removeClass('iconic fa fa-google color-R');
            $("#googleIcon").addClass('iconic fa fa-google color-G');
            listUpcomingEvents();
        }else if (type === 'add') {
            addEventToCalendar(eventStartTime1, eventFinishTime1, timeZone1);
        }else if (type === 'upd') {
            updEventToCalendar();
        }
    } else {
        $("#googleIcon").removeClass('iconic fa fa-google color-I');
        $("#googleIcon").removeClass('iconic fa fa-google color-G');
        $("#googleIcon").addClass('iconic fa fa-google color-R');
        alert(googleSignInMessage);
        handleAuthClick();
    }
}

function updateSigninStatus() {
    setSigninStatus();
}