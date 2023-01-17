
component extends="AddOns.Plevne.infrastructure.modelbase" {
    
    public query function get_responses() {
        arguments.type = plevne_response_types.HEADER;
        return super.resolveObject("#addonns#.domains.responses").get_responses(argumentCollection: arguments);
    }

    
    public query function get_active_responses() {
        arguments.status = 1;
        return get_responses(argumentCollection: arguments);
    }

}