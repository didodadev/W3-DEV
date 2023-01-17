component extends="AddOns/Wocial/Component/api_request"{
    
    public request function init( required string access_token, string api_page = '' ) {

        super.init(
            api_url: 'https://graph.facebook.com/v10.0#arguments.api_page#',
            access_token: arguments.access_token
        );
        return this;

    }

    public struct function startRequest( required array fields ) {

        var formFields = [{ 'name'  = 'fields', 'value' = arrayToList( arguments.fields, ',' ) }];
        return super.startRequest( formfields: formFields );

    }

}