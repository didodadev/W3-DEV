<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.kasiyer_ids" default="">
<cfparam name="attributes.kasa_numarasi" default="">
<cfparam name="attributes.zno" default="">
<cfparam name="attributes.acik_tutar" default="">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	BRANCH_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
        D.DEPARTMENT_ID NOT IN (#iade_depo_id#,#merkez_depo_id#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_kasalar" datasource="#dsn#">
	SELECT 
    	B.BRANCH_NAME + ' - ' + ISNULL(PE.EQUIPMENT_CODE,'') KASA_ADI,
        PE.EQUIPMENT_CODE
    FROM 
    	BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE
    WHERE
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	BRANCH_NAME,
        PE.EQUIPMENT_CODE
</cfquery>

<cfquery name="get_kasa_kullanicilar" datasource="#dsn#">
	SELECT 
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME + ' (' + B.BRANCH_NAME + ')' AS KASIYER,
        E.EMPLOYEE_ID
    FROM 
    	BRANCH B,
        #dsn_dev_alias#.POS_USERS PE,
        EMPLOYEES E
    WHERE
        E.EMPLOYEE_ID = PE.EMPLOYEE_ID AND
        B.BRANCH_ID = PE.BRANCH_ID AND
        B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	BRANCH_NAME,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME
</cfquery>

<cfquery name="get_znos" datasource="#dsn_dev#">
	SELECT
    	B.BRANCH_NAME,
        PE.EQUIPMENT_CODE,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KASIYER,
        GA.*
    FROM 
    	#dsn_alias#.BRANCH B,
        #dsn3_alias#.POS_EQUIPMENT PE,
        POS_CONS GA
        	INNER JOIN #dsn_alias#.EMPLOYEES E ON (E.EMPLOYEE_ID = GA.KASIYER_NO)
    WHERE
    
       
    	<cfif not session.ep.ehesap>
            B.BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) AND
        </cfif>
        <cfif isdefined("attributes.search_department_id") and len(attributes.search_department_id)>
        	B.BRANCH_ID IN (#attributes.search_department_id#) AND
        </cfif>
        <cfif len(attributes.kasa_numarasi)>
        	GA.KASA_NUMARASI IN (#attributes.kasa_numarasi#) AND
        </cfif>
        <cfif len(attributes.kasiyer_ids)>
        	GA.KASIYER_NO IN (#attributes.kasiyer_ids#) AND
        </cfif>
        <cfif len(attributes.zno)>
        	GA.ZNO = '#attributes.zno#' AND
        </cfif>
        <cfif len(attributes.acik_tutar) and isnumeric(attributes.acik_tutar)>
	     GA.ODEME_ACIK_TUTAR <= #attributes.acik_tutar# AND
		</cfif>
        PE.BRANCH_ID = B.BRANCH_ID AND
        PE.EQUIPMENT_CODE = GA.KASA_NUMARASI AND
    	GA.CON_DATE >= #attributes.startdate# AND GA.CON_DATE < #dateadd('d',1,attributes.finishdate)#
         ORDER BY 
         B.BRANCH_NAME,
          KASIYER,
        GA.CON_DATE 
       
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_znos.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=retail.list_genius_in" method="post" name="search_">
            <cf_box_search>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61504.Kasa Açığı'></cfsavecontent>
                        <cfinput type="text" value="#attributes.acik_tutar#" placeholder="#message#" name="acik_tutar" maxlength="3" onKeyUp="return(FormatCurrency(this,event,0));">
                    </div>
                </div>
                <div class="form-group">
                    <cfsavecontent  variable="message"> Zno</cfsavecontent>
                    <cfinput type="text" value="#attributes.zno#" name="zno" placeholder="#message#">
                </div>
                <div class="form-group medium">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57520.Kasa'></cfsavecontent>
                    <cf_multiselect_check 
                                query_name="GET_KASALAR"  
                                name="kasa_numarasi"
                                option_text="Kasalar" 
                                width="180"
                                option_name="KASA_ADI" 
                                option_value="equipment_code"
                                filter="1"
                                value="#attributes.kasa_numarasi#">
                </div>
                <div class="form-group medium">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='54577.Kasiyer'> </cfsavecontent>
                    <cf_multiselect_check 
                                query_name="get_kasa_kullanicilar"  
                                name="kasiyer_ids"
                                option_text="Kasiyerler" 
                                width="180"
                                option_name="KASIYER" 
                                option_value="employee_id"
                                filter="1"
                                value="#attributes.kasiyer_ids#">
                </div>
                <div class="form-group medium">
                    <cf_multiselect_check 
                                query_name="get_departments_search"  
                                name="search_department_id"
                                option_text="Şube" 
                                width="150"
                                option_name="department_head" 
                                option_value="BRANCH_ID"
                                filter="0"
                                value="#attributes.search_department_id#">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type= "4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent  variable="head"><cf_get_lang dictionary_id='61505.Pos Kasa Teslim Tutanakları'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='61506.Mağaza Adı'></th>
                    <th><cf_get_lang dictionary_id='57520.Kasa'></th>
                    <th><cf_get_lang dictionary_id='54597.Z No'></th>
                    <th><cf_get_lang dictionary_id='54577.Kasiyer'></th>
                    <th ><cf_get_lang dictionary_id='39129.Satış Tutarı'></th>
                    <th ><cf_get_lang dictionary_id='30533.Açık Tutar'></th>
                    <th ><cf_get_lang dictionary_id='61507.Fazla Tutar'></th>
                    <th ><cf_get_lang dictionary_id='61508.Ödenecek Açık Tutar'> </th>
                    
                    <th width="20"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.list_genius_in&event=add','wide')"><i class="fa fa-plus"></i></a></cfoutput></th>
                </tr>
            </thead>
            <tbody>
            <cfif get_znos.recordcount>
                <cfoutput query="get_znos" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>#dateformat(CON_DATE,'dd/mm/yyyy')#</td>
                    <td>#BRANCH_NAME#</td>
                    <td>#KASA_NUMARASI#</td>
                    <td>#zno#</td>
                    <td>#KASIYER#</td>
                    <td style="text-align:right;">#TLFORMAT(SATIS_TOPLAM)#</td>
                    <td>#ACIK_TOPLAM#</td>
                    <td>#FAZLA_TOPLAM#</td>   
                    <td><cfif ODEME_ACIK_TUTAR lt 0>#ODEME_ACIK_TUTAR#<cfelse>0</cfif></td>          
                    <td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.list_genius_in&event=upd&CON_ID=#CON_ID#','wide')"><img src="/images/update_list.gif" border="0"/></a></td>
                </tr>
                </cfoutput>
            </cfif>
            </tbody>
        </cf_grid_list>
        
        <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
            <cfset url_string = ''>
            <cfif len(attributes.kasa_numarasi)>
                <cfset url_string = '#url_string#&kasa_numarasi=#attributes.kasa_numarasi#'>
            </cfif>
            <cfif len(attributes.acik_tutar)>
                <cfset url_string = '#url_string#&acik_tutar=#attributes.acik_tutar#'>
            </cfif>
            <cfif len(attributes.zno)>
                <cfset url_string = '#url_string#&zno=#attributes.zno#'>
            </cfif>
            <cfif len(attributes.startdate)>
                <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif len(attributes.finishdate)>
                <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
            </cfif>
            <cfif isdefined("attributes.search_department_id")>
                <cfset url_string = '#url_string#&search_department_id=#attributes.search_department_id#'>
            </cfif>	
            <cfif isdefined("attributes.kasiyer_ids")>
                <cfset url_string = '#url_string#&kasiyer_ids=#attributes.kasiyer_ids#'>
            </cfif>
            <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="retail.list_genius_in#url_string#">
        
        </cfif>
    </cf_box>
</div>   

