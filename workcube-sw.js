
self.addEventListener('install', (event) => {});
self.addEventListener('activate', (event) => {});

self.addEventListener('fetch', (event) => {
    if(event && event.request.cache !== 'only-if-cached' && event.request.mode === 'same-origin'){
        event.respondWith(caches.match(event.request).then(function(response){
            return response || fetch(event.request);
        }));
    }
});

self.addEventListener('push', (event) => {
    var serverData=event.data.json();
    if(serverData){
        self.registration.showNotification(serverData.title,{
            body : serverData.body,
            icon : serverData.imageUrl,
            timeout : 1000,
            data: {
              dateOfArrival: Date.now(),
              primaryKey: 1,
              redirectUrl : serverData.redirectUrl
            }
        });
    }else{
        console.log("There is no data to be displayed.");
    }
});

self.addEventListener('notificationclick', (event) => {
    event.notification.close();
    const url = event.notification.data.redirectUrl.trim();
    let hadWindowToFocus = false, hadChatflowWindow = false;
    
    event.waitUntil(
        clients.matchAll({type: 'window'}).then( windowClients => {
            
            windowClients.forEach(client => {
                if( client.url == url ){
                    client.focus();
                    hadWindowToFocus = true;
                }
                if( client.url.includes('objects.chatflow') ) hadChatflowWindow = true;
            });

            if (!hadWindowToFocus){
                if( !hadChatflowWindow ) clients.openWindow(url);
                else{
                    windowClients.forEach(client => {
                        if(client.url.includes('objects.chatflow')){
                            client.focus();
                        }
                    });
                }
            }

        })
    );
});
