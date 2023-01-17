<cfinclude template="../../config.cfm">
<cfif isdefined('attributes.compbranch_status')><cfset attributes.compbranch_status = 1><cfelse><cfset attributes.compbranch_status = 0></cfif>
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
<cfset cmp.updBranch(
        branch_id:attributes.compbranch_id,
        manager_partner_id:attributes.manager,
        status:attributes.compbranch_status,
        brach_name:attributes.compbranch__name,
        detail:attributes.compbranch__nickname,
        email:attributes.compbranch_email,
        homepage:attributes.homepage,
        telcod:attributes.compbranch_telcode,
        tel1:attributes.compbranch_tel1,
        tel2:attributes.compbranch_tel2,
        tel3:attributes.compbranch_tel3,
        fax:attributes.compbranch_fax,
        mobilcat_id:attributes.mobilcat_id,
        mobiltel:attributes.mobiltel,
        postcod:attributes.compbranch_postcode,
        adres:attributes.compbranch_address,
        county_id:attributes.county_id,
        city_id:attributes.city_id,
        country:attributes.country,
        semt:attributes.semt,
        coordinate_1:attributes.coordinate_1,
        coordinate_2:attributes.coordinate_2
    ) />
<script type="text/javascript">
    <cfoutput>
    document.location.href = '#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['upd-branch']['nextEvent']##attributes.company_id#';
    </cfoutput>
</script>    