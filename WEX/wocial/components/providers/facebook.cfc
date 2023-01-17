component extends = "/WEX/wocial/components/providers/providerProperties"{
	
	public struct function run( required string state ){

		variables.thisProvider = 'facebook';
		variables.sProviderData = {};

		variables.sProviderData = this.getProviderData( variables.thisProvider );

		var clientId     = variables.sProviderData[ 'clientId' ];
		var clientSecret = variables.sProviderData[ 'clientSecret' ];
		var redirect_uri = variables.sProviderData[ 'redirect_uri' ];

		var oFacebook = createObject("component", "WEX/wocial/components/oauth2Builders/facebook").init(
			client_id           = clientId,
			client_secret       = clientSecret,
			redirect_uri        = redirect_uri
		);

		var aScope = [
			'public_profile',
			'email'
		];
		var strURL = oFacebook.buildRedirectToAuthURL(
			scope = aScope,
			state = arguments.state
		);

		var arrData = listToArray( strURL, '&?' );
		arrData[ 1 ] = oFacebook.getAuthEndpoint()
		
		var stuParams = {};
		for( var i = 2; i <= arrayLen( arrData ); i++ ){
			structInsert( stuParams, listGetAt( arrData[ i ], 1, '=' ), listGetAt( arrData[ i ], 2, '=' ) );
		}

		structInsert( stuParams, 'token_url', strURL );

		return stuParams;

	}
	
}
