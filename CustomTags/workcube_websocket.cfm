<!--- 
    Author : Uğur Hamurpet
    Date : 11/03/2020
    Desc : This customtag created for websocket controls
--->

<!--- Soket üzerinden gönderilmek istenen değerleri ister --->
<cfparam name="attributes.socketItems" type="array" default="#arrayNew(1)#" />

<cfset socketSettings = StructNew() />

<cfif isDefined('session.ep.userid')>
    <cfset socketSettings.userid = session.ep.userid />
<cfelseif isDefined('session.pp.userid')>
    <cfset socketSettings.userid = session.pp.userid />
<cfelseif isDefined('session.ww.userid')>
    <cfset socketSettings.userid = session.ww.userid />
</cfif>
<cfif isDefined("socketSettings.userid") >
    
    <cfset socketSettings = {
        secure : cgi.https eq "on" ? "true" : "false",
        channelList : "workflow.#socketSettings.userid#"
    }/>

    <cftry>

        <cfwebsocket name="cfSocketObj"
            onMessage="handlerMessage"
            onError="handlerError"
            onOpen="handlerOpen"
            onClose="handlerClose"
            useCfAuth="true"
            secure="#socketSettings.secure#"
            subscribeTo="#socketSettings.channelList#"
        />
        
        <script type="text/javascript">

            handlerMessage =  function( event ) {
                
                //Soket üzerinden gönderim yapılırken type değeri mutlaka gönderilmeli!
                if( event.data !== undefined && event.data.type !== undefined ){
                    
                    //type workflow ise : Workflow'a özel işlemler bu koşulda yapılabilir.
                    //Başka bir type değeri gönderiliyorsa bu kısımda yeni bir elseif koşulu oluşturulmalı!
                    if( event.data.type == 'workflow' ){}

                    //Eğer alıcı tarafta bildirim oluşturmak isteniyorsa; sokete bildirim gönderirken notification_settings.status değeri true gönderilmeli.
                    if( event.data.notification_settings !== undefined && event.data.notification_settings )
                        createNotification( event.data.notification_settings );
                
                }

            }
            handlerOpen = function() {}
            handlerClose= function() {}
            handlerError = function(error) {console.log(error);}

            <cfif arrayLen( attributes.socketItems )>
            /* Publish items */
            publishItems();
            function publishItems() {
                setTimeout(() => {
                    
                    if ( cfSocketObj.isConnectionOpen() ) {
                        var socketItemsJson = <cfoutput>#LCase(Replace(serializeJSON( attributes.socketItems ),"//",""))#</cfoutput>;
                        socketItemsJson.forEach((el) => { cfSocketObj.publish(el.channel, el.data); });
                    } else publishItems();

                }, 5);   
            }
            /* Publish items */
            </cfif>

            /* Notification */
            createNotification = function( notificationSettings ){
                if (!('Notification' in window) || !('serviceWorker' in navigator)) {
                    console.log('Persistent Notification API not supported!');
                    return;
                }else{
                    try {
                        if (Notification.permission === "granted") {
                            navigator.serviceWorker.register('workcube-sw.js').then(function() {
                                return navigator.serviceWorker.ready;
                            }).then(function(reg) {
                                reg.showNotification(notificationSettings.title, {
                                    body: notificationSettings.content,
                                    icon: '../images/shortcut/mobil/icon-192x192.png',
                                    vibrate: [200, 100, 200, 100, 200, 100, 200],
                                    timeout : 1000,
                                    data : {
                                        dateOfArrival: Date.now(),
                                        primaryKey: 1,
                                        redirectUrl : notificationSettings.redirecturl
                                    }
                                });
                            }).catch(function(error) {
                                console.log('Service Worker error :^(', error);
                            });
                        }
                    } catch (err) {
                        console.log('Notification API error: ' + err);
                    }
                }
            }
            /* Notification */

        </script>

        <cfcatch>
            <!--- Yeni bir kanal eklendiğinde application restartlanması gerekiyor --->
            <cfset createObject("component","Application").OnApplicationStart() />
        </cfcatch>
    </cftry>

</cfif>