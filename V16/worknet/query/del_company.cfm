    <cfset del_company = createObject("component", "V16.worknet.cfc.worknet_add_member")>
    <cfset delete = del_company.delCompany(cpid : attributes.cpid)>