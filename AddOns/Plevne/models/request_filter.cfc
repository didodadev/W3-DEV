component extends="AddOns.Plevne.infrastructure.modelbase" {

    public query function get_expression_categories() {
        arguments.expression_kind = plevne_kinds.REQUEST_FILTER;
        return super.resolveObject("#addonns#.domains.expression_categories").get_expression_categories(argumentCollection: arguments);
    }

    public query function get_expressions() {
        arguments.expression_kind = plevne_kinds.REQUEST_FILTER;
        return super.resolveObject("#addonns#.domains.expressions").get_expressions(argumentCollection: arguments);
    }

    public query function get_active_expressions() {
        local.level_process = super.resolveObject("#addonns#.domains.level_process").get_level_process(process_kind: plevne_kinds.REQUEST_FILTER, process_type: plevne_process_types.EXPRESSION);
        local.level_category_ids = valueList(local.level_process.RELATION_ID);
        local.categories = get_expression_categories(expression_kind: plevne_kinds.REQUEST_FILTER, status: 1, expression_category_id: local.level_category_ids);
        local.category_ids = valueList(local.categories.EXPRESSION_CATEGORY_ID);
        return get_expressions( argumentCollection: { expression_kind: plevne_kinds.REQUEST_FILTER, expression_category: local.category_ids, status: 1 } );
    }

    public query function get_interceptor_categories() {
        arguments.interceptor_kind = plevne_kinds.REQUEST_FILTER;
        return super.resolveObject("#addonns#.domains.interceptor_categories").get_interceptor_categories(argumentCollection: arguments);
    }

    public query function get_interceptors() {
        arguments.expression_kind = plevne_kinds.REQUEST_FILTER;
        return super.resolveObject("#addonns#.domains.interceptors").get_interceptors(argumentCollection: arguments);
    }

    public query function get_active_interceptor() {
        local.level_process = super.resolveObject("#addonns#.domains.level_process").get_level_process(process_kind: plevne_kinds.REQUEST_FILTER, process_type: plevne_process_types.EXPRESSION);
        local.level_category_ids = valueList(local.level_process.RELATION_ID);
        local.categories = get_interceptor_categories(interceptor_kind: plevne_kinds.REQUEST_FILTER, status: 1, interceptor_category_id: local.level_category_ids);
        local.category_ids = valueList(local.categories.INTERCEPTOR_CATEGORY_ID);
        return get_interceptors( argumentCollection: { interceptor_kind: plevne_kinds.REQUEST_FILTER, interceptor_category: local.category_ids, status: 1 } );
    }

}