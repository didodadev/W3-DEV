
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