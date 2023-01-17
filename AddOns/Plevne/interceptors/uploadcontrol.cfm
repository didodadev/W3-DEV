<cfscript>
if (len(cgi.CONTENT_TYPE) and listFirst(cgi.CONTENT_TYPE, ";") eq "multipart/form-data") {
    logger = application.plevne_service.resolveObject("AddOns.Plevne.domains.logs");
    blacklist_mapper = function(e) { 
        return "(" & e & ")"; 
    };
    form_keys = structKeyArray(form);
    for (i = 1; i <= arrayLen(form_keys); i++) {
        e = form_keys[i];
        if (listLast(form[e], ".") eq "tmp") {
            blacklist = ["application"];
            expression = arrayToList( arrayMap( blacklist, blacklist_mapper ), "|");
            if (reFind(expression, fileGetMimeType(form[e]))) {
                logger.save_log(source: "UploadControl", source_id: ic.INTERCEPTOR_ID, type: 1, message: "Tehlikeli dosya", trace: expression);
                fileDelete(form[e]);
                return false;
            }
        }
    }
}
</cfscript>