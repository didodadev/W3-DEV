component extends="AddOns.Plevne.infrastructure.modelbase" {

    public struct function get_logs() {
        return {
            data: super.resolveObject("#addonns#.domains.logs").get_logs(argumentCollection: arguments),
            count: super.resolveObject("#addonns#.domains.logs").count_logs(argumentCollection: arguments)
        };
    }

    public query function get_log(log_id) {
        return super.resolveObject("#addonns#.domains.logs").get_logs(log_id: arguments.log_id);
    }

}