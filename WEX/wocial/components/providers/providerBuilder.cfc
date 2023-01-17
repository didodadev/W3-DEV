component {
    
    public struct function getProvider( required string providerName, required string state ) {
        return createObject('component', 'WEX/wocial/components/providers/#arguments.providerName#').run( arguments.state );
    }

}