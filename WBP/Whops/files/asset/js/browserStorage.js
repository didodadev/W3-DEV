Storage.prototype.getJSON = function(key) {
    return JSON.parse( this.getItem(key) );
}
Storage.prototype.setJSON = function(key, value) {
    return this.setItem(key, JSON.stringify(value));
}
var wrkBrowserStorage = function(type = 'session') {
    if (type == 'local') {
        var storageService = localStorage;
    } else {
        var storageService = sessionStorage;
    }
    return storageService;
};