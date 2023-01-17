component accessors = "true"{

    property name="api_url" type="string";
    property name="access_token" type="string";

    public api_request function init(
        required string api_url,
        required string access_token
    ) {

        setApi_url( arguments.api_url );
        setAccess_token( arguments.access_token );
        return this;
    }

   
    /**
	* @formfields An optional array of structs for the provider requirements to add new form fields.
	* @headers An optional array of structs to add custom headers to the request if required.
	**/
	public struct function startRequest(
		array formfields = [],
		array headers    = []
	){
		var stuResponse = {};
	    var httpService = new http();
	    httpService.setMethod( "get" );
	    httpService.setCharset( "utf-8" );
	    httpService.setUrl( getApi_url() );

        httpService.addParam( type="formfield", name="access_token", value=getAccess_token() );
        if( arrayLen( arguments.headers ) ){
	    	for( var item in arguments.headers ){
	    		httpService.addParam( type="header", name=item[ 'name' ], value=item[ 'value' ] );
	    	}
	    }
	    if( arrayLen( arguments.formfields ) ){
	    	for( var item in arguments.formfields ){
	    		httpService.addParam( type="formfield", name=item[ 'name' ], value=item[ 'value' ] );
	    	}
	    }

        var result = httpService.send().getPrefix();
        
	    if( structKeyExists(result.ResponseHeader, 'Status_Code') and '200' == result.ResponseHeader[ 'Status_Code' ] ) {
	    	stuResponse.success = true;
	    	stuResponse.content = result.FileContent;
	    } else {
	    	stuResponse.success = false;
	    	stuResponse.content = result.Statuscode;
	    }
    	return stuResponse;
	}
}