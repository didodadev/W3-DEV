<cfset getPageContext().getCFOutput().clear()>
<cfoutput>
#formtodb(
    fuseaction  : attributes.related_wo,
    title       : attributes.title,
    version     : attributes.version,
    status      : attributes.status,
    stage       : attributes.stage,
    tool        : attributes.tool,
    file_path   : attributes.file_path,
    solutionid  : attributes.solutionid,
    solution    : attributes.solution,
    familyid    : attributes.familyid,
    family      : attributes.family,
    moduleid    : attributes.moduleid,
    module      : attributes.module,
    license     : attributes.license,
    author      : attributes.author,
    description : attributes.description,
    events      : attributes.events
)#
</cfoutput>
<cfabort>