<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = 'content.popup_view_content_follows&cntid=#attributes.cntid#'>
<cfif isDefined('attributes.crid') and len(attributes.crid)>
<cfset url_str = url_str&'&crid='&attributes.crid>
</cfif>

<cfquery name="get_content_follows" datasource="#dsn#">
SELECT 
	CF.READ_DATE,
	E.EMPLOYEE_NAME,
	E.EMPLOYEE_SURNAME,
	E.EMPLOYEE_ID
FROM 
	CONTENT_FOLLOWS CF,
	EMPLOYEES E
WHERE 
	CF.CONTENT_ID = #attributes.cntid# AND
	CF.EMPLOYEE_ID = E.EMPLOYEE_ID 
ORDER BY 
	CF.READ_DATE DESC, E.EMPLOYEE_NAME DESC
</cfquery>
<cfparam name="attributes.totalrecords" default=#get_content_follows.recordcount#>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='50695.Ziyaret Istatiği'></cfsavecontent>
    <cf_box title="#head#" closable="1"><!---Ziyaret İstatistiği--->
        <cf_flat_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='50696.Okuyan'></th>
                    <th width="100"><cf_get_lang dictionary_id='50661.Okuma'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_content_follows.recordcount>
                    <cfoutput query="get_content_follows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                            <td>
                                <cfset read_date_ = date_add('h',session.ep.time_zone,read_date)>
                                    #dateformat(read_date_,dateformat_style)# (#timeformat(read_date_,timeformat_style)#)
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr><td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt yok'>!</td></tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.maxrows lt attributes.totalrecords>
			<cfif isDefined('attributes.content_cat') and len(attributes.content_cat)>
				<cfset url_str = "#url_str#&content_cat=#attributes.content_cat#">
            </cfif>
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#url_str#"> 
        </cfif>
    </cf_box>
</div>
