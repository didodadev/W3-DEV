
component {
    
    public any function resolveObject (string dotpath) {
        local.underscorepath = replace(arguments.dotpath, ".", "_");
        if (not isDefined("application.plevneresolved")) {
            application.plevneresolved = structNew();
        }
        if (not isDefined("application.plevneresolved.#underscorepath#")) {
            application.plevneresolved[underscorepath] = createObject("component", arguments.dotpath);
            if (isDefined("application.plevneresolved.#underscorepath#.init")) {
                application.plevneresolved[underscorepath].init();
            }
        }
        return application.plevneresolved[underscorepath];
    }
    
}