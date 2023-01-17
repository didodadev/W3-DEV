component {

    public any function init() {
        return this;
    }

    public any function begin_trace() {
        request.begin_trace = now();
    }

    public any function end_trace() {
        inst_settings_model = application.plevne_service.resolveObject("AddOns.Plevne.models.settings");
        trace_timeup = inst_settings_model.get_plevne_setting_bykey("TRACE_TIMEUP");
        if (trace_timeup eq "TRACE_TIMEUP") {
            return "";
        }
        if (not isDefined("request.begin_trace")) {
            return "";
        }
        time_diff = dateDiff("s", request.begin_trace, now());

        if (time_diff >= trace_timeup) {
            inst_trace_domain = application.plevne_service.resolveObject("AddOns.Plevne.domains.traces");
            inst_trace_domain.save_trace(
                page: iif(isDefined("url.fuseaction"), "url.fuseaction", de("")), 
                user_name: iif(isDefined("session.ep.username"), "session.ep.username", de("")), 
                parameters: replace(serializejson(url), "//", ""), 
                record_date: now(), 
                req_time: time_diff, 
                server: cgi.REMOTE_HOST );
        }

    }

}