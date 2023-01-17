
component extends="AddOns.Plevne.infrastructure.resolver" {

    public any function init() {
        return this;
    }

    public any function register() {
        application.plevne_service = this;
        application.plevne_service.enabled = super.resolveObject("AddOns.Plevne.models.settings").get_plevne_setting_bykey("ENABLED") eq "1";
    }

    public any function inject() {
        if (not application.plevne_service.enabled) return "";
        
        super.resolveObject("AddOns.Plevne.core.requestfilter").inspect();
        //requestfilter = new AddOns.Plevne.core.requestfilter();
        //requestfilter.inspect();
        super.resolveObject("AddOns.Plevne.core.responseheader").add_headers();
        //responseheader = new AddOns.Plevne.core.responseheader();
        //responseheader.add_headers();
        super.resolveObject("AddOns.Plevne.core.tracecapture").begin_trace();
        //tracecapture = new AddOns.Plevne.core.tracecapture();
        //tracecapture.begin_trace();
        super.resolveObject("AddOns.Plevne.core.sysgathering").gather();
        //sysgathering = new AddOns.Plevne.core.sysgathering();
        //sysgathering.gather();
    }

    public any function end_trace() {
        if (not application.plevne_service.enabled) return "";
        
        super.resolveObject("AddOns.Plevne.core.tracecapture").end_trace();
        //tracecapture = new AddOns.Plevne.core.tracecapture();
        //tracecapture.end_trace();
    }

}