
component displayname="helper" {
    
    public date function webtime2date (any webtime) {
        if ( reFind('\+[0-9]{2,2}:[0-9]{2,2}', arguments.webtime) ) {
            arguments.webtime =  reReplace(arguments.webtime, '\.[0-9]{1,10}\+', '+');
            return parseDateTime( arguments.webtime, "yyyy-mm-dd'T'HH:nn:ssX" );
        } else {
            arguments.webtime =  reReplace(arguments.webtime, '\.[0-9]{1,10}$', '');
            return parseDateTime( arguments.webtime, "yyyy-mm-dd'T'HH:nn:ss" );
        }
    }

}