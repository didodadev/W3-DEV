component extends="AddOns.Plevne.infrastructure.modelbase" {

    public any function list_process() {
        query_process = super.resolveObject("#addonns#.domains.level_process").get_level_process(argumentCollection: arguments);
        inst_expression_categories = super.resolveObject("#addonns#.domains.expression_categories");
        inst_interceptor_categories = super.resolveObject("#addonns#.domains.interceptor_categories");

        table_process = arrayNew(1);
        for (i = 1; i <= query_process.recordcount; i++) {
            row_process = queryGetRow(query_process, i);
            if (row_process.PROCESS_TYPE eq 1) {
                row_process.TITLE = queryGetRow(inst_expression_categories.get_expression_categories(expression_category_id: row_process.RELATION_ID), 1).TITLE;
            }
            if (row_process.PROCESS_TYPE eq 2) {
                row_process.TITLE = queryGetRow(inst_interceptor_categories.get_interceptor_categories(interceptor_category_id: row_process.RELATION_ID), 1).TITLE;
            }
            arrayAppend(table_process, row_process);
        }
        return table_process;
    }
    
}