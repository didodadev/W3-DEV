<cfquery name="get_parameters" datasource="#dsn#">
    SELECT 
        PARAMETER_ID, 
        STARTDATE, 
        FINISHDATE, 
        PARAMETER_NAME 
    FROM 
	    SETUP_PROGRAM_PARAMETERS 
    ORDER BY 
    	STARTDATE DESC
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="47071.Bordro Akış Parametreleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_flat_list> 
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58233.Tanım'></th>
                    <th width="65"><cf_get_lang dictionary_id='57699.Başlangıç Tarihi'></th>
                    <th width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                    <th class="header_icn_none text-center"><cfoutput><a href="#request.self#?fuseaction=ehesap.list_program_parameters&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></a></cfoutput></th>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_parameters">
                    <tr>
                        <td>#parameter_name#</td>
                        <td>#dateformat(startdate,dateformat_style)#</td>
                        <td>#dateformat(finishdate,dateformat_style)#</td>
                        <td width="20"><a href="#request.self#?fuseaction=ehesap.list_program_parameters&event=upd&parameter_id=#parameter_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_flat_list> 
    </cf_box>
</div>
