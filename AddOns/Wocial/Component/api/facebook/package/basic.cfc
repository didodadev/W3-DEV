component extends="AddOns/Wocial/Component/api/facebook/request"{

	/**
	* @access_token The access token for verification!
	**/
    public struct function run( required string access_token ){

		var property = [
			'id',
			'name',
			'first_name',
			'last_name'
		];

		this.init(access_token: arguments.access_token, api_page: '/me');
		return this.startRequest( fields: property );

	}

}