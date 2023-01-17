component accessors = "true"{
    
    property name="access_token" type="string";

    public package_manager function init(
        required string access_token
    ){
        setAccess_token( arguments.access_token );
        return this;
    }

    public any function getPackage( required string packageName ) {
        return createObject('component', 'AddOns/Wocial/Component/api/facebook/package/#arguments.packageName#').run( getAccess_token() );
    }

}