
component accessors = true {

    domain = (cgi.SERVER_PORT eq 443 ? 'https://' : 'http://') & cgi.SERVER_NAME & "/";

    providerProperties = {
        'facebook': {
            'clientId'    : '377186256901278',
            'clientSecret': '13c1a5b65f6dccca11f7545727e955b8',
            'redirect_uri': 'https://dev.workcube.com/wex/'
        }
    }
    
    public struct function getProviderData( required string platform ) {
        return providerProperties[platform];
    }

}