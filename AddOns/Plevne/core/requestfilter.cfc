
component {
    
    public any function init() {
        
        return this;

    }
    
    public boolean function inspect() {
        if (isDefined("url.fuseaction") and structKeyExists(application, "objects") and structKeyExists(application.objects, url.fuseaction)) {
            local.security_level = application.objects['#URL.fuseaction#']['SECURITY'];
        } else {
            local.security_level = "standart";
        }
        attr = structNew();
        structAppend( attr, url );
        structAppend( attr, form );
        
        attrdata = arrayReduce(structKeyArray(attr), function(acc, val) {
            if (isDefined("attr.#val#")) {
                acc = acc & val & "=" & attr[val] & chr(13) & chr(10);
            }
            return acc;
        }, "");

        return inspect_common(attrdata);

    }

    public boolean function inspect_onservice(any data) {

        datakeys = structKeyArray(data);
        attrdata = "";
        for (d in datakeys) {
            attrdata = attrdata & d & "=" & data[d] & chr(13) & chr(10);
        }

        return inspect_common(attrdata);
    }

    public boolean function inspect_common(any data) {

        attrdata = arguments.data;

        logger = application.plevne_service.resolveObject("AddOns.Plevne.domains.logs");

        model_of_request_filter = application.plevne_service.resolveObject("AddOns.Plevne.models.request_filter");
        active_expressions = model_of_request_filter.get_active_expressions();

        expression_categories = queryReduce(active_expressions, function(acc, val) {
            if (not arrayContains(acc, val.EXPRESSION_CATEGORY)) { 
                arrayAppend(acc, val.EXPRESSION_CATEGORY);
            }
            return acc;
        }, arrayNew(1));

        for (cat in expression_categories) {
            rows = queryFilter(duplicate(active_expressions), function(row) {
                return row.EXPRESSION_CATEGORY eq cat;
            });
            expressions = queryReduce(rows, function(acc, val) {
                arrayAppend(acc, "(#val.EXPRESSION_BODY#)");
                return acc;
            }, arrayNew(1));
            regkey = arrayToList(expressions, "|");
            result = reFindNoCase(regkey, attrdata);
            if (result neq 0) {

                if (isDefined("session.ep")) {
                    attrdata = attrdata & "session ------ " & chr(13) & chr(10) & replace( serializeJSON(session.ep), "//", "");
                }

                logger.save_log(source: "ExpressionCategory", source_id: cat, type: 1, message: "Tehlikeli betik", trace: attrdata);
                writeOutput( '<script>document.location.href = "/index.cfm?fuseaction=plevne.dashboard&event=error";</script>' );abort;
            }
        }

        active_interceptors = model_of_request_filter.get_active_interceptor();

        interceptors = queryReduce(active_interceptors, function(acc, val) {
            arrayAppend(acc, val);
            return acc;
        }, arrayNew(1));

        for (ic in interceptors) {
            include ic.INTERCEPTOR_PATH;
        }

        return true;
    } 

}