<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.is_internet" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfset ADD_DB = groups.ADDDB
(
    GROUP_HEAD : attributes.group_head,
    GROUP_DETAIL : attributes.group_detail,
    employee_id : attributes.employee_id,
    process_stage : attributes.process_stage,
    quota : attributes.quota,
    branch_id : len(attributes.branch_id) ? attributes.branch_id : 0,
    department_id : len(attributes.department_id) ? attributes.department_id : 0,
    IS_INTERNET : attributes.is_internet,
    START_DATE : attributes.start_date,
    FINISH_DATE : attributes.finish_date,
    STATU: 1
)/>
<cfset get_class_id = groups.CLASS_ID()/>
<cfif isdefined("attributes.is_internet")>
    <cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
    <cfset GET_COMPANY = cmp.GET_COMPANY_F(is_upd:1)>
    <cfoutput query="get_company">
        <cfif isdefined("attributes.menu_#menu_id#")>
            <!--- <cfquery name="TRAINING_SITE_DOMAIN" datasource="#DSN#">
                INSERT INTO
                    TRAINING_CLASS_GROUPS_SITE_DOMAIN
                    (
                        TRAINING_CLASS_GROUP_ID,		
                        MENU_ID
                    )
                VALUES
                    (
                        #get_class_id.train_group_id#,
                        '#attributes["menu_#menu_id#"]#'
                    )	
            </cfquery> --->
            <cfset TRAINING_SITE_DOMAIN = groups.trainingSiteDomain
            (
                train_group_id : get_class_id.train_group_id,
                MENU_ID:attributes["menu_#menu_id#"]
            )/>
        </cfif>
    </cfoutput>
</cfif>

        <script>
            window.location.href = "<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_groups&event=upd&train_group_id=#get_class_id.train_group_id#</cfoutput>";
        </script>
