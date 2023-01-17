<!---
    Author: Workcube - Melek KOCABEY <melekkocabey@workcube.com>
    Date: 15.12.2020
    Description:
	Satınalma siparişinde proje kontrol. (display file)
--->
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
<cfset project_list = ''>
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset GET_XMLPRO_CAT = get_fuseaction_property.get_fuseaction_property(
        company_id : session.ep.company_id,
        fuseaction_name : 'budget.budget_transfer_demand',
        property_name : 'xml_proje_cat_id'
        )>
        <cfif GET_XMLPRO_CAT.recordCount and len( GET_XMLPRO_CAT.PROPERTY_VALUE )>
            <cfquery name="GET_PROJECT" datasource="#dsn#">
                SELECT PROJECT_ID FROM PRO_PROJECTS  WHERE PROCESS_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#valueList(GET_XMLPRO_CAT.PROPERTY_VALUE)#" list="yes">)
            </cfquery>
            <cfset project_list = valueList(GET_PROJECT.PROJECT_ID)><!--- bütçe aktarım talebindeki XML de Proje kategorilerine göre proje listesi --->
        </cfif>
<script type="text/javascript">
    process_cat_dsp_function = function() {
        var project_id = $('#project_id').val();
        var ref_no = $('#ref_no').val();
        var project_id_list = '<cfoutput>#project_list#</cfoutput>';
        if(list_find(project_id_list,project_id,',') ){
            var sql = "SELECT TOP 1 I.PROJECT_ID FROM INTERNALDEMAND I WHERE ("+"'"+ref_no+"'"+"=I.INTERNAL_NUMBER OR ("+"'"+ref_no+"'"+" LIKE ('%' + I.INTERNAL_NUMBER + ',%')))";
            get_project_id = wrk_query(sql,'dsn3');
            if(get_project_id.PROJECT_ID !='' && get_project_id.PROJECT_ID != undefined)
            {
                if(get_project_id.PROJECT_ID != project_id){
                    alert("Seçilen proje ilişkili satınalma talebinde ki proje ile aynı olmalıdır!");
                    return false;
                }
                else return true;
            }
            else{
                alert("Lütfen ilişkili satınalma talebinde proje seçiniz!");
                return false;
            }         
        }
        return true;
    }
</script>