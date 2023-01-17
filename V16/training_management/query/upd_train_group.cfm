<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.is_internet" default="">

<cfset UPD_DB = groups.UPDDB
(
    train_group_id : attributes.train_group_id,
    GROUP_HEAD : attributes.group_head,
    GROUP_DETAIL : attributes.group_detail,
    employee_id : attributes.employee_id,
    process_stage : attributes.process_stage,
    quota : attributes.quota,
    branch_id : attributes.branch_id,
    department_id : attributes.department_id,
    IS_INTERNET : attributes.is_internet,
    START_DATE : attributes.start_date,
    FINISH_DATE : attributes.finish_date,
    STATU = attributes.statu
)/>

<cfset DEL_SITE_DOMAIN = groups.DELETE_SITE_DOMAIN
(
    train_group_id : attributes.train_group_id
)/>
<cfif isdefined("attributes.is_internet") and attributes.is_internet eq 1>
    <cfset GET_COMPANY = groups.GETCOMPANY()/>
    <cfoutput query="get_company">
        <cfif isdefined("attributes.menu_#menu_id#")>
            <cfset TRAINING_GROUP_SITE_DOMAIN = groups.trainingSiteDomain
            (
                TRAINING_CLASS_GROUP_ID : get_class_id.train_group_id,
                MENU_ID:attributes["menu_#menu_id#"]
            )/>
        </cfif>
    </cfoutput>
</cfif>
<script>
    window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_groups&event=upd&train_group_id=#attributes.TRAIN_GROUP_ID#</cfoutput>";
</script>
   