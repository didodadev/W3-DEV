<cfparam name="attributes.is_public" default="">
<cfparam name="attributes.is_employee" default="">
<cfparam name="attributes.is_consumer" default="">
<cfparam name="attributes.is_company" default="">
<cfparam name="attributes.is_machines" default="">
<cfparam name="attributes.is_livestock" default="">
<cfparam name="attributes.is_template_widget" default="">
<cfparam name="attributes.is_employee_app" default="">
<cfparam name="attributes.friendly_name" default="">
<cfparam name="attributes.xml_path" default="">

<cfset GetPageContext().getCFOutput().clear()>
<cfset wid = formtodb(
    widgetid            : attributes.widgetid,
    friendlyName        : attributes.friendlyName,
    fuseaction          : attributes.related_wo,
    title               : attributes.title,
    dictionary_id       : attributes.dictionary_id,
    version             : attributes.version,
    main_version        : attributes.main_version,
    status              : attributes.status,
    stage               : attributes.stage,
    tool                : attributes.tool,
    file_path           : attributes.file_path,
    solutionid          : listfirst(attributes.solutionid),
    solution            : attributes.solution,
    familyid            : listfirst(attributes.familyid),
    family              : attributes.family,
    moduleno            : listfirst(attributes.moduleno),
    module              : attributes.module,
    license             : attributes.license,
    author              : attributes.author,
    description         : attributes.description,
    widget_type         :attributes.widget_type,
    events              : attributes.events,
    is_public           : attributes.is_public,
    is_employee         :  attributes.is_employee,
    is_consumer         : attributes.is_consumer,
    is_company          : attributes.is_company,
    is_machines         : attributes.is_machines,
    is_livestock        :  attributes.is_livestock,
    is_employee_app     :  attributes.is_employee_app,
    is_template_widget  : attributes.is_template_widget,
    xml_path            : attributes.xml_path
)>
<cfoutput>#wid#</cfoutput>
<cfabort>