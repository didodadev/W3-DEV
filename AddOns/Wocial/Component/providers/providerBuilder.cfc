component {
    
    public struct function getProvider( required string providerName ) {
        return createObject('component', 'AddOns/Wocial/Component/providers/#providerName#').run();
    }

}