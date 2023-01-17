<cfscript>
    plevne_kinds = structNew();
    plevne_kinds.REQUEST_FILTER = 1;
    plevne_kinds.UPLOAD_CONTROL = 2;
    plevne_kinds.TRACE_INSPECTION = 3;

    plevne_process_types = structNew();
    plevne_process_types.EXPRESSION = 1;
    plevne_process_types.INTERCEPTOR = 2;

    plevne_response_types = structNew();
    plevne_response_types.HEADER = 1;
</cfscript>
