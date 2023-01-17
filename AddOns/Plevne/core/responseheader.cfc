
component {
    
    public any function init() {
        return this;
    }

    public any function add_headers() {
        model_of_response_headers = application.plevne_service.resolveObject("AddOns.Plevne.models.header_responses");
        active_headers = model_of_response_headers.get_active_responses();
        include "../interceptors/responseheader.cfm";
    }

}