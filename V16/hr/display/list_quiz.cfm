<script type="text/javascript">
if (<cfif isdefined("attributes.draggable")><cfelse>opener.</cfif>document.all.employee_id.value =="")
	{
	alert("<cf_get_lang dictionary_id ='53773.Önce çalışan seçiniz'> !");
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}	
</script>

<cfif not isdefined("attributes.emp_id") or (isdefined("attributes.emp_id") and not len(attributes.emp_id))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='56079.Eksik Parametre'>!");	
            <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
		<cfexit method="exittemplate">
</cfif>
<cfif not isdefined("attributes.position_cat_id")>
	<cfquery datasource="#dsn#" name="get_position_cat_id">
		SELECT POSITION_CAT_ID,POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.emp_id#
	</cfquery>
	<cfset attributes.position_cat_id = get_position_cat_id.POSITION_CAT_ID>
	<cfset attributes.position_id = get_position_cat_id.POSITION_ID>
</cfif>
<cfparam name="attributes.form_type" default=1>

<cfinclude template="../query/get_quizs.cfm">

<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>
<cfif isdefined("attributes.emp_id")>
	<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>

<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<!--- <cfinclude template="../query/get_position_cats.cfm"> --->
<cfquery name="GET_POSITION_CATS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_POSITION_CAT
	ORDER BY 
		POSITION_CAT 
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('hr',34)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform method="post" action="#request.self#?fuseaction=hr.popup_list_quiz#url_str#" name="form1">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
                    <cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Keyword',47046)#">
                </div>
                <div class="form-group">
                    <select name="position_cat_id" id="position_cat_id">
                        <option value=""><cf_get_lang dictionary_id='29536.Tüm kategoriler'> 
                        <cfoutput query="get_position_cats"> 
                            <cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
                                <option value="#position_cat_id#" <cfif attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#
                            <cfelse>
                                <option value="#position_cat_id#">#position_cat#
                            </cfif>
                        </cfoutput> 
                    </select>
                </div>
                <div class="form-group">
                    <select name="form_type" id="form_type" >
                        <option value="0" selected><cf_get_lang dictionary_id='55480.Tüm Formlar'> 
                        <option value="1" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'>
                        <option value="6" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 6>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'>
                    </select>
                </div>
                <div class="form-group"> 
                    <select name="last30_all" id="last30_all" >
                    <option value="1" <cfif isdefined("attributes.last30_all") and attributes.last30_all eq 1>selected</cfif>><cf_get_lang dictionary_id ='56667.Son Kayıtlar'> (30<cf_get_lang dictionary_id='57490.gün'>)
                    <cfoutput>
                        <cfloop from="2003" to="#year(now())#" index="yil">
                            <option value="#yil#" <cfif (isdefined("attributes.last30_all") and (attributes.last30_all eq yil)) or (not isdefined("attributes.last30_all") and yil eq session.ep.period_year)>selected</cfif>>#yil#
                        </cfloop>
                    </cfoutput>
                    <option value="2" <cfif isdefined("attributes.last30_all") and attributes.last30_all eq 2>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'>                  
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>   
        <cf_grid_list>
            <thead>
                <tr> 
                    <th><cf_get_lang dictionary_id='29764.Form'></th>
                    <th width="55"><cf_get_lang dictionary_id='57630.Tip'></th>
                    <th width="100"><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
                    <th width="65"><cf_get_lang dictionary_id='57483.Kayıt'></th>
                    <th width="55"><cf_get_lang dictionary_id='29479.Yayın'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_quizs.recordcount>
                    <cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                    <tr>
                        <td>
                            <a href="##" class="tableyazi"  onClick="add_quiz(#quiz_id#,'#QUIZ_HEAD#')">
                            #QUIZ_HEAD#
                            </a>
                        </td>
                        <td>
                            <cfif 1 IS IS_APPLICATION><cf_get_lang dictionary_id='55116.Başvuru'>
                            <cfelseif 1 IS IS_EDUCATION><cf_get_lang dictionary_id='57419.Eğitim'>
                            <cfelseif 1 IS IS_TRAINER><cf_get_lang dictionary_id='55913.Eğitimci'>
                            <cfelseif 1 IS IS_INTERVIEW><cf_get_lang dictionary_id='55212.Mülakat'>
                            <cfelseif 1 IS IS_TEST_TIME><cf_get_lang dictionary_id='29776.Deneme Süresi'>
                            <cfelse><cf_get_lang dictionary_id='57576.Çalışan'>
                            </cfif>
                        </td>
                        <td> 
                            <cfif len(RECORD_EMP)>
                                #get_emp_info(RECORD_EMP,0,0)#
                            <cfelseif len(record_par)>
                                <cfset attributes.partner_id = RECORD_PAR>
                                <cfinclude template="../query/get_partner2.cfm">
                                #get_partner.company_partner_name# #get_partner.company_partner_surname# 
                            </cfif>
                        </td>
                        <td>#dateformat(record_date,dateformat_style)#</td>
                        <td><cfif IS_ACTIVE IS 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                        <!--- <td>
                            <cfloop query="get_quiz_stages">
                            <cfif get_quiz_stages.STAGE_ID is STAGE>#stage_name#</cfif>
                            </cfloop>
                        </td> --->
                        </tr>
                    </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="8"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isdefined("attributes.position_cat_id")>
                <cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
            </cfif>
            <cfif isdefined("attributes.form_type")>
                <cfset url_str = "#url_str#&form_type=#attributes.form_type#">
            </cfif>
            <cfif isdefined("attributes.last30_all")>
                <cfset url_str = "#url_str#&last30_all=#attributes.last30_all#">
            </cfif>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging 
                    page="#attributes.page#"  
                    maxrows="#attributes.maxrows#" 
                    totalrecords="#attributes.totalrecords#" 
                    startrow="#attributes.startrow#" 
                    adres="hr.popup_list_quiz#url_str#"
                    isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
function add_quiz(id,name)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
