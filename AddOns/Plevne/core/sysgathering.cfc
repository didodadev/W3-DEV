
component {
    
    public any function init() {

        return this;

    }

    public any function gather() {
        
        jvmHelper = application.plevne_service.resolveObject("AddOns.Plevne.interpreters.jvmhelper");
        
        if (not isDefined("application.plevne_service.cpuloads")) {
            application.plevne_service.cpuloads = arrayNew(1);
        }

        if (arrayLen(application.plevne_service.cpuloads) gte 10) {
            arrayDeleteAt(application.plevne_service.cpuloads, 1);
        }

        if (not isDefined("application.plevne_service.memoryusage")) {
            application.plevne_service.memoryusage = arrayNew(1);
        }

        if (arrayLen(application.plevne_service.memoryusage) gte 10) {
            arrayDeleteAt(application.plevne_service.memoryusage, 1);
        }

        if (not isDefined("application.plevne_service.threads")) {
            application.plevne_service.threads = arrayNew(1);
        }

        if (arrayLen(application.plevne_service.threads) gte 10) {
            arrayDelete(application.plevne_service.threads, 1);
        }

        try {
            arrayAppend(application.plevne_service.cpuloads, int(jvmHelper.getCpuLoad()));
            arrayAppend(application.plevne_service.memoryusage, int(jvmHelper.getMemoryUsageForHeap().used));        
            arrayAppend(application.plevne_service.threads, jvmHelper.getThreadStats().all);
        } catch (any ex) {
            
        }

    }

}