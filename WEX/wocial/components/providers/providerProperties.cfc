
component accessors = true {
    
    providerProperties = {
        'facebook': {
            'clientId'    : '377186256901278',
            'clientSecret': '13c1a5b65f6dccca11f7545727e955b8',
            'redirect_uri': 'https://qa.workcube.com/wex.cfm/authCreater/'
        }
    }
    
    public struct function getProviderData( required string platform ) {
        return providerProperties[platform];
    }

}