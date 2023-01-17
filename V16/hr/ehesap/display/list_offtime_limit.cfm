<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfquery name="get_parameters" datasource="#dsn#">
	SELECT 
    	SOL.LIMIT_ID,
        SOL.STARTDATE, 
        SOL.FINISHDATE,
        SOL.DEFINITION_TYPE,
        SOL.PUANTAJ_GROUP_IDS
    FROM 
	    SETUP_OFFTIME_LIMIT AS SOL
</cfquery>
<cfquery name="get_puantaj_groups" datasource="#dsn#">
	SELECT 
    	GROUP_ID, GROUP_NAME 
   	FROM 
    	EMPLOYEES_PUANTAJ_GROUP
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=ehesap.list_offtime_limit" method="post">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" id="keyword" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder = "#message#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id="53076.İzin Süreleri"></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                    <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <th><cf_get_lang dictionary_id='53872.Tanım Tipi'></th>
                    <th><cf_get_lang dictionary_id="56857.Çalışan Grubu"></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_offtime_limit&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_parameters">
                    <tr>
                        <td>#dateformat(startdate,dateformat_style)# </td>
                        <td>#dateformat(finishdate,dateformat_style)#</td>
                        <td><cfif definition_type eq 1><cf_get_lang dictionary_id='54199.Yıllara Göre'><cfelse><cf_get_lang dictionary_id='29675.Aylara Göre'></cfif></td>
                        <cfif len(PUANTAJ_GROUP_IDS)>
                            <cfquery name="get_group_name" dbtype="query">
                                SELECT 
                                    GROUP_NAME 
                                FROM 
                                    get_puantaj_groups 
                                WHERE 
                                    GROUP_ID IN (#PUANTAJ_GROUP_IDS#)
                            </cfquery>
                            <cfset grupName = valuelist(get_group_name.group_name)>
                        <cfelse>
                            <cfset grupName = ''>
                        </cfif>
                        <td>#grupName#</td>
                        <td><a href="#request.self#?fuseaction=ehesap.list_offtime_limit&event=upd&limit_id=#limit_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
