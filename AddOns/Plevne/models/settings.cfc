component extends="AddOns.Plevne.infrastructure.modelbase" {
    include "../config.cfm" runonce=true;

    public numeric function is_installed() {
        return super.resolveObject("#addonns#.domains.settings").is_installed();
    }

    public query function get_plevne_settings() {
        return super.resolveObject("#addonns#.domains.settings").get_plevne_settings(argumentCollection: arguments);
    }

    public any function get_plevne_setting_bykey(string key) {
        try {    
            local.plevnesetting = get_plevne_settings(key: arguments.key, status: 1);
            if (local.plevnesetting.recordcount) {
                return local.plevnesetting.SETTING_VALUE;
            } else {
                return arguments.key;
            }
                
        } catch (any exc) {
            return key;
        }
    }

    public any function save_plevne_setting() {
        super.resolveObject("#addonns#.domains.settings").save_plevne_settings(argumentCollection: arguments);
    }
}