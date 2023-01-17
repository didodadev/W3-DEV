let deferredPrompt;

if ('serviceWorker' in navigator) navigator.serviceWorker.register('workcube-sw.js');

if( ( window.innerWidth <= 800 ) && ( window.innerHeight <= 600 ) ){

    window.addEventListener('beforeinstallprompt', (e) => {

        e.preventDefault();
        deferredPrompt = e;
        
        document.querySelector('.add-to-homescreen-panel').style.display = 'block';
    
        document.querySelector('.add-to-homescreen .accept').addEventListener('click', (e) => {

            deferredPrompt.prompt();
            deferredPrompt.userChoice.then((choiceResult) => {
                if( choiceResult.outcome == 'accepted' || choiceResult.outcome == 'dismissed' ) location.reload();
                deferredPrompt = null;
            });

        });

        document.querySelector('.add-to-homescreen .dismiss').addEventListener('click', (e) => {

            document.querySelector('.add-to-homescreen-panel').style.display = 'none';
            deferredPrompt = null;

        });

    });

    /*for apple - ios*/
    var startUrlEl = document.querySelector("meta[name=msapplication-starturl]");
    if(!!startUrlEl === true && navigator.standalone === true) {
        var lastUrl = localStorage["navigate"];
        history.pushState({launched: (!!lastUrl == false && history.length === 1)}, undefined, lastUrl || startUrlEl.content);
        localStorage.removeItem("navigate");
        
        document.addEventListener("click", function(e) {
            var target = e.target;
            if(target.tagName === 'A') {
            
                var href = target.getAttribute("href");
                var linkedUrl = new URL(target.href);

                if(linkedUrl.origin === location.origin) {
                    e.preventDefault();
                    location.href = href;
                }else localStorage["navigate"] = location.href;

            }
        });
    }
    /*for apple - ios*/

}